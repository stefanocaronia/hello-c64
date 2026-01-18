// ============================================================
// ESERCIZIO 4: Muovere un carattere con i tasti cursore
// ============================================================
// Obiettivo:
//   - Mostrare un carattere '*' sullo schermo
//   - Muoverlo con i tasti cursore (su, giu, sinistra, destra)
//   - Cancellare la posizione precedente (scrivere spazio)
//
// Da completare:
//   1. DrawChar: calcola indirizzo = SCREEN + Y*40 + X, poi scrivi il carattere
//   2. mainloop: leggi tastiera, aggiorna posX/posY, ridisegna
//   3. (Bonus) Controlla i bordi: X deve stare tra 0-39, Y tra 0-24
//
// Hint per calcolare Y*40:
//   40 = 32 + 8, quindi Y*40 = Y*32 + Y*8
//   Oppure: moltiplica per 8, salva, moltiplica ancora per 4, somma
// ============================================================

BasicUpstart2(start)
#import "lib/math.asm"

.const SCREEN = $0400
.const COLOR  = $D800
.const GETIN  = $FFE4
.const BORDER_COLOR = $D020
.const BACKGROUND_COLOR = $D021

// Codici PETSCII tasti cursore
.const KEY_UP    = 145  // $91
.const KEY_DOWN  = 17   // $11
.const KEY_LEFT  = 157  // $9D
.const KEY_RIGHT = 29   // $1D

.const CHAR = $53 // cuoricino

.label ZPA = $FB
.label ZPB = $FD

start:
    lda #$B
    sta BORDER_COLOR
    lda #0
    sta BACKGROUND_COLOR

    // Pulisci lo schermo
    jsr ClearScreen

    // Disegna il carattere nella posizione iniziale
    lda #CHAR
    sta towrite
    jsr DrawChar
    
// hangup:
//     jmp hangup

mainloop:
    jsr GETIN
    cmp #0
    beq mainloop

    // cmp non cambia il valore di A, quindi si può usare ripetutamente beq o bne (come uno switch)
    cmp #KEY_DOWN 
    beq down
    cmp #KEY_UP
    beq up
    cmp #KEY_RIGHT
    beq right
    cmp #KEY_LEFT
    beq left

    // è stato premuto un altro tasto, torna a mainloop
    jmp mainloop
down:
    jsr EraseChar
    inc posY
    lda posY
    cmp #25
    bne update
    lda #0
    sta posY
    jmp update
up:
    jsr EraseChar
    dec posY
    lda posY
    cmp #255
    bne update
    lda #24
    sta posY
    jmp update
left:
    jsr EraseChar
    dec posX
    lda posX
    cmp #255
    bne update
    lda #39
    sta posX
    jmp update
right:
    jsr EraseChar
    inc posX
    lda posX
    cmp #40
    bne update
    lda #0
    sta posX
    jmp update
update:
    lda #CHAR
    sta towrite
    jsr DrawChar
    jmp mainloop

// ============================================================
// VARIABILI
// ============================================================
posX: .byte 20          // Posizione iniziale X (colonna 0-39)
posY: .byte 12          // Posizione iniziale Y (riga 0-24)
towrite: .byte $0          

// ============================================================
// SUBROUTINES
// ============================================================

// Disegna il carattere CHAR alla posizione (posX, posY)
DrawChar: {
    // 1. Calcola posY * 40
    lda posY
    sta mulA
    lda #40
    sta mulB
    jsr Multiply8x8
    
    // 2. Aggiungi posX al risultato
    lda posX
    jsr Add16
    
    // 3. Aggiungi SCREEN ($0400) e metti in ZPA
    clc
    lda resultLo
    adc #<SCREEN
    sta ZPA
    lda resultHi
    adc #>SCREEN
    sta ZPA+1
    
    // 4. Scrivi il carattere
    ldy #0
    lda towrite
    sta (ZPA),y
    
    // 5. Scrivi il colore (COLOR = $D800)
    //    Nota: COLOR - SCREEN = $D800 - $0400 = $D400
    //    Quindi basta cambiare il byte alto del puntatore!
    lda ZPA+1
    clc
    adc #$D4            // $04 + $D4 = $D8 (high byte di COLOR)
    sta ZPA+1
    lda #$2              // rosso
    sta (ZPA),y
    
    rts
}

EraseChar:{
    lda #$20
    sta towrite
    jsr DrawChar
    rts
}

ClearScreen: {
    ldx #$00
    lda #$20
loop:
    sta SCREEN,x
    sta SCREEN+$0100,x
    sta SCREEN+$0200,x
    sta SCREEN+$0300,x
    inx
    bne loop
    rts
}