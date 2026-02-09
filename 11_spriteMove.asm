// ============================================================================
// Esercizio 11: Movimento sprite multicolor
// ============================================================================
// Obiettivo: Muovere uno sprite multicolor con i tasti cursore
//
// Concetti nuovi:
// - Importare sprite da file binario (.import binary)
// - Sprite multicolor: $D01C, $D025, $D026
// - MSB per posizione X > 255: $D010
//
// Colori sprite:
// - MC1 (bit pair 01): nero (0)
// - MC2 (bit pair 10): rosa (10)
// - Colore sprite (bit pair 11): verde (5) - da attribs
//
// Registri utili (cercali nella documentazione):
// - $D015: sprite enable
// - $D000/$D001: posizione X/Y sprite 0
// - $D010: MSB posizione X (bit 0 = sprite 0)
// - $D01C: sprite multicolor enable
// - $D025: colore multicolor condiviso 1
// - $D026: colore multicolor condiviso 2
// - $D027: colore sprite 0
// - $07F8: sprite 0 pointer
//
// Input (PETSCII):
// - Cursore su: $91
// - Cursore giù: $11
// - Cursore sinistra: $9D
// - Cursore destra: $1D
// ============================================================================

// Il tuo codice qui...

BasicUpstart2(start)

// Hardware registers (VIC)
.const VIC_BORDER = $D020
.const VIC_BACKGROUND = $D021
.const VIC_SPRITE0_X = $D000
.const VIC_SPRITE0_Y = $D001
.const VIC_SPRITE_MSB = $D010
.const VIC_SPRITE_ENABLE = $D015
.const VIC_SPRITE_MULTICOLOR = $D01C
.const VIC_SPRITE_MC1 = $D025
.const VIC_SPRITE_MC2 = $D026
.const VIC_SPRITE_COLOR = $D027

// Memory addresses
.const SPRITE_POINTERS = $07F8

// KERNAL routines
.const KERNAL_CLEAR_SCREEN = $E544
.const KERNAL_GETIN = $FFE4

// Numeric constants - PETSCII cursor keys
.const KeyUp    = 145  // $91
.const KeyDown  = 17   // $11
.const KeyLeft  = 157  // $9D
.const KeyRight = 29   // $1D

// Numeric constants - sprite bounds
.const SpriteMinX = 24
.const SpriteMaxXLo = 63     // 319 - 256 = 63 (con MSB=1)
.const SpriteMinY = 50
.const SpriteMaxY = 228

start:
    lda #BLACK
    sta VIC_BORDER
    lda #DARK_GREY
    sta VIC_BACKGROUND

    jsr KERNAL_CLEAR_SCREEN

    lda #%00000001
    sta VIC_SPRITE_ENABLE
    sta VIC_SPRITE_MULTICOLOR

    lda #$80
    sta SPRITE_POINTERS

    lda #GREEN
    sta VIC_SPRITE_COLOR

    lda #BLACK
    sta VIC_SPRITE_MC1

    lda #WHITE
    sta VIC_SPRITE_MC2

    lda #posX
    sta VIC_SPRITE0_X
    lda #posY
    sta VIC_SPRITE0_Y

mainLoop:
    jsr KERNAL_GETIN
    cmp #0
    beq mainLoop

    // cmp non cambia il valore di A, quindi si può usare ripetutamente beq o bne (come uno switch)
    cmp #KeyDown; beq down
    cmp #KeyUp; beq up
    cmp #KeyRight; beq right
    cmp #KeyLeft; beq left

    // è stato premuto un altro tasto, torna a mainLoop
    jmp mainLoop
down:
    lda VIC_SPRITE0_Y
    cmp #SpriteMaxY         // confronta Y con limite basso (228)
    beq mainLoop            // se Y == max, non muovere
    inc VIC_SPRITE0_Y
    jmp mainLoop

up:
    lda VIC_SPRITE0_Y
    cmp #SpriteMinY         // confronta Y con limite alto (50)
    beq mainLoop            // se Y == min, non muovere
    dec VIC_SPRITE0_Y
    jmp mainLoop

left:
    // Controlla se X == 24 (MSB=0 e low=24)
    lda VIC_SPRITE_MSB
    and #%00000001
    bne canMoveLeft         // MSB=1, X >= 256, posso andare a sinistra
    lda VIC_SPRITE0_X
    cmp #SpriteMinX         // confronta con 24
    beq mainLoop            // X == 24, bordo sinistro!
canMoveLeft:
    lda VIC_SPRITE0_X
    bne justDecLeft         // se low != 0, decrementa e basta
    // low = 0, devo prima togliere 1 al MSB (256 → 255)
    lda VIC_SPRITE_MSB
    and #%11111110
    sta VIC_SPRITE_MSB
justDecLeft:
    dec VIC_SPRITE0_X
    jmp mainLoop

right:
    // Controlla se X >= 319 (MSB=1 e low >= 63)
    lda VIC_SPRITE_MSB
    and #%00000001
    beq canMoveRight        // MSB=0, X < 256, posso muovermi
    // MSB=1, controlla se low >= 63
    lda VIC_SPRITE0_X
    cmp #SpriteMaxXLo       // 63
    bcs mainLoop            // se low >= 63, stop (X >= 319)
canMoveRight:
    inc VIC_SPRITE0_X
    bne mainLoop            // non ha wrappato, ok
    // ha wrappato 255→0, setta MSB
    lda VIC_SPRITE_MSB
    ora #%00000001
    sta VIC_SPRITE_MSB
    jmp mainLoop

jmp *


// Variables

posX: .byte 172       // centro X: (24 + 319) / 2 ≈ 172
posY: .byte 139       // centro Y: (50 + 228) / 2 ≈ 139

// Dati sprite
*=$2000 "Sprite"
.import binary "assets/sprites/11/testsprite.bin", 0, 64

