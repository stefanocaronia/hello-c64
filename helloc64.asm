BasicUpstart2(start)

.const SCREEN = $0400
.const COLOR  = $D800
.const BORDER_COLOR = $D020
.const BACKGROUND_COLOR = $D021

start:
    // Clear screen
    lda #$93      // CLR/HOME (clear screen)
    jsr $ffd2     // KERNAL CHROUT
    
    // Switch to lowercase/uppercase charset
    // lda #$0E
    // jsr $ffd2

    // 1) Imposta colori bordo/sfondo (VIC-II)
    lda #$0                 // 0 = nero
    sta BORDER_COLOR        // border color
    lda #$B                 // 11 = grigio scuro
    sta BACKGROUND_COLOR    // background color

    // 2) Scrivi un carattere a schermo
    lda #$53
    sta SCREEN + 30
    lda #$7
    sta COLOR + 30

// 3) Scrivi 16 caratteri ognuno con un colore diverso
ldx #0
writechars:
    txa 
    sta COLOR,x
    clc
    adc #1
    // lda #$53
    sta SCREEN,x
    inx
    cpx #16
    bne writechars

loop:
    jmp loop