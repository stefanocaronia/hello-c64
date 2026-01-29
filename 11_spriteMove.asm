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

.label BORDER_COLOR = $D020
.label BACKGROUND_COLOR = $D021

.label SPRITE_ENABLE = $D015
.label SPRITE_MULTICOLOR = $D01C
.label SPRITE_COLORS = $D027
.label SPRITE_M1 = $D025
.label SPRITE_M2 = $D026
.label SPRITE_POINTERS = $07F8
.label SPRITE_MSB = $D010

.label SPRITE0_X = $D000
.label SPRITE0_Y = $D001

.label KERNAL_CLEAR_SCREEN = $E544

// Codici PETSCII tasti cursore
.const KEY_UP    = 145  // $91
.const KEY_DOWN  = 17   // $11
.const KEY_LEFT  = 157  // $9D
.const KEY_RIGHT = 29   // $1D

.const GETIN  = $FFE4

// Limiti schermo (sprite 24x21 completamente visibile)
.const SPRITE_MIN_X = 24
.const SPRITE_MAX_X_LO = 63     // 319 - 256 = 63 (con MSB=1)
.const SPRITE_MIN_Y = 50
.const SPRITE_MAX_Y = 228

start:
    lda #BLACK                 
    sta BORDER_COLOR        
    lda #DARK_GREY                 
    sta BACKGROUND_COLOR    

    jsr KERNAL_CLEAR_SCREEN

    lda #%00000001
    sta SPRITE_ENABLE
    sta SPRITE_MULTICOLOR

    lda #$80   
    sta SPRITE_POINTERS

    lda #GREEN
    sta SPRITE_COLORS

    lda #BLACK
    sta SPRITE_M1
    
    lda #WHITE
    sta SPRITE_M2

    lda #posX
    sta SPRITE0_X
    lda #posY 
    sta SPRITE0_Y

mainloop:
    jsr GETIN
    cmp #0
    beq mainloop

    // cmp non cambia il valore di A, quindi si può usare ripetutamente beq o bne (come uno switch)
    cmp #KEY_DOWN; beq down
    cmp #KEY_UP; beq up
    cmp #KEY_RIGHT; beq right
    cmp #KEY_LEFT; beq left

    // è stato premuto un altro tasto, torna a mainloop
    jmp mainloop
down:
    lda SPRITE0_Y
    cmp #SPRITE_MAX_Y       // confronta Y con limite basso (228)
    beq mainloop            // se Y == max, non muovere
    inc SPRITE0_Y
    jmp mainloop

up:
    lda SPRITE0_Y
    cmp #SPRITE_MIN_Y       // confronta Y con limite alto (50)
    beq mainloop            // se Y == min, non muovere
    dec SPRITE0_Y
    jmp mainloop

left:
    // Controlla se X == 24 (MSB=0 e low=24)
    lda SPRITE_MSB
    and #%00000001
    bne canMoveLeft         // MSB=1, X >= 256, posso andare a sinistra
    lda SPRITE0_X
    cmp #SPRITE_MIN_X       // confronta con 24
    beq mainloop            // X == 24, bordo sinistro!
canMoveLeft:
    lda SPRITE0_X
    bne justDecLeft         // se low != 0, decrementa e basta
    // low = 0, devo prima togliere 1 al MSB (256 → 255)
    lda SPRITE_MSB
    and #%11111110
    sta SPRITE_MSB
justDecLeft:
    dec SPRITE0_X
    jmp mainloop

right:
    // Controlla se X >= 319 (MSB=1 e low >= 63)
    lda SPRITE_MSB
    and #%00000001
    beq canMoveRight        // MSB=0, X < 256, posso muovermi
    // MSB=1, controlla se low >= 63
    lda SPRITE0_X
    cmp #SPRITE_MAX_X_LO    // 63
    bcs mainloop            // se low >= 63, stop (X >= 319)
canMoveRight:
    inc SPRITE0_X
    bne mainloop            // non ha wrappato, ok
    // ha wrappato 255→0, setta MSB
    lda SPRITE_MSB
    ora #%00000001
    sta SPRITE_MSB
    jmp mainloop

jmp *


// Variables

posX: .byte 172       // centro X: (24 + 319) / 2 ≈ 172
posY: .byte 139       // centro Y: (50 + 228) / 2 ≈ 139

// Dati sprite
*=$2000 "Sprite"
.import binary "sprites/11/testsprite.bin", 0, 64
