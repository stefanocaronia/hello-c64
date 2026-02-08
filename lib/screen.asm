// ============================================================
// LIBRERIA SCREEN - Operazioni sullo schermo per C64
// ============================================================
// NOTA: Prima di #import, definire .label SCREEN con l'indirizzo
// base dello schermo usato (es. .label SCREEN = $0400)
// ============================================================

// ------------------------------------------------------------
// ClearScreen
// ------------------------------------------------------------
// Riempie 1000 byte di schermo con il carattere spazio ($20).
//
// Input:  nessuno (usa la label SCREEN)
// Output: nessuno
// Modifica: A, X
// ------------------------------------------------------------
ClearScreen: {
    ldx #$00
    lda #$20
!loop:
    sta SCREEN,x
    sta SCREEN+$0100,x
    sta SCREEN+$0200,x
    sta SCREEN+$0300,x
    inx
    bne !loop-
    rts
}

// ------------------------------------------------------------
// SetColor
// ------------------------------------------------------------
// Imposta lo stesso colore su tutta la Color RAM ($D800).
//
// Input:  A = colore (0-15)
// Output: nessuno
// Modifica: A, X
// ------------------------------------------------------------
SetColor: {
    ldx #$00
!loop:
    sta $D800,x
    sta $D800+$0100,x
    sta $D800+$0200,x
    sta $D800+$0300,x
    inx
    bne !loop-
    rts
}
