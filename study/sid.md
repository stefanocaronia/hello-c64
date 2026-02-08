# SID (Sound Interface Device) - 6581/8580

## Struttura

3 voci indipendenti + registri globali (filtro, volume).

## Registri per voce

| Registro | Voice 1 | Voice 2 | Voice 3 | Funzione |
|----------|---------|---------|---------|----------|
| Freq Lo | `$D400` | `$D407` | `$D40E` | Frequenza byte basso |
| Freq Hi | `$D401` | `$D408` | `$D40F` | Frequenza byte alto |
| PW Lo | `$D402` | `$D409` | `$D410` | Pulse Width lo (8 bit) |
| PW Hi | `$D403` | `$D40A` | `$D411` | Pulse Width hi (bit 0-3, 12 bit totali) |
| Control | `$D404` | `$D40B` | `$D412` | Waveform + gate |
| Atk/Dec | `$D405` | `$D40C` | `$D413` | A nei 4 bit alti, D nei 4 bassi |
| Sus/Rel | `$D406` | `$D40D` | `$D414` | S nei 4 bit alti, R nei 4 bassi |

## Registro Control ($D404 / +4)

```
Bit 0 = GATE      1=nota ON, 0=inizia Release
Bit 4 = Triangle   $11 = triangle + gate
Bit 5 = Sawtooth   $21 = sawtooth + gate
Bit 6 = Pulse      $41 = pulse + gate
Bit 7 = Noise      $81 = noise + gate
```

## ADSR

```
$D405 = %AAAADDDD    Attack (0-15) | Decay (0-15)
$D406 = %SSSSRRRR    Sustain (0-15) | Release (0-15)
```

```
Volume
  |   /\
  |  / .\____        <- Sustain level
  | /  .     \
  |/   .      \
  +----------------> Tempo
  | A  | D | S | R |
```

## Registri globali

| Registro | Indirizzo | Funzione |
|----------|-----------|----------|
| Volume | `$D418` | Bit 0-3 = volume (0-15) |

## Waveform disponibili

| Waveform | Suono |
|----------|-------|
| Triangle | Morbido, flauto |
| Sawtooth | Ricco, buzzy, lead |
| Pulse | Quadra variabile, versatile |
| Noise | Rumore, percussioni, esplosioni |

**No Sine!** Triangle ci si avvicina (solo armoniche dispari).

## Passi per suonare una nota

```asm
// 1. Volume globale
lda #$0F
sta $D418

// 2. ADSR
lda #$09              // A=0 (istantaneo), D=9 (medio)
sta $D405
lda #$F4              // S=15 (max), R=4 (medio)
sta $D406

// 3. Frequenza (es. DO centrale C4 PAL)
lda #$17
sta $D400
lda #$11
sta $D401

// 4. Waveform + Gate ON
lda #$11              // Triangle + gate
sta $D404
```

## Spegnere una nota

```asm
lda #$10              // Triangle SENZA gate (bit 0 = 0)
sta $D404             // Inizia fase Release
```

## Tabella frequenze PAL (A=440Hz)

| Nota | Oct 0 | Oct 1 | Oct 2 | Oct 3 | Oct 4 | Oct 5 | Oct 6 | Oct 7 |
|------|-------|-------|-------|-------|-------|-------|-------|-------|
| C    | $010C | $022D | $045A | $08B4 | $1167 | $22CE | $459C | $8B59 |
| C#   | $0127 | $024E | $049C | $0938 | $1270 | $24E0 | $49C0 | $9380 |
| D    | $0139 | $0271 | $04E2 | $09C4 | $1389 | $2711 | $4E23 | $9C45 |
| D#   | $014B | $0296 | $052D | $0A59 | $14B2 | $2964 | $52C8 | $A590 |
| E    | $015F | $02BE | $057B | $0AF7 | $15ED | $2BDA | $57B4 | $AF68 |
| F    | $0174 | $02E7 | $05CF | $0B9D | $173B | $2E76 | $5CEB | $B9D6 |
| F#   | $018A | $0314 | $0627 | $0C4E | $189C | $3139 | $6272 | $C4E3 |
| G    | $01A1 | $0342 | $0685 | $0D0A | $1A13 | $3426 | $684C | $D099 |
| G#   | $01BA | $0374 | $06E8 | $0DD0 | $1BA0 | $3740 | $6E80 | $DD00 |
| A    | $01D4 | $03A9 | $0751 | $0EA2 | $1D45 | $3A89 | $7512 | $EA24 |
| A#   | $01F0 | $03E0 | $07C1 | $0F81 | $1F02 | $3E04 | $7C08 | $F810 |
| B    | $020E | $041B | $0837 | $106D | $20DA | $41B4 | $8368 | -     |

Ogni ottava raddoppia il valore della precedente (shift left di 1 bit).
B7 non esiste: supererebbe $FFFF (16 bit max).

### Come usare i valori

Il valore a 16 bit va diviso in lo/hi:
```
Esempio: C4 = $1167 → lo = $67, hi = $11
         A4 = $1D45 → lo = $45, hi = $1D
```

```asm
// Per suonare A4 (LA)
lda #$45          // lo byte di $1D45
sta SID_V1_FREQ_LO
lda #$1D          // hi byte di $1D45
sta SID_V1_FREQ_HI
```

## Frequenze PAL vs NTSC

Formula: `freq_registro = (nota_Hz * 16777216) / clock_SID`

| Sistema | Clock SID |
|---------|-----------|
| PAL | 985248 Hz |
| NTSC | 1022727 Hz |

Stesso valore registro → nota leggermente diversa (~3.7%).

## Player SID Factory II (PRG packato)

Quando fai **Pack** in SF2 (output `.prg`), il file contiene:

- driver player
- dati musicali
- entry point di accesso al driver

### Regola importante

Non assumere che il tick sia sempre a `$1003`.

In base al driver/versione del brano, gli indirizzi possono cambiare.  
Nel nostro esercizio, con load a `$1000`, ha funzionato:

- `INIT` = `$1000` (1 sola volta, `A=subtune`)
- `TICK` = `$1006` (1 volta per frame)

Sintomo tipico di entry point sbagliato: **click iniziale e poi silenzio**.

### Integrazione minima corretta

1. `SEI`
2. Disabilita IRQ CIA1 (`$DC0D = $7F`, poi read)
3. Disabilita anche NMI CIA2 (`$DD0D = $7F`, poi read)
4. `sta $01` con `$35` (ROM off, I/O on)
5. `jsr INIT` con `A=0`
6. Raster IRQ: in handler fai `jsr TICK` a ogni frame
7. Ack IRQ con `sta $D019` bit 0

### Zero Page nel pack

Durante il pack SF2 chiede una base ZP (es. `$02`, range `$02-$04`).  
Quella zona viene usata dal driver: evita conflitti con variabili tue in ZP.
