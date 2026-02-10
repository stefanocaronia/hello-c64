// MACROS

.macro SaveRegisters()
{
    pha
    txa; pha
    tya; pha
}

.macro RestoreRegisters()
{
    pla; tay    
    pla; tax
    pla
}

.macro AckRasterIRQ()
{
    lda #$01
    sta VIC_IRQ_STATUS
}