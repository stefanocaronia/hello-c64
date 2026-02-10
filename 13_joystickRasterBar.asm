// ============================================================================
// Esercizio 13: Joystick + Raster Status Bar
// ============================================================================
// Obiettivo:
// - Muovere uno sprite con il joystick (porta 2)
// - Status bar colorata in alto usando raster IRQ
//
// Concetti nuovi:
// - Lettura joystick da $DC00 (CIA1 Port A)
// - Raster split: due IRQ per frame (status bar + area gioco)
// - Re-programmare la linea IRQ nell'handler
//
// Layout schermo:
// ┌────────────────────────────────┐
// │ ████ STATUS BAR ████          │ ← Linee 0-49 (colore diverso)
// ├────────────────────────────────┤ ← IRQ linea 50: cambia colore
// │                                │
// │         [sprite]               │ ← Area gioco
// │                                │
// └────────────────────────────────┘ ← IRQ linea 250: prepara status bar
//
// Joystick porta 2 ($DC00):
// - Bit 0 = Su      (0 = premuto)
// - Bit 1 = Giù     (0 = premuto)
// - Bit 2 = Sinistra(0 = premuto)
// - Bit 3 = Destra  (0 = premuto)
// - Bit 4 = Fuoco   (0 = premuto)
// ============================================================================

BasicUpstart2(start)

// Hardware registers (VIC)
.label VIC_BORDER = $D020
.label VIC_BACKGROUND = $D021
.label VIC_SPRITE0_X = $D000
.label VIC_SPRITE0_Y = $D001
.label VIC_SPRITE_MSB = $D010
.label VIC_SPRITE_ENABLE = $D015
.label VIC_SPRITE_MULTICOLOR = $D01C
.label VIC_CTRL1 = $D011
.label VIC_RASTER = $D012
.label VIC_IRQ_STATUS = $D019
.label VIC_IRQ_ENABLE = $D01A
.label VIC_SPRITE_COLOR = $D027
.label VIC_SPRITE_MC1 = $D025
.label VIC_SPRITE_MC2 = $D026
// Hardware registers (CIA)
.label CIA1_PORT_A = $DC00
.label CIA1_ICR = $DC0D          // Interrupt Control Register

// Memory addresses
.label SPRITE_POINTERS = $07F8
.label CPU_PORT = $01

// Zero page variables (veloci da accedere)
.label joystickState = $02        // Stato joystick letto dal main loop

// Numeric constants - colors
.label ColorBlack = 0
.label ColorWhite = 1
.label ColorRed = 2
.label ColorCyan = 3
.label ColorBlue = 6
.label ColorYellow = 7
.label ColorPink = 10
.label ColorGreen = 5
.label ColorDarkGray = 11
.label ColorLightBlue = 14

// IRQ Vector
.label IRQ_RAM_VECTOR_LO = $FFFE
.label IRQ_RAM_VECTOR_HI = $FFFF

// Numeric constants - raster lines
.label RasterStatusBar = 50
.label RasterGameArea = 62

// Numeric constants - sprite bounds
.label SpriteMinX = 24
.label SpriteMaxX = 319
.label SpriteMaxXLo = 63          // 319 - 256 = 63 (quando MSB=1)
.label SpriteMinY = 50
.label SpriteMaxY = 229

// Screen address
.label SCREEN = $0400

#import "lib/screen.asm"
#import "lib/macros.asm"

// ============================================================================
// SETUP
// ============================================================================
start:
    jsr ClearScreen

    // TODO 1: Disabilita IRQ (SEI)
    sei

    // Disabilita IRQ del CIA1 (timer, etc.) - altrimenti crashano senza KERNAL
    lda #$7F
    sta CIA1_ICR
    lda CIA1_ICR          // Clear pending

    // TODO 2: Disabilita KERNAL ($35 in CPU_PORT)
    lda #$35
    sta CPU_PORT

    // TODO 3: Configura colori iniziali (border e background per area gioco)
    lda #ColorBlack
    sta VIC_BORDER
    lda #ColorDarkGray
    sta VIC_BACKGROUND

    // TODO 4: Abilita sprite 0, imposta colore e pointer
    lda #%00000001
    sta VIC_SPRITE_ENABLE
    sta VIC_SPRITE_MULTICOLOR

    lda #$80
    sta SPRITE_POINTERS

    lda #ColorGreen
    sta VIC_SPRITE_COLOR

    lda #ColorBlack
    sta VIC_SPRITE_MC1

    lda #ColorPink
    sta VIC_SPRITE_MC2

    // TODO 5: Posiziona sprite al centro
    lda #170
    sta VIC_SPRITE0_X

    lda #125
    sta VIC_SPRITE0_Y

    // TODO 6: Imposta primo IRQ raster (RasterStatusBar)
    //         - Scrivi linea in VIC_RASTER
    //         - Azzera bit 7 di VIC_CTRL1
    lda #RasterStatusBar
    sta VIC_RASTER
    
    lda VIC_CTRL1
    and #%01111111
    sta VIC_CTRL1

    // TODO 7: Punta vettore IRQ ($FFFE/$FFFF) a IrqHandler
    lda #<IrqHandler
    sta IRQ_RAM_VECTOR_LO
    lda #>IrqHandler
    sta IRQ_RAM_VECTOR_HI

    // TODO 8: Abilita raster IRQ in VIC_IRQ_ENABLE
    lda VIC_IRQ_ENABLE
    ora #%00000001
    sta VIC_IRQ_ENABLE

    // TODO 9: Acknowledge eventuali IRQ pendenti
    lda #$01
    sta VIC_IRQ_STATUS

    // TODO 10: Riabilita IRQ (CLI)
    cli

