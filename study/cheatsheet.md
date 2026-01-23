## Screen e colori

- Border color: `$D020`
- Background color: `$D021`
- Screen RAM base: `$0400`
- Color RAM base: `$D800`
- [C64 Screen Codes](c64-screen-codes.html)

### Tabella colori

| HEX  | DEC  | Color         |
| ---- | ---- | ------------- |
| `$0` | `0`  | nero          |
| `$1` | `1`  | bianco        |
| `$2` | `2`  | rosso         |
| `$3` | `3`  | ciano         |
| `$4` | `4`  | viola         |
| `$5` | `5`  | verde         |
| `$6` | `6`  | blu           |
| `$7` | `7`  | giallo        |
| `$8` | `8`  | arancione     |
| `$9` | `9`  | marrone       |
| `$A` | `10` | rosa          |
| `$B` | `11` | grigio scuro  |
| `$C` | `12` | grigio        |
| `$D` | `13` | verde chiaro  |
| `$E` | `14` | azzurro       |
| `$F` | `15` | grigio chiaro |

## KERNAL CHROUT ($FFD2)

| Code    | Effect                        |
| ------- | ----------------------------- |
| **$93** | CLR/HOME (clear screen)       |
| **$0E** | Lowercase / Uppercase charset |
| **$8E** | Uppercase / Graphics charset  |

```asm
lda #$93      // CLR/HOME (clear screen)
jsr $ffd2     // CHROUT
```

## VIC-II Bank ($DD00)

Il VIC-II vede solo 16KB alla volta. La memoria 64KB è divisa in 4 bank.

| Bit 0-1 | Bank | Indirizzi       | Note |
|---------|------|-----------------|------|
| `%11`   | 0    | $0000-$3FFF     | Default. Char ROM a $1000 |
| `%10`   | 1    | $4000-$7FFF     | Tutto libero! |
| `%01`   | 2    | $8000-$BFFF     | Char ROM a $9000 |
| `%00`   | 3    | $C000-$FFFF     | I/O a $D000 (problema) |

```asm
// Seleziona bank 1
lda $DD00
and #%11111100    // azzera bit 0-1
ora #%00000010    // imposta %10 = bank 1
sta $DD00
```

**Nota:** I valori sono invertiti! %11 = bank 0, %00 = bank 3.

**Character ROM:** Nel bank 0 e 2, il VIC vede la ROM charset a $1000/$9000 invece della RAM. Nel bank 1 e 3 non c'è questo trucco.

## VIC-II: offset schermo e charset ($D018)

Dentro il bank corrente, $D018 imposta gli offset:
- **Bit 4-7**: schermo (× $0400)
- **Bit 1-3**: charset (× $0800)

| Schermo | Offset | Bit 4-7 |
| ------- | ------ | ------- |
| +$0000  | 0      | %0000   |
| +$0400  | 1      | %0001   |
| +$0800  | 2      | %0010   |
| +$0C00  | 3      | %0011   |

| Charset | Offset | Bit 1-3 |
| ------- | ------ | ------- |
| +$0000  | 0      | %000    |
| +$0800  | 1      | %001    |
| +$1000  | 2      | %010    | ← default (Char ROM in bank 0/2)
| +$1800  | 3      | %011    |
| +$2000  | 4      | %100    |

```asm
// Imposta schermo a offset $0400 (mantenendo charset)
lda $D018
and #%00001111
ora #%00010000
sta $D018

// Imposta charset a offset $2000 (mantenendo schermo)
lda $D018
and #%11110001
ora #%00001000    // %100 << 1 = %1000
sta $D018
```

**Indirizzo finale** = base bank + offset $D018

Esempio bank 1 + offset $0400 → schermo a $4400

## Encoding e stringhe

```asm
.encoding "screencode_upper"
msg: .text "SCREEN A"
     .byte 0
```

## Puntatori in zero page

```asm
PNT  = $FB
PNT2 = $FD

lda #<msg    // low
sta PNT2
lda #>msg    // high
sta PNT2+1

ldy #0
loop:
    lda (PNT2),y
    beq done
    sta (PNT),y
    iny
    bne loop
done:
```

## Offset su puntatore

```asm
clc
lda PNT
adc offLo
sta PNT
lda PNT+1
adc offHi
sta PNT+1
```

## Clear screen (space)

