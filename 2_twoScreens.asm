#import "lib/timing.asm"

BasicUpstart2(start)

.const SCREEN_A = $0400
.const SCREEN_B = $0C00
.const COLOR  = $D800
.const BORDER_COLOR = $D020
.const BACKGROUND_COLOR = $D021
.const VIC_MEMORY_POINTERS = $D018

.const PNT = $FB
.const PNT2 = $FD

start:
    // Clear screen
    jsr ClearScreen

    // Load the offset value (0-1000) in 2 bytes
    lda #16+40*5; sta offLo
    lda #0; sta offHi

    // Load Screen A memory address in PNT
    lda #<SCREEN_A; sta PNT
    lda #>SCREEN_A; sta PNT+1

    // Load msg A memory address in PNT2
    lda #<msgScreenA; sta PNT2
    lda #>msgScreenA; sta PNT2+1

    // Call Write with PNT and PNT2 
    jsr Write

    // Load Screen B memory address in PNT
    lda #<SCREEN_B; sta PNT
    lda #>SCREEN_B; sta PNT+1

    // Load msg B memory address in PNT2
    lda #<msgScreenB; sta PNT2
    lda #>msgScreenB; sta PNT2+1

    // Call Write with PNT and PNT2 
    jsr Write

mainloop:
    jsr SetScreenA  
    ldx #2*50
    jsr Wait
    jsr SetScreenB
    ldx #2*50
    jsr Wait
    jmp mainloop    
    
end: 
    jmp end

// VARS
.encoding "screencode_upper" 
msgScreenA: .text "SCREEN A"
            .byte 0
msgScreenB: .text "SCREEN B"
            .byte 0
screenAColors: .byte $0,$F,$0 // border, background, text
screenBColors: .byte $8,$6,$7 // border, background, text
currentScreen: .byte %00000000
offLo: .byte 0
offHi: .byte 0
color: .byte $0

// SUBROUTINES
ClearScreen: {
    ldx #$00
loop: 
    lda #$20
    sta SCREEN_A,x
    sta SCREEN_A+$0100,x // 256
    sta SCREEN_A+$0200,x // 512
    sta SCREEN_A+$0300,x // 768
    sta SCREEN_B,x
    sta SCREEN_B+$0100,x // 256
    sta SCREEN_B+$0200,x // 512
    sta SCREEN_B+$0300,x // 768
    inx
    bne loop
    rts
}

// Write "SCREEN A" in screen A area and "SCREEN B" in screen B area
Write: {
    // PNT = PNT + off
    clc
    lda PNT; adc offLo; sta PNT 
    lda PNT+1; adc offHi; sta PNT+1
    ldy #0
loop:
    lda (PNT2),y
    beq end
    sta (PNT),y 
    iny
    jmp loop
end:
    rts
}

SetColor: {
   ldx #$00
loop: 
    sta COLOR,x
    sta COLOR+$0100,x // 256
    sta COLOR+$0200,x // 512
    sta COLOR+$0300,x // 768
    inx
    bne loop
    rts 
}

SetScreenA:
    lda screenAColors; sta BORDER_COLOR        
    lda screenAColors + 1; sta BACKGROUND_COLOR
    lda VIC_MEMORY_POINTERS
    and #%00001111   // keep charset
    ora #%00010000   // screen index = 1 → $0400 (SCREEN_A)
    sta VIC_MEMORY_POINTERS
    lda screenAColors + 2
    jsr SetColor
    rts

SetScreenB:
    lda screenBColors; sta BORDER_COLOR        
    lda screenBColors + 1; sta BACKGROUND_COLOR
    lda VIC_MEMORY_POINTERS
    and #%00001111   // keep charset
    ora #%00110000   // screen index = 3 → $0C00 (SCREEN_B)
    sta VIC_MEMORY_POINTERS
    lda screenBColors + 2
    jsr SetColor
    rts



