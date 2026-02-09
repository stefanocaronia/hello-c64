// ESERCIZIO 10: Sprite
// Fai comparire uno sprite sullo schermo.

BasicUpstart2(start)

.const SPRITE_ENABLE = $D015
.const SPRITE0_X = $D000
.const SPRITE0_Y = $D001
.const SPRITE0_COLOR = $D027
.const SPRITE0_PTR = $07F8     // puntatore sprite 0 (ultimi 8 byte dello schermo)

start:
    // 1. Abilita sprite 0 ($D015, bit 0)
    lda #%00000001
    sta SPRITE_ENABLE

    // 2. Imposta posizione X e Y
    lda #200
    sta SPRITE0_X
    lda #100 
    sta SPRITE0_Y

    // 3. Imposta colore
    lda #2
    sta SPRITE0_COLOR

    // 4. Imposta il puntatore allo sprite data
    lda #$80
    sta SPRITE0_PTR

    jmp *

// Sprite data a $2000 (blocco 128 = $2000/64)
*=$2000 "Sprite"
sprite0:
    // Pallino semplice 24x21 pixel - puoi sostituire con export da SpritePad
    .byte %00000000, %00000000, %00000000
    .byte %00000000, %00000000, %00000000
    .byte %00000000, %00000000, %00000000
    .byte %00000000, %11111000, %00000000
    .byte %00000011, %11111110, %00000000
    .byte %00000111, %11111111, %00000000
    .byte %00001111, %11111111, %10000000
    .byte %00001111, %11111111, %10000000
    .byte %00011111, %11111111, %11000000
    .byte %00011111, %11111111, %11000000
    .byte %00011111, %11111111, %11000000
    .byte %00011111, %11111111, %11000000
    .byte %00011111, %11111111, %11000000
    .byte %00001111, %11111111, %10000000
    .byte %00001111, %11111111, %10000000
    .byte %00000111, %11111111, %00000000
    .byte %00000011, %11111110, %00000000
    .byte %00000000, %11111000, %00000000
    .byte %00000000, %00000000, %00000000
    .byte %00000000, %00000000, %00000000
    .byte %00000000, %00000000, %00000000
    .byte 0  // byte 64 (padding)
