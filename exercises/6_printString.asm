// ============================================================
// ESERCIZIO 6: Stampare una stringa
// ============================================================
// Obiettivo: Stampare una stringa terminata da 0 sullo schermo
//
// Imparerai:
// - Loop fino a trovare il byte 0 (terminatore)
// ============================================================

*=$0801
BasicUpstart2(start)

.const SCREEN = $0400

start:
    jsr PrintString
    rts

// ============================================================
// SUBROUTINE: PrintString
// Stampa una stringa puntata da ZP_STRING all'inizio dello schermo
// La stringa deve terminare con 0
// ============================================================
PrintString:
    ldy #0              // Y = offset nella stringa

!:
    lda message,y
    beq !+
    sta SCREEN,y
    iny
    jmp !-
!:  
    rts

// ============================================================
// DATI
// ============================================================
message:
    .byte $08, $05, $0C, $0C, $0F  // H E L L O (screen codes)
    .byte $00                       // terminatore
