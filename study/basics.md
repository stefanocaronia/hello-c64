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

## Argomenti avanzati

Vedi file separati:
- [vic-bank.md](vic-bank.md) - VIC-II Bank e $D018
- [charset.md](charset.md) - Charset custom
- [sprite.md](sprite.md) - Sprite
- [raster-irq.md](raster-irq.md) - Raster IRQ
- [joystick.md](joystick.md) - Joystick e CIA
- [sid.md](sid.md) - SID sound chip

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

## Branch troppo lontani (±127 byte)

I branch relativi (`BEQ`, `BNE`, `BCS`, `BCC`, `BMI`, `BPL`, `BVC`, `BVS`) possono saltare solo ±127 byte. Se la destinazione è troppo lontana, inverti la condizione e usa `JMP`:

```asm
// ❌ ERRORE: destinazione troppo lontana
    beq farLabel          // "relative address is illegal"

// ✅ SOLUZIONE: inverti e usa JMP
    bne !skip+            // inverti: BEQ → BNE
    jmp farLabel          // JMP raggiunge qualsiasi indirizzo
!skip:
```

| Istruzione | Range | Byte |
|------------|-------|------|
| `BEQ/BNE/etc.` | ±127 byte | 2 (opcode + offset relativo) |
| `JMP` | 64KB | 3 (opcode + indirizzo assoluto) |

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
