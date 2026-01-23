// ESERCIZIO 9: VIC Bank
// Sposta lo schermo nel bank 1 e scrivi qualcosa.
BasicUpstart2(start)

// TODO: definisci le costanti che ti servono
.const SCREEN = $4400
.const CHAR = $53 // cuoricino

start:
    // 1. Seleziona bank 1 via $DD00

    lda $dd00
    and #%11111100
    ora #%00000010
    sta $dd00

    // 2. Imposta schermo a $4400 via $D018

    lda $d018
    and #%00001111
    ora #%00010000
    sta $d018


    // 3. Scrivi un carattere a $4400
    lda #CHAR
    sta SCREEN

    jmp *
