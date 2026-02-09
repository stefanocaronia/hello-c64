BasicUpstart2(Start)

.const BORDER_COLOR = $D020
    
Start:
    lda #0
    sta BORDER_COLOR
loop:    
    inc BORDER_COLOR
    jmp loop

