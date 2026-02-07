# SID (Sound Interface Device) - 6581/8580

## Struttura

3 voci indipendenti + registri globali (filtro, volume).

## Registri per voce

| Offset | Registro | Funzione |
|--------|----------|----------|
| +0 | Freq Lo | Frequenza byte basso |
| +1 | Freq Hi | Frequenza byte alto |
| +2 | PW Lo | Pulse Width lo (solo pulse wave) |
| +3 | PW Hi | Pulse Width hi (bit 0-3) |
| +4 | Control | Waveform + gate |
| +5 | Attack/Decay | A nei 4 bit alti, D nei 4 bassi |
| +6 | Sustain/Release | S nei 4 bit alti, R nei 4 bassi |

### Indirizzi base

| Voce | Base | Range |
|------|------|-------|
| 1 | `$D400` | `$D400-$D406` |
| 2 | `$D407` | `$D407-$D40D` |
| 3 | `$D40E` | `$D40E-$D414` |

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

## Frequenze PAL vs NTSC

Formula: `freq_registro = (nota_Hz * 16777216) / clock_SID`

| Sistema | Clock SID |
|---------|-----------|
| PAL | 985248 Hz |
| NTSC | 1022727 Hz |

Stesso valore registro → nota leggermente diversa (~3.7%).