```asm
ldx #$00
loop:
    lda #$20
    sta SCREEN,x
    sta SCREEN+$0100,x
    sta SCREEN+$0200,x
    sta SCREEN+$0300,x
    inx
    bne loop
```

## Wait frame (raster $D012)

```asm
waitFrame:
    lda $d012
    bne waitFrame   // aspetta linea 0
waitNext:
    lda $d012
    beq waitNext    // aspetta che riparta
    rts
```

## Input da tastiera: GETIN ($FFE4)

```asm
jsr $FFE4       // legge tastiera
                // A = codice PETSCII del tasto, oppure 0 se nessun tasto
cmp #65         // confronta con 'A' (PETSCII)
beq handleA     // salta se uguale
```

**Nota:** GETIN restituisce codici **PETSCII**, non screen codes.

| Tasto     | PETSCII (dec) | PETSCII (hex) |
| --------- | ------------- | ------------- |
| 0-9       | 48-57         | $30-$39       |
| A-Z       | 65-90         | $41-$5A       |
| SPACE     | 32            | $20           |
| RETURN    | 13            | $0D           |
| CRSR UP   | 145           | $91           |
| CRSR DOWN | 17            | $11           |
| CRSR LEFT | 157           | $9D           |
| CRSR RIGHT| 29            | $1D           |

## Movimento carattere su schermo

```asm
// Variabili
posX: .byte 20    // colonna 0-39
posY: .byte 12    // riga 0-24

// Wrap-around esempio (down)
inc posY
lda posY
cmp #25           // oltre il bordo?
bne ok
lda #0            // torna a 0
sta posY
ok:
```

## Libreria math (lib/math.asm)

```asm
#import "lib/math.asm"

// Multiply8x8: moltiplica due numeri 8 bit → risultato 16 bit
lda posY
sta mulA          // primo fattore
lda #40
sta mulB          // secondo fattore
lda #0
sta mulBHi        // IMPORTANTE: azzerare!
jsr Multiply8x8
// Risultato in resultLo/resultHi

// Add16: somma valore 8 bit a risultato 16 bit
lda posX
jsr Add16
// resultLo/resultHi ora contiene posY*40 + posX
```

## Simboli assembler: cosa esiste solo a compile-time

Tutti questi spariscono dopo la compilazione. Nel .prg finale ci sono solo bytes.

| Sintassi | Scopo | Riassegnabile? |
|----------|-------|----------------|
| `.const X = 1` | Costante, sostituzione testuale | No |
| `.label X = $FB` | Simbolo = indirizzo fisso | No |
| `.var X = 1` | Variabile assembler (per scripting) | Sì (con `.eval`) |
| `nome:` | Simbolo = indirizzo corrente (`*`) | No |

### `.const` - Costante
```asm
.const SCREEN = $0400     // sostituzione testuale
lda #<SCREEN              // diventa: lda #$00
```

### `.label` - Alias per indirizzo
```asm
.label ZPA = $FB          // ZPA = $FB, appare nel file .sym
sta ZPA                   // scrive a $FB
```

### `.var` e `.eval` - Variabili assembler
```asm
.var counter = 0
.byte counter             // scrive 0
.eval counter = counter + 1
.byte counter             // scrive 1
```
Utile con `.for` per generare dati. Non esiste a runtime.

### Label implicita (con `:`)
```asm
myData: .byte $BE, $EF    // myData = indirizzo corrente
```
Equivale a `.label myData = *` dove `*` è il program counter.

## Variabili runtime

"Variabile" in assembly = label fissa + contenuto modificabile:
```asm
posX: .byte 20            // posX = indirizzo (costante), contenuto = 20
lda posX                  // legge 20
inc posX                  // ora contiene 21
```
La label `posX` non cambia mai. Il byte **a quell'indirizzo** sì.

---

## Indirizzamento indiretto indicizzato (avanzato)

```asm
.const ZPA = $FB   // puntatore zero page (2 byte)

// Scrivi carattere all'indirizzo in ZPA
ldy #0
lda #$53           // carattere da scrivere
sta (ZPA),y        // scrive a indirizzo contenuto in ZPA

// Trucco per color RAM: SCREEN=$0400, COLOR=$D800
// Differenza = $D400, quindi basta aggiungere $D4 al byte alto
lda ZPA+1
clc
adc #$D4
sta ZPA+1          // ora ZPA punta a color RAM
lda #$02           // colore rosso
sta (ZPA),y
```
