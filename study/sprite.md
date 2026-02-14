# Sprite

Il VIC-II gestisce 8 sprite hardware, numerati 0-7.

## Caratteristiche

- Dimensione: 24×21 pixel
- Colori: 1 colore per sprite (modalità standard)
- Espandibili 2× in X e/o Y
- Priorità e collisioni hardware

## Registri principali

| Registro | Uso |
|----------|-----|
| $D000-$D00F | Posizioni X/Y (coppie per sprite 0-7) |
| $D010 | MSB posizione X (bit 8 per ogni sprite) |
| $D015 | Sprite enable (bit 0-7) |
| $D017 | Espansione Y |
| $D01B | Priorità sprite/sfondo |
| $D01C | Modalità multicolor |
| $D01D | Espansione X |
| $D01E | Collisioni sprite-sprite |
| $D01F | Collisioni sprite-sfondo |
| $D027-$D02E | Colori sprite 0-7 |

## Sprite pointer

Gli ultimi 8 byte dello schermo contengono i puntatori agli sprite:

| Screen default | Puntatore |
|----------------|-----------|
| $07F8 | Sprite 0 |
| $07F9 | Sprite 1 |
| ... | ... |
| $07FF | Sprite 7 |

**Calcolo:** pointer = indirizzo_sprite / 64

Esempio: sprite a $2000 → pointer = $2000/64 = 128 = $80

## Sprite data

Ogni sprite occupa 64 byte:
- 21 righe × 3 byte = 63 byte
- 1 byte padding

```asm
*=$2000 "Sprite"
sprite0:
    .byte %00000000, %11111000, %00000000  // riga 0
    .byte %00000011, %11111110, %00000000  // riga 1
    // ... altre 19 righe ...
    .byte 0  // byte 64 (padding)
```

## Esempio completo

```asm
.const SPRITE_ENABLE = $D015
.const SPRITE0_X = $D000
.const SPRITE0_Y = $D001
.const SPRITE0_COLOR = $D027
.const SPRITE0_PTR = $07F8

start:
    // 1. Abilita sprite 0
    lda #%00000001
    sta SPRITE_ENABLE

    // 2. Posizione
    lda #100
    sta SPRITE0_X
    lda #100
    sta SPRITE0_Y

    // 3. Colore
    lda #2          // rosso
    sta SPRITE0_COLOR

    // 4. Pointer (sprite a $2000)
    lda #$80        // $2000/64 = 128
    sta SPRITE0_PTR

    jmp *

*=$2000 "Sprite"
    // 64 byte di dati sprite...
```

## Posizione X > 255

La coordinata X può andare da 0 a 320+. Per X > 255, usa il registro $D010:

```asm
// Sprite 0 a X=300
lda #44           // 300 - 256 = 44
sta $D000
lda $D010
ora #%00000001    // set bit 0 (MSB per sprite 0)
sta $D010
```

## Multicolor sprite

In modalità multicolor, lo sprite usa 4 colori ma risoluzione dimezzata (12×21):

```asm
lda $D01C
ora #%00000001    // sprite 0 multicolor
sta $D01C

// Colori condivisi
lda #1
sta $D025         // colore multicolor 0
lda #2
sta $D026         // colore multicolor 1
// $D027 rimane il colore principale dello sprite
```

## Collisioni hardware

- `$D01E`: collisioni sprite-sprite
- `$D01F`: collisioni sprite-sfondo (background)
- Ogni bit corrisponde allo sprite 0-7.
- I bit restano settati finche' non leggi il registro (la lettura lo resetta).
- La collisione sprite-sfondo avviene contro pixel "attivi" del background, non solo per presenza di una cella char.

Esempio rapido (`sprite 0` contro `sprite 1`):

```asm
lda $D01E
and #%00000011
cmp #%00000011
beq collisione
```

## Tool consigliati

- **SpritePad** - Editor sprite per C64
- **Spritemate** - Editor online
