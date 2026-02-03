// ============================================================================
// Esercizio 12b: Raster IRQ (con KERNAL)
// ============================================================================
// Obiettivo: stesso effetto del 12, ma mantenendo il KERNAL attivo.
//
// Differenze dalla versione senza KERNAL:
// - Usiamo $0314/$0315 invece di $FFFE/$FFFF
// - NON salviamo i registri (lo fa già il KERNAL prima di chiamarci)
// - Usiamo JMP $EA31 per mantenere tastiera/cursore funzionanti
//   oppure JMP $EA81 per uscire velocemente (skip keyboard scan)
//
// Pro: puoi usare GETIN, CHROUT, LOAD, SAVE, etc.
// Contro: IRQ leggermente più lento, meno RAM disponibile
// ============================================================================

BasicUpstart2(start)

.const VIC_BORDER = $D020
.const VIC_CTRL1 = $D011
.const VIC_RASTER = $D012
.const VIC_IRQ_STATUS = $D019
.const VIC_IRQ_ENABLE = $D01A

// Con KERNAL attivo, usiamo i vettori in RAM che il KERNAL legge
.const IRQ_VECTOR_LO = $0314
.const IRQ_VECTOR_HI = $0315

// Routine KERNAL per uscire dall'IRQ
.const KERNAL_IRQ_END = $EA81    // Solo cleanup (veloce)
.const KERNAL_IRQ_FULL = $EA31   // Keyboard scan + cleanup (completo)

.const RasterLine = 100

start:
    sei

    // NON disabilitiamo il KERNAL! ($01 rimane $37)

    // Imposta raster line target
    lda #RasterLine
    sta VIC_RASTER

    // Azzera bit 8 della raster line (linea < 256)
    lda VIC_CTRL1
    and #%01111111
    sta VIC_CTRL1

    // Punta il vettore IRQ KERNAL al nostro handler
    // Il KERNAL legge da $0314/$0315 e salta lì
    lda #<IrqHandler
    sta IRQ_VECTOR_LO
    lda #>IrqHandler
    sta IRQ_VECTOR_HI

    // Abilita IRQ raster
    lda #$01
    sta VIC_IRQ_ENABLE

    // Acknowledge eventuali IRQ pendenti
    lda #$01
    sta VIC_IRQ_STATUS

    cli

mainLoop:
    jmp mainLoop

// ============================================================================
// IRQ Handler (versione KERNAL)
// ============================================================================
// IMPORTANTE: Il KERNAL ha GIÀ salvato A/X/Y sullo stack prima di chiamarci!
// Non dobbiamo farlo noi. Alla fine saltiamo a $EA81 che li ripristina.
// ============================================================================
IrqHandler:
    // NON serve: pha / txa / pha / tya / pha
    // Il KERNAL lo ha già fatto!

    // Controlla se è un raster IRQ
    lda VIC_IRQ_STATUS
    and #%00000001
    beq notRaster

    // Acknowledge IRQ (CRITICO!)
    lda #$01
    sta VIC_IRQ_STATUS

    // Effetto: barra viola nel bordo
    lda #4
    sta VIC_BORDER

    ldx #120
!loop:
    dex
    bne !loop-

    lda #6
    sta VIC_BORDER

notRaster:
    // NON serve: pla / tay / pla / tax / pla
    // Lo fa $EA81!

    // Scegli come uscire:
    // JMP $EA31 = continua con keyboard scan, cursor blink, etc. (più lento)
    // JMP $EA81 = solo cleanup e RTI (più veloce, no keyboard nel IRQ)

    jmp KERNAL_IRQ_END    // Usa $EA81 per velocità
    // jmp KERNAL_IRQ_FULL   // Usa $EA31 se vuoi keyboard scan ogni IRQ