// ============================================================================
// MAIN LOOP - legge input (come Update in Unity)
// ============================================================================
mainLoop:
    lda CIA1_PORT_A
    sta joystickState
    jmp mainLoop

// ============================================================================
// IRQ HANDLER
// ============================================================================
IrqHandler: {
    // TODO 17: Salva registri (A, X, Y)s
    SaveRegisters()

    // TODO 18: Acknowledge IRQ (scrivi $01 in VIC_IRQ_STATUS)
    lda VIC_IRQ_STATUS
    and #%00000001
    bne !isRasterIrq+     // È un raster IRQ, continua
    jmp continue          // Non è raster, esci
!isRasterIrq:

    lda #$01
    sta VIC_IRQ_STATUS

    // TODO 19: Leggi VIC_RASTER per sapere dove siamo
    //          - Se siamo a RasterStatusBar:
    //            * Cambia colori per status bar (es. rosso)
    //            * Imposta prossimo IRQ a RasterGameArea
    //          - Se siamo a RasterGameArea:
    //            * Cambia colori per area gioco (es. blu)
    //            * Imposta prossimo IRQ a RasterStatusBar
    lda VIC_RASTER
    cmp #RasterStatusBar
    beq setStatusBarColor
    cmp #RasterGameArea
    beq setGameAreaColor
    jmp continue

setStatusBarColor:
    lda #ColorWhite
    sta VIC_BACKGROUND
    lda #RasterGameArea
    sta VIC_RASTER
    jmp continue

setGameAreaColor:
    lda #ColorBlue
    sta VIC_BACKGROUND
    lda #RasterStatusBar
    sta VIC_RASTER

    // ========== JOYSTICK (una volta per frame, come FixedUpdate) ==========
    lda joystickState

    // Bit 0: Su (0 = premuto)
    lsr
    bcs notUp
    lda VIC_SPRITE0_Y
    cmp #SpriteMinY
    beq notUp
    dec VIC_SPRITE0_Y
notUp:

    // Bit 1: Giù
    lda joystickState
    lsr
    lsr
    bcs notDown
    lda VIC_SPRITE0_Y
    cmp #SpriteMaxY
    beq notDown
    inc VIC_SPRITE0_Y
notDown:

    // Bit 2: Sinistra
    lda joystickState
    lsr
    lsr
    lsr
    bcs notLeft
    // Controlla se siamo al minimo (MSB=0 e low=SpriteMinX)
    lda VIC_SPRITE_MSB
    and #%00000001
    bne canMoveLeft           // MSB=1, possiamo andare a sinistra
    lda VIC_SPRITE0_X
    cmp #SpriteMinX
    beq notLeft               // Siamo al bordo sinistro
canMoveLeft:
    // Gestisci wrap 0→255 (deve togliere MSB)
    lda VIC_SPRITE0_X
    bne justDecLeft           // Se low != 0, decrementa e basta
    // low = 0, togli MSB (256 → 255)
    lda VIC_SPRITE_MSB
    and #%11111110
    sta VIC_SPRITE_MSB
justDecLeft:
    dec VIC_SPRITE0_X
notLeft:

    // Bit 3: Destra
    lda joystickState
    lsr
    lsr
    lsr
    lsr
    bcs notRight
    // Controlla se siamo al massimo (MSB=1 e low>=SpriteMaxXLo)
    lda VIC_SPRITE_MSB
    and #%00000001
    beq canMoveRight          // MSB=0, possiamo andare a destra
    lda VIC_SPRITE0_X
    cmp #SpriteMaxXLo
    bcs notRight              // low >= 63, siamo al bordo destro
canMoveRight:
    inc VIC_SPRITE0_X
    bne notRight              // Non ha wrappato, ok
    // Ha wrappato 255→0, setta MSB
    lda VIC_SPRITE_MSB
    ora #%00000001
    sta VIC_SPRITE_MSB
notRight:
    jmp continue

continue:

    // TODO 20: Ripristina registri
    RestoreRegisters()

    // TODO 21: RTI
    rti
}

// ============================================================================
// DATA
// ============================================================================
*=$2000 "Sprite"
// TODO: importa il tuo sprite binary qui
.import binary "assets/sprites/11/testsprite.bin", 0, 64



