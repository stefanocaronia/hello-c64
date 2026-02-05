# Joystick su C64

## Registri CIA1

| Registro | Indirizzo | Uso |
|----------|-----------|-----|
| `CIA1_PORT_A` | `$DC00` | Joystick porta 2 (+ keyboard columns) |
| `CIA1_PORT_B` | `$DC01` | Joystick porta 1 (+ keyboard rows) |
| `CIA1_ICR` | `$DC0D` | Interrupt Control Register |

## Bit del joystick (active-low: 0 = premuto)

| Bit | Maschera | Direzione |
|-----|----------|-----------|
| 0 | `%00000001` | Su |
| 1 | `%00000010` | Giù |
| 2 | `%00000100` | Sinistra |
| 3 | `%00001000` | Destra |
| 4 | `%00010000` | Fuoco |

## Lettura base

```asm
lda $DC00           // Joystick porta 2
and #%00000001      // Isola bit 0 (su)
beq isUp            // Se 0, su è premuto
```

## Pattern LSR + BCS (efficiente per direzioni multiple)

```asm
lda $DC00
lsr                 // Bit 0 (su) → Carry
bcs notUp           // Carry=1 → non premuto
// ... gestisci su ...
notUp:
lsr                 // Bit 1 (giù) → Carry
bcs notDown
// ... gestisci giù ...
notDown:
lsr                 // Bit 2 (sinistra) → Carry
bcs notLeft
// ... gestisci sinistra ...
notLeft:
lsr                 // Bit 3 (destra) → Carry
bcs notRight
// ... gestisci destra ...
notRight:
```

**Nota:** LSR modifica A, quindi se devi rileggere lo stato originale, salvalo prima in una variabile.

---

## Joystick con KERNAL disabilitato

Quando disabiliti il KERNAL (`lda #$35 / sta $01`), **devi** disabilitare gli IRQ del CIA1, altrimenti il sistema crasha.

### Perché crasha?

1. Il CIA1 genera IRQ timer regolarmente (~60Hz)
2. Con KERNAL off, `$FFFE/$FFFF` puntano a RAM (garbage)
3. L'IRQ salta a un indirizzo casuale → crash

### Soluzione

```asm
    sei

    // PRIMA di disabilitare il KERNAL:
    lda #$7F
    sta $DC0D         // Disabilita TUTTI gli IRQ del CIA1
    lda $DC0D         // Leggi per clear pending IRQ

    // Ora puoi disabilitare il KERNAL
    lda #$35
    sta $01

    // Imposta il tuo IRQ handler
    lda #<MyHandler
    sta $FFFE
    lda #>MyHandler
    sta $FFFF

    cli
```

### $DC0D - Interrupt Control Register

**Scrittura** (abilita/disabilita sorgenti):
| Bit | Sorgente |
|-----|----------|
| 0 | Timer A |
| 1 | Timer B |
| 2 | Alarm clock |
| 3 | Serial port |
| 4 | FLAG pin |
| 7 | 1=abilita, 0=disabilita i bit selezionati |

`$7F` = `%01111111` → bit 7=0 (disabilita), bit 0-4=1 (tutte le sorgenti)

**Lettura**: mostra quali IRQ sono scattati e li resetta.

---

## Pattern Game Loop (stile Unity)

```asm
.label joystickState = $02    // Zero page (veloce)

// Main loop = Update() - alta frequenza, legge input
mainLoop:
    lda $DC00
    sta joystickState
    jmp mainLoop

// IRQ handler = FixedUpdate() - 50Hz, muove sprite
IrqHandler:
    lda joystickState
    // ... movimento sprite ...
    rti
```

**Vantaggi:**
- Input reattivo (nessun input perso tra IRQ)
- Movimento a velocità costante (50Hz PAL)
- Separazione pulita input/logica

---

## Movimento sprite con X a 9 bit

La posizione X degli sprite va da 0 a 319, ma un byte contiene solo 0-255.
Il bit 8 (MSB) è in `$D010`, un bit per ogni sprite.

### Registri

| Registro | Uso |
|----------|-----|
| `$D000` | Sprite 0 X (bit 0-7) |
| `$D001` | Sprite 0 Y |
| `$D010` | MSB X di tutti gli sprite (bit 0 = sprite 0) |

### Movimento a destra (gestisce wrap 255→256)

```asm
    inc $D000           // Incrementa X low
    bne noWrapRight     // Non ha wrappato, ok
    // Ha wrappato 255→0, setta MSB
    lda $D010
    ora #%00000001      // Setta bit 0
    sta $D010
noWrapRight:
```

### Movimento a sinistra (gestisce wrap 0→255)

```asm
    lda $D000
    bne justDecLeft     // Se X != 0, decrementa e basta
    // X = 0, togli MSB (256→255)
    lda $D010
    and #%11111110      // Clear bit 0
    sta $D010
justDecLeft:
    dec $D000
```

### Controllo bordo destro (X = 319 = 256 + 63)

```asm
    lda $D010
    and #%00000001
    beq canMoveRight    // MSB=0, possiamo andare a destra
    lda $D000
    cmp #63             // 319 - 256 = 63
    bcs atRightEdge     // X >= 63 con MSB=1, siamo al bordo
canMoveRight:
```

### Controllo bordo sinistro (X = 24)

```asm
    lda $D010
    and #%00000001
    bne canMoveLeft     // MSB=1, possiamo andare a sinistra
    lda $D000
    cmp #24
    beq atLeftEdge      // X = 24 con MSB=0, siamo al bordo
canMoveLeft:
```
