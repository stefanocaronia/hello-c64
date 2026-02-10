// ESERCIZIO 9: VIC Bank
// Sposta lo schermo nel bank 1 e scrivi qualcosa.
BasicUpstart2(start)

#import "lib/screen.asm"

// TODO: definisci le costanti che ti servono
.const SCREEN = $4400
.const CHAR = $01
.const CHARSET = $4000 

start:
    // 1. Seleziona bank 1 via $DD00

    lda $dd00
    and #%11111100
    ora #%00000010
    sta $dd00

    // 2. Imposta schermo a $4400 via $D018

    lda $d018
    and #%00001111
    ora #%00010001
    sta $d018

    // Imposta charset a offset $4000 (mantenendo schermo)
    lda $D018
    and #%11110001
    ora #%00000000    // %100 << 1 = %1000
    sta $D018

    jsr ClearScreen

    // 3. Scrivi un carattere a $4400
    lda #CHAR
    sta SCREEN

    lda #CHAR + 1 
    sta SCREEN +1 

    jmp *


*=CHARSET "Charset"
.import binary "assets/charsets/charset-1.bin"




