// ============================================================================
// Esercizio 18: Sprite Collision in IRQ (guidato)
// ============================================================================
// Obiettivo:
// - Muovere sprite 0 nel raster IRQ (1 update/frame)
// - Rilevare collisione sprite 0 <-> sprite 1 con $D01E
// - Mostrare feedback visivo sul bordo
//
// Concetti focus:
// 1) Movimento/input dentro handler IRQ
// 2) Registro collisioni sprite-sprite ($D01E) con bitmask
//
// Nota:
// I due sprite "palla" sono embedded in fondo al file, come richiesto.
// ============================================================================

BasicUpstart2(start)

#import "lib/macros.asm"

// VIC-II
.label VIC_BORDER = $D020
.label VIC_BG = $D021
.label VIC_CTRL1 = $D011
.label VIC_RASTER = $D012
.label VIC_IRQ_STATUS = $D019
.label VIC_IRQ_ENABLE = $D01A

.label VIC_SPR_EN = $D015
.label VIC_SPR_MSB_X = $D010
.label VIC_SPR0_X = $D000
.label VIC_SPR0_Y = $D001
.label VIC_SPR1_X = $D002
.label VIC_SPR1_Y = $D003
.label VIC_SPR0_COLOR = $D027
.label VIC_SPR1_COLOR = $D028
.label VIC_SPR_COLL = $D01E

// CIA + CPU port
.label CIA1_PORT_A = $DC00
.label CIA1_ICR = $DC0D
.label CIA2_ICR = $DD0D
.label CPU_PORT = $01

// KERNAL
.label KERNAL_CLEAR_SCREEN = $E544

// IRQ vector (KERNAL off)
.label IRQ_VEC_LO = $FFFE
.label IRQ_VEC_HI = $FFFF

// Sprite pointers ($07F8-$07FF)
.label SPR_PTR0 = $07F8
.label SPR_PTR1 = $07F9

// Costanti
.label ColorIdle = 6       // blu
.label ColorHit = 2        // rosso
.label ColorBg = 0         // nero

.label MinX = 24
.label MaxX = 232
.label MinY = 50
.label MaxY = 229

.label RasterLine = 120

// Zero page variables (veloci da accedere)
.label joystickState = $02  

start:
    jsr KERNAL_CLEAR_SCREEN
    sei

    // IRQ CIA off
    lda #$7F
    sta CIA1_ICR
    lda CIA1_ICR

    // NMI CIA2 off
    lda #$7F
    sta CIA2_ICR
    lda CIA2_ICR

    // KERNAL/BASIC off, I/O on
    lda #$35
    sta CPU_PORT

    lda #ColorBg
    sta VIC_BG
    lda #ColorIdle
    sta VIC_BORDER

    // Setup sprite 0 e 1:
    // - enable, pointers, colori, posizioni iniziali
    // - MSB X bit 0/1 azzerati (coordinate X nel range 0..255)
    lda #%00000011
    sta VIC_SPR_EN

    lda VIC_SPR_MSB_X
    and #%11111100
    sta VIC_SPR_MSB_X

    lda #$80
    sta SPR_PTR0

    lda #$81
    sta SPR_PTR1

    lda #50
    sta VIC_SPR0_X
    lda #100
    sta VIC_SPR0_Y

    lda #100
    sta VIC_SPR1_X
    lda #100
    sta VIC_SPR1_Y

    lda #ColorIdle
    sta VIC_SPR0_COLOR

    lda #ColorIdle
    sta VIC_SPR1_COLOR

    // Raster setup:
    // - linea IRQ in VIC_RASTER
    // - bit alto raster azzerato in VIC_CTRL1 bit 7
    lda #RasterLine
    sta VIC_RASTER

    lda VIC_CTRL1
    and #%01111111
    sta VIC_CTRL1

    // IRQ setup:
    // - vettore IRQ -> IrqHandler
    // - raster IRQ abilitato (VIC_IRQ_ENABLE bit 0)
    // - pending IRQ pulito con acknowledge su VIC_IRQ_STATUS
    lda #<IrqHandler
    sta IRQ_VEC_LO
    lda #>IrqHandler
    sta IRQ_VEC_HI

    lda VIC_IRQ_ENABLE
    ora #%00000001
    sta VIC_IRQ_ENABLE

    AckRasterIRQ()

    cli

mainLoop:
    // Polling input nel main loop, update logico dentro IRQ
    lda CIA1_PORT_A
    sta joystickState
    jmp mainLoop

// --------------------------------------------------------------------------
// Handler IRQ (1 volta/frame sulla linea scelta)
// --------------------------------------------------------------------------
IrqHandler: {
    SaveRegisters()

    // Verifica sorgente IRQ:
    // - se non e' raster IRQ esce subito
    // - se e' raster IRQ fa acknowledge su VIC_IRQ_STATUS
    lda VIC_IRQ_STATUS
    and #%00000001
    beq exit

    AckRasterIRQ()

    jsr MovementCheck
    jsr CollisionCheck
exit:
    RestoreRegisters()
    rti
}

