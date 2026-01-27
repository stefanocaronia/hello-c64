# C64 Memory Overview

Mappa semplificata per programmatori. Ogni blocco = $1000 (4KB).

## VIC Bank 0: $0000-$3FFF (Default)

| Indirizzo     | Uso                          | Libero? |
|---------------|------------------------------|---------|
| $0000-$0FFF   | Sistema (vedi dettaglio)     | Parziale |
| $1000-$1FFF   | RAM libera                   | Sì* |
| $2000-$2FFF   | RAM libera                   | Sì |
| $3000-$3FFF   | RAM libera                   | Sì |

*Il VIC vede la **Character ROM** qui, non la RAM. Puoi usarla per dati, ma non per grafica VIC.

### Dettaglio $0000-$0FFF

| Indirizzo     | Uso                          | Libero? |
|---------------|------------------------------|---------|
| $0000-$00FF   | **Zero Page** (vedi sotto)   | Parziale |
| $0100-$01FF   | **Stack** CPU                | No |
| $0200-$03FF   | Buffer input, variabili sistema | No |
| $0400-$07FF   | **Screen RAM** default       | Schermo |
| $0800-$0FFF   | RAM libera (BASIC parte da $0801) | Sì |

### Zero Page libera

| Indirizzo | Uso |
|-----------|-----|
| $02       | Libero (1 byte) |
| $FB-$FE   | Libero (4 byte) - puntatori ZP! |

**Nota:** $FF è usato da BASIC (buffer conversione float). Totale libero: 5 byte.

---

## VIC Bank 1: $4000-$7FFF (Consigliato!)

| Indirizzo     | Uso                          | Libero? |
|---------------|------------------------------|---------|
| $4000-$4FFF   | RAM libera                   | Sì |
| $5000-$5FFF   | RAM libera                   | Sì |
| $6000-$6FFF   | RAM libera                   | Sì |
| $7000-$7FFF   | RAM libera                   | Sì |

**Tutto libero!** Nessun conflitto con sistema. Ideale per giochi.

---

## VIC Bank 2: $8000-$BFFF

| Indirizzo     | Uso                          | Libero? |
|---------------|------------------------------|---------|
| $8000-$8FFF   | RAM libera                   | Sì |
| $9000-$9FFF   | RAM libera                   | Sì* |
| $A000-$AFFF   | BASIC ROM (RAM sotto)        | Se BASIC off |
| $B000-$BFFF   | BASIC ROM (RAM sotto)        | Se BASIC off |

*Il VIC vede la **Character ROM** qui, non la RAM.

---

## VIC Bank 3: $C000-$FFFF

| Indirizzo     | Uso                          | Libero? |
|---------------|------------------------------|---------|
| $C000-$CFFF   | RAM libera                   | Sì |
| $D000-$DFFF   | **I/O** (VIC, SID, CIA)      | **No!** |
| $E000-$EFFF   | KERNAL ROM (RAM sotto)       | Se KERNAL off |
| $F000-$FFFF   | KERNAL ROM (RAM sotto)       | Se KERNAL off |

**Attenzione:** Il VIC non può leggere grafica da $D000-$DFFF (vede I/O, non RAM).

---

## Schema visivo

```
$0000 ┌─────────────────────┐
      │ ZP / Stack / Sistema│ Bank 0
$0400 │ Screen default      │ (VIC vede CharROM
$0800 │ BASIC / Libero      │  a $1000-$1FFF)
$1000 │ Libero (CharROM*)   │
$2000 │ Libero              │
$3000 │ Libero              │
$4000 ├─────────────────────┤
      │                     │ Bank 1
      │   TUTTO LIBERO!     │ ← Consigliato
      │                     │
$8000 ├─────────────────────┤
      │ Libero (CharROM*)   │ Bank 2
$A000 │ BASIC ROM           │
$C000 ├─────────────────────┤
      │ Libero              │ Bank 3
$D000 │ I/O (VIC,SID,CIA)   │ ← Problema!
$E000 │ KERNAL ROM          │
$FFFF └─────────────────────┘
```

---

## Registri I/O principali ($D000-$DFFF)

| Range         | Chip    |
|---------------|---------|
| $D000-$D3FF   | VIC-II  |
| $D400-$D7FF   | SID     |
| $D800-$DBFF   | Color RAM |
| $DC00-$DCFF   | CIA1 (tastiera, joystick) |
| $DD00-$DDFF   | CIA2 (VIC bank, serial) |

---

## Configurazione tipica per giochi

**Bank 1** ($4000-$7FFF):
- $4000-$47FF: Charset custom (2KB)
- $4800-$4BFF: Screen RAM (1KB)
- $4C00-$7FFF: Sprite data, grafica, dati gioco

**Codice** a $0800 o $C000 (fuori dal bank VIC).
