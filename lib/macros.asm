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