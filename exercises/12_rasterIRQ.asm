// ============================================================================
// Esercizio 12: Raster IRQ (minimo)
// ============================================================================
// Obiettivo: far cambiare il colore del bordo quando il raster arriva
//            a una riga specifica (es. 100).
//
// Concetti nuovi:
// - Raster line: $D012 (low) + bit7 di $D011 (high)
// - Abilitare IRQ raster: $D01A bit 0
// - Acknowledge IRQ: scrivere 1 in $D019 bit 0
// - Vettore IRQ KERNAL in RAM: $0314/$0315
// - RTI per tornare al programma
//
// Nota: esercizio "senza catena al KERNAL" (versione semplice).
// ============================================================================

BasicUpstart2(start)

#include "lib/macros.asm"

.const CPU_PORT = $01
.const VIC_BORDER = $D020
.const VIC_CTRL1 = $D011
.const VIC_RASTER = $D012
.const VIC_IRQ_STATUS = $D019
.const VIC_IRQ_ENABLE = $D01A

.const IRQ_VECTOR_LO = $0314
.const IRQ_VECTOR_HI = $0315
.const IRQ_RAM_VECTOR_LO = $FFFE
.const IRQ_RAM_VECTOR_HI = $FFFF

.const RasterLine = 100

start:
    // Disabilita IRQ globali (SEI)
    sei

    // Disabilita KERNAL AND BASIC ROM
    lda #%00110101          
    sta CPU_PORT

    // TODO 2: imposta la raster line target
    lda #RasterLine
    sta VIC_RASTER

    // per questo esercizio il bit alto e' 0 (linea < 256)
    // quindi assicurati che il bit 7 di $D011 sia 0
    lda VIC_CTRL1
    and #%01111111
    sta VIC_CTRL1

    // Punta il vettore IRQ a irqHandler
    lda #<IrqHandler
    sta IRQ_RAM_VECTOR_LO
    lda #>IrqHandler
    sta IRQ_RAM_VECTOR_HI

    // Abilita IRQ raster in $D01A (bit 0)
    lda VIC_IRQ_ENABLE
    ora #%00000001
    sta VIC_IRQ_ENABLE

    // Acknowlege eventuali IRQ pendenti in $D019 (bit 0 = 1)
    lda #$01
    sta VIC_IRQ_STATUS

    // Riabilita IRQ globali (CLI)
    cli

mainLoop:
    jmp mainLoop

IrqHandler:
    // Salva registri che userai (A/X/Y)
    SaveRegisters()

    // Gestisci solo IRQ raster (filtra gli altri)
    lda VIC_IRQ_STATUS
    and #%00000001
    beq notRaster

    // Acknowledge IRQ raster in $D019 (bit 0 = 1)
    lda #$01
    sta VIC_IRQ_STATUS

    // Cambia colore del bordo (toggle o valore fisso)
    lda #4
    sta VIC_BORDER

    ldx #120
!loop:
    dex
    bne !loop-

    lda #6
    sta VIC_BORDER
notRaster:
    // Ripristina registri
    RestoreRegisters()

    // torna al mainloop o passa all'irq del KERNAL
    rti