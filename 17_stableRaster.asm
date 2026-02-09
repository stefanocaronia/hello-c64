// ============================================================================
// Esercizio 17: Stable Raster IRQ (double IRQ)
// ============================================================================
// Obiettivo:
// - Ridurre il jitter raster usando due IRQ in sequenza (arm + stable)
// - Disegnare una linea bordo "ferma" (stabile) sempre alla stessa altezza
//
// Concetti nuovi (max 2):
// 1) Double IRQ: primo IRQ "arma" il secondo su riga successiva
// 2) Handler con timing fisso per effetto raster piu stabile
//
// Nota didattica:
// Questo file e' volutamente guidato con TODO. Completa i passi uno alla volta.
// ============================================================================

BasicUpstart2(start)

#import "lib/macros.asm"

// VIC-II
.label VIC_CTRL1 = $D011
.label VIC_RASTER = $D012
.label VIC_IRQ_STATUS = $D019
.label VIC_IRQ_ENABLE = $D01A
.label VIC_BORDER = $D020
.label VIC_BG = $D021

// CIA + CPU port
.label CIA1_ICR = $DC0D
.label CIA2_ICR = $DD0D
.label CPU_PORT = $01

// IRQ vector (KERNAL off)
.label IRQ_VEC_LO = $FFFE
.label IRQ_VEC_HI = $FFFF

// Costanti
.label RasterBase = 120
.label ColorIdle = 6       // blu
.label ColorStable = 2     // rosso

start:
    sei

    // Spegni IRQ CIA1
    lda #$7F
    sta CIA1_ICR
    lda CIA1_ICR

    // Spegni NMI CIA2
    lda #$7F
    sta CIA2_ICR
    lda CIA2_ICR

    // KERNAL/BASIC off, I/O on
    lda #$35
    sta CPU_PORT

    // Colori base
    lda #0
    sta VIC_BG
    lda #ColorIdle
    sta VIC_BORDER

    // Raster target iniziale (bit alto = 0)
    lda VIC_CTRL1
    and #%01111111
    sta VIC_CTRL1

    // Primo vettore: IrqArm
    SetArmIRQ()

    // Abilita raster IRQ + clear pending
    lda #$01
    sta VIC_IRQ_ENABLE
    sta VIC_IRQ_STATUS

    cli

mainLoop:
    jmp mainLoop

// IRQ 1: "arma" il secondo IRQ su riga successiva
IrqArm: {
    SaveRegisters()

    lda VIC_IRQ_STATUS
    and #%00000001
    beq exit

    // Ack raster IRQ corrente
    AckRasterIRQ()

    // TODO 1: imposta il prossimo IRQ su RasterBase+1 (scrivi in VIC_RASTER)
    SetStableIRQ()

exit:
    RestoreRegisters()
    rti
}

// IRQ 2: zona a timing piu stabile
IrqStable: {
    SaveRegisters()

    lda VIC_IRQ_STATUS
    and #%00000001
    beq exit

    // Ack raster IRQ corrente
    AckRasterIRQ()

    // TODO 3 (timing fisso):
    // aggiungi un piccolo delay deterministico (es. 6-10 cicli circa)
    // Suggerimento: una coppia di NOP e' sufficiente per iniziare.
    nop
    nop

    // Marker visivo: "linea stabile"
    lda #ColorStable
    sta VIC_BORDER

    ldx #251 
!:
    dex
    bne !-

    lda #ColorIdle
    sta VIC_BORDER

    // TODO 4: riporta il prossimo target raster a RasterBase
    // TODO 5: ripunta il vettore a IrqArm
    SetArmIRQ()

exit:
    RestoreRegisters()
    rti
}

.macro SetArmIRQ() {
    lda #RasterBase
    sta VIC_RASTER

    lda #<IrqArm
    sta IRQ_VEC_LO
    lda #>IrqArm
    sta IRQ_VEC_HI
}

.macro SetStableIRQ() {
    lda #RasterBase+1
    sta VIC_RASTER

    lda #<IrqStable
    sta IRQ_VEC_LO
    lda #>IrqStable
    sta IRQ_VEC_HI
}

.macro AckRasterIRQ()
{
    lda #$01
    sta VIC_IRQ_STATUS
}
