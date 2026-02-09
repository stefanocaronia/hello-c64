// ============================================================================
// Esercizio 16: SID Player - Riprodurre musica da SID Factory II
// ============================================================================
// Obiettivo:
// - Caricare una musica packata da SF2 e riprodurla
// - Usare un raster IRQ per chiamare il player ogni frame
//
// Concetti nuovi:
// - Il PRG packato da SF2 contiene driver + dati
// - Due entry point usati qui: MUSIC_INIT (A=subtune) e MUSIC_TICK (1x per frame)
// - Il player va chiamato in un IRQ per timing costante
//
// Flow:
// 1. Disabilita IRQ CIA1 (come esercizio 13)
// 2. Disabilita KERNAL
// 3. Chiama MUSIC_INIT con A=0
// 4. Imposta raster IRQ che chiama MUSIC_TICK ogni frame
// 5. mainLoop: loop infinito (o mostra qualcosa a schermo)
// ============================================================================

BasicUpstart2(start)

#import "lib/macros.asm"
#import "lib/screen.asm"
#import "lib/timing.asm"

// Hardware registers
.label VIC_CTRL1 = $D011
.label VIC_RASTER = $D012
.label VIC_IRQ_STATUS = $D019
.label VIC_IRQ_ENABLE = $D01A
.label VIC_BORDER = $D020
.label VIC_BACKGROUND = $D021
.label CIA1_ICR = $DC0D
.label CIA2_ICR = $DD0D
.label CPU_PORT = $01
.label IRQ_VECTOR_LO = $FFFE
.label IRQ_VECTOR_HI = $FFFF

// Music entry points
.label MUSIC_INIT = $1000
.label MUSIC_TICK = $1006

// Hardware registers - SID Global
.label SID_VOLUME = $D418

// Numeric constants
.label MaxVolume = $0F

.label SCREEN = $0400

// ============================================================================
// SETUP
// ============================================================================
start:
    jsr ClearScreen

    lda #0
    sta VIC_BACKGROUND
    sta VIC_BORDER

    sei

    // TODO 1: Disabilita IRQ CIA1 ($7F in CIA1_ICR, poi leggi per pulire)
    lda #$7F
    sta CIA1_ICR
    lda CIA1_ICR

    // Disabilita anche NMI da CIA2
    lda #$7F
    sta CIA2_ICR
    lda CIA2_ICR

    // TODO 2: Disabilita KERNAL ($35 in CPU_PORT)
    lda #$35          
    sta CPU_PORT

    // TODO 3: Chiama MUSIC_INIT con A=0 (subtune 0)
    lda #0
    jsr MUSIC_INIT

    // TODO 4: Imposta raster IRQ:
    //   - Scrivi linea 0 in VIC_RASTER
    lda #150
    sta VIC_RASTER

    //   - Azzera bit 7 di VIC_CTRL1 (9° bit raster)
    lda VIC_CTRL1
    and #%01111111
    sta VIC_CTRL1

    //   - Punta IRQ_VECTOR a IrqHandler
    lda #<IrqHandler
    sta IRQ_VECTOR_LO
    lda #>IrqHandler
    sta IRQ_VECTOR_HI

    //   - Abilita raster IRQ in VIC_IRQ_ENABLE
    lda VIC_IRQ_ENABLE
    ora #%00000001
    sta VIC_IRQ_ENABLE

    //   - Acknowledge pendenti ($01 in VIC_IRQ_STATUS)
    lda #$01
    sta VIC_IRQ_STATUS

    // Forza volume max ($D418 è write-only, non si può read-modify-write)
    lda #MaxVolume
    sta SID_VOLUME

    cli

// ============================================================================
// MAIN LOOP
// ============================================================================
mainLoop:
    // inc VIC_BORDER    
    
    jmp mainLoop

// ============================================================================
// IRQ HANDLER
// ============================================================================
IrqHandler: {
    SaveRegisters()

    // TODO 5: Verifica che sia un raster IRQ (bit 0 di VIC_IRQ_STATUS)
    lda VIC_IRQ_STATUS
    and #%00000001
    beq done

    // TODO 6: Acknowledge IRQ ($01 in VIC_IRQ_STATUS)
    lda #$01
    sta VIC_IRQ_STATUS

    // TODO 7: Chiama player frame update
    inc VIC_BORDER
    jsr MUSIC_TICK
    dec VIC_BORDER
done:
    RestoreRegisters()
    rti
}

// ============================================================================
// MUSIC DATA
// ============================================================================
*=MUSIC_INIT "Music"
.import binary "assets/music/test2.prg", 2    // skip 2-byte PRG header
