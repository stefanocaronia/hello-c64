# Raster IRQ

## Come funziona il raster

Il VIC-II disegna lo schermo linea per linea, dall'alto verso il basso, 50 volte al secondo (PAL). Il **raster beam** è la posizione corrente del "pennello" che disegna.

```
Linea 0    ────────────────────────  ← bordo superiore
...
Linea 50   ────────────────────────  ← inizio area visibile
...
Linea 250  ────────────────────────  ← fine area visibile
...
Linea 311  ────────────────────────  ← fine frame (PAL)
```

## Raster line register

La linea corrente è leggibile in **9 bit**:
- `$D012` = bit 0-7 (low byte)
- `$D011` bit 7 = bit 8 (high bit)

**In scrittura**: imposta la linea dove scatta l'IRQ raster.

## Abilitare l'IRQ raster

1. **$D01A** (VIC IRQ enable):
   - Bit 0 = Raster IRQ
   - Bit 1 = Sprite-background collision
   - Bit 2 = Sprite-sprite collision
   - Bit 3 = Lightpen

2. **$D019** (VIC IRQ status):
   - **Lettura**: quali IRQ sono scattati (1 = scattato)
   - **Scrittura**: acknowledge (scrivi 1 per cancellare)

## Vettore IRQ

### Con KERNAL attivo ($0314/$0315)
Il KERNAL intercetta l'IRQ e salta a `($0314)`. Salva i registri prima di chiamare il tuo handler.
- Usa `JMP $EA31` per continuare con keyboard/cursor
- Usa `JMP $EA81` per uscire velocemente (solo cleanup)

### Senza KERNAL ($FFFE/$FFFF)
La CPU salta direttamente a `($FFFE)`. Devi gestire tutto tu:
- Salvare A/X/Y
- Acknowledge IRQ
- Ripristinare A/X/Y
- RTI

## Setup tipico (KERNAL off)

```asm
    sei                     // Disabilita IRQ

    lda #$35                // KERNAL off
    sta $01

    lda #<handler           // Vettore IRQ
    sta $FFFE
    lda #>handler
    sta $FFFF

    lda #100                // Linea target
    sta $D012
    lda $D011               // Azzera bit 8
    and #%01111111
    sta $D011

    lda #$01                // Abilita raster IRQ
    sta $D01A

    lda #$01                // Clear pending
    sta $D019

    cli                     // Riabilita IRQ
```

## Handler tipico

```asm
handler:
    pha                     // Salva registri
    txa
    pha
    tya
    pha

    lda $D019               // Controlla tipo IRQ
    and #$01
    beq notRaster

    lda #$01                // Acknowledge (CRITICO!)
    sta $D019

    // ... fai qualcosa ...

notRaster:
    pla                     // Ripristina registri
    tay
    pla
    tax
    pla
    rti                     // Return from Interrupt
```

## Acknowledge: perché è critico

Se non scrivi `$01` in `$D019`, il VIC continua a segnalare l'IRQ. Appena fai RTI, scatta subito un altro IRQ → loop infinito → freeze.

## Raster jitter

L'IRQ non è istantaneo. La CPU deve:
1. Finire l'istruzione corrente (1-7 cicli variabili)
2. Salvare PC e Status
3. Leggere il vettore
4. Eseguire il tuo codice

Questa variazione causa il "tremolio" orizzontale delle barre raster. Per eliminarlo serve la tecnica **stable raster** (double IRQ).

## Processor Port ($01)

| Valore | BASIC | KERNAL | I/O |
|--------|-------|--------|-----|
| $37 | ON | ON | ON |
| $36 | OFF | ON | ON |
| $35 | OFF | OFF | ON |
| $34 | OFF | OFF | OFF |

Con $35: I/O visibile ($D000-$DFFF), KERNAL/BASIC = RAM.

## Setup tipico (KERNAL on)

```asm
    sei                     // Disabilita IRQ

    // NON toccare $01 - KERNAL rimane attivo

    lda #<handler           // Vettore IRQ (RAM KERNAL)
    sta $0314
    lda #>handler
    sta $0315

    lda #100                // Linea target
    sta $D012
    lda $D011
    and #%01111111
    sta $D011

    lda #$01                // Abilita raster IRQ
    sta $D01A

    lda #$01                // Clear pending
    sta $D019

    cli                     // Riabilita IRQ
```

## Handler tipico (KERNAL on)

```asm
handler:
    // NON salvare registri - il KERNAL lo ha già fatto!

    lda $D019
    and #$01
    beq notRaster

    lda #$01                // Acknowledge
    sta $D019

    // ... fai qualcosa ...

notRaster:
    // NON ripristinare registri - lo fa $EA81!
    jmp $EA81               // Cleanup KERNAL + RTI
```

## Confronto: KERNAL on vs off

| Aspetto | KERNAL off | KERNAL on |
|---------|------------|-----------|
| Vettore IRQ | $FFFE/$FFFF | $0314/$0315 |
| Bank switch | `lda #$35 / sta $01` | Non necessario |
| Salva registri | Tu (PHA/TXA/TYA) | KERNAL lo fa per te |
| Ripristina | Tu (PLA/TAY/TAX) | JMP $EA81 |
| Uscita | RTI | JMP $EA81 o $EA31 |
| GETIN funziona | No | Sì |
| RAM disponibile | 64KB | 56KB |
| Velocità IRQ | Più veloce | Overhead KERNAL |

## Quando usare quale

**KERNAL off** (consigliato per giochi):
- Joystick (leggi $DC00 direttamente)
- Massime prestazioni
- Più RAM per grafica/musica

**KERNAL on** (consigliato per utility/primi esperimenti):
- Tastiera con GETIN
- LOAD/SAVE file
- Print con CHROUT

## Leggere tastiera senza KERNAL

La tastiera è una matrice 8x8 via CIA1:

```asm
.const CIA1_PORT_A = $DC00    // Output - colonna
.const CIA1_PORT_B = $DC01    // Input - riga

// Controlla se W è premuto (colonna 1, riga 1)
CheckKeyW:
    lda #%11111101            // Colonna 1 (bit 1 = 0)
    sta CIA1_PORT_A
    lda CIA1_PORT_B
    and #%00000010            // Riga 1
    rts                       // Z=1 se premuto
```

Tasti comuni:
- W: colonna %11111101, riga %00000010
- A: colonna %11111011, riga %00000010
- S: colonna %11011111, riga %00000010
- D: colonna %11111011, riga %00000100
