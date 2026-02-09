// ============================================================
// ESERCIZIO 7: Stampare stringhe con puntatore zero page
// ============================================================
// Obiettivo: Usare un puntatore per stampare stringhe diverse
//            con la stessa routine
//
// Imparerai:
// - Usare (ZP),y per leggere da un indirizzo variabile
// - Passare parametri a una subroutine tramite puntatore
// ============================================================

*=$0801
BasicUpstart2(start)

.const SCREEN = $0400
.label ZP_STRING = $FB  // puntatore alla stringa (2 byte: $FB/$FC)

start:
    // Stampa la prima stringa (riga 0)
    // TODO: Imposta ZP_STRING a puntare a "message1"
    //       (byte basso in $FB, byte alto in $FC)

    lda #<message1
    sta ZP_STRING
    lda #>message1
    sta ZP_STRING+1
    lda #0
    sta offset
    jsr PrintString

    // Stampa la seconda stringa (riga 1, offset +40)
    // TODO: Imposta ZP_STRING a puntare a "message2"

    lda #<message2
    sta ZP_STRING
    lda #>message2
    sta ZP_STRING+1
    lda #40
    sta offset
    jsr PrintString

    jmp *

// ============================================================
// SUBROUTINE: PrintString
// ============================================================
PrintString:
    ldy #0
    ldx offset
!:
    lda (ZP_STRING),y
    beq !+
    sta SCREEN,x
    iny
    inx
    jmp !-
!:
    rts

// ============================================================
// DATI
// ============================================================
message1:
    .byte $08, $05, $0C, $0C, $0F  // H E L L O
    .byte $00

message2:
    .byte $17, $0F, $12, $0C, $04  // W O R L D
    .byte $00

offset: .byte 0
