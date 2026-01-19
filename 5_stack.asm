// ============================================================
// ESERCIZIO 5: Lo Stack - Salvare e ripristinare registri
// ============================================================
// Obiettivo: Capire come usare PHA/PLA per preservare i registri
//
// Scenario: Vogliamo stampare 3 caratteri diversi sullo schermo
// usando un loop. Ma la subroutine StampaCarattere modifica X.
// Senza salvare X, il nostro loop si rompe!
// ============================================================

*=$0801
BasicUpstart2(start)

.const SCREEN = $0400

start:
    // Stampa 'A', 'B', 'C' nelle prime 3 posizioni dello schermo
    // Screen codes: A=$01, B=$02, C=$03

    ldx #0              // X = posizione sullo schermo (0, 1, 2)
loop:
    txa
    clc
    adc #1              // A = X + 1 (quindi $01, $02, $03 = A, B, C)
    jsr StampaCarattere // stampa il carattere in A alla posizione X

    inx
    cpx #3
    bne loop

    rts

// ============================================================
// SUBROUTINE: StampaCarattere
// Input: A = carattere da stampare, X = posizione
// PROBLEMA: Questa routine modifica X internamente!
// ============================================================
StampaCarattere:
    // Salva X (chi rompe, ripara!)
    txa
    pha

    sta SCREEN,x        // stampa il carattere
    ldx #$FF            // X viene distrutto (simulazione)

    // Ripristina X
    pla
    tax
    rts