// SUBROUTINES
CollisionCheck: {
    // Collisione sprite-sprite:
    // - legge $D01E
    // - isola bit0/bit1 (sprite 0/1)
    // - se almeno uno dei due bit e' attivo, bordo rosso
    lda VIC_SPR_COLL
    and #%00000011
    bne hit
    lda #ColorIdle
    sta VIC_BORDER
    jmp !exit+
hit:
    lda #ColorHit
    sta VIC_BORDER
!exit:
    rts
}

MovementCheck: {
    // Movimento sprite 0 da stato joystick campionato nel main loop.
    // Joystick active-low: bit a 0 = direzione premuta.
    lda joystickState
    // Bit 0: Su (0 = premuto)
    lsr
    bcs notUp
    lda VIC_SPR0_Y
    cmp #MinY
    beq notUp
    dec VIC_SPR0_Y
notUp:
    // Bit 1: Giù
    lda joystickState
    lsr
    lsr
    bcs notDown
    lda VIC_SPR0_Y
    cmp #MaxY
    beq notDown
    inc VIC_SPR0_Y
notDown:
    // Bit 2: Sinistra
    lda joystickState
    lsr
    lsr
    lsr
    bcs notLeft
    // Controlla se siamo al minimo (MSB=0 e low=SpriteMinX)
    lda VIC_SPR_MSB_X
    and #%00000001
    bne canMoveLeft           // MSB=1, possiamo andare a sinistra
    lda VIC_SPR0_X
    cmp #MinX
    beq notLeft               // Siamo al bordo sinistro
canMoveLeft:
    // Gestisci wrap 0→255 (deve togliere MSB)
    lda VIC_SPR0_X
    bne justDecLeft           // Se low != 0, decrementa e basta
    // low = 0, togli MSB (256 → 255)
    lda VIC_SPR_MSB_X
    and #%11111110
    sta VIC_SPR_MSB_X
justDecLeft:
    dec VIC_SPR0_X
notLeft:
    // Bit 3: Destra
    lda joystickState
    lsr
    lsr
    lsr
    lsr
    bcs !+
    // Controlla bordo destro
    lda VIC_SPR_MSB_X
    and #%00000001
    beq canMoveRight          // MSB=0, possiamo andare a destra
    lda VIC_SPR0_X
    cmp #MaxX
    bcs !+              // siamo al bordo destro
canMoveRight:
    inc VIC_SPR0_X
    bne !+              // Non ha wrappato, ok
    // Ha wrappato 255→0, setta MSB
    lda VIC_SPR_MSB_X
    ora #%00000001
    sta VIC_SPR_MSB_X
!:
    rts
}

// ============================================================================
// Sprite data embedded
// ============================================================================
*=$2000 "Sprites"

// Sprite 0: palla piena (64 byte)
spriteBallA:
    .byte %00000000, %00000000, %00000000
    .byte %00000000, %00000000, %00000000
    .byte %00000000, %00011111, %00000000
    .byte %00000001, %11111111, %10000000
    .byte %00000011, %11111111, %11000000
    .byte %00000111, %11111111, %11100000
    .byte %00001111, %11111111, %11110000
    .byte %00011111, %11111111, %11111000
    .byte %00011111, %11111111, %11111000
    .byte %00111111, %11111111, %11111100
    .byte %00111111, %11111111, %11111100
    .byte %00111111, %11111111, %11111100
    .byte %00111111, %11111111, %11111100
    .byte %00011111, %11111111, %11111000
    .byte %00011111, %11111111, %11111000
    .byte %00001111, %11111111, %11110000
    .byte %00000111, %11111111, %11100000
    .byte %00000011, %11111111, %11000000
    .byte %00000001, %11111111, %10000000
    .byte %00000000, %00011111, %00000000
    .byte %00000000, %00000000, %00000000
    .byte 0

// Sprite 1: palla con riflesso (64 byte)
spriteBallB:
    .byte %00000000, %00000000, %00000000
    .byte %00000000, %00000000, %00000000
    .byte %00000000, %00111110, %00000000
    .byte %00000001, %11111111, %10000000
    .byte %00000011, %11111111, %11000000
    .byte %00000111, %11111111, %11100000
    .byte %00001111, %11111111, %11110000
    .byte %00011111, %11111111, %11111000
    .byte %00011111, %11001111, %11111000
    .byte %00111111, %10000111, %11111100
    .byte %00111111, %00000011, %11111100
    .byte %00111111, %00000011, %11111100
    .byte %00111111, %10000111, %11111100
    .byte %00011111, %11001111, %11111000
    .byte %00011111, %11111111, %11111000
    .byte %00001111, %11111111, %11110000
    .byte %00000111, %11111111, %11100000
    .byte %00000011, %11111111, %11000000
    .byte %00000001, %11111111, %10000000
    .byte %00000000, %00111110, %00000000
    .byte %00000000, %00000000, %00000000
    .byte 0
