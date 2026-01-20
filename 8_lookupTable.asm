// ESERCIZIO 8: Lookup Table
// Stampa un carattere al centro di ogni riga usando una tabella
// invece di calcolare Y*40 ogni volta.

BasicUpstart2(start)

.const SCREEN = $0400
.label ZP = $FB

start:
    ldx #0
loop:
    lda positions.lo,x
    sta ZP
    lda positions.hi,x
    sta ZP+1

    lda #$53 // cuoricino
    ldy #0
    sta (ZP),y
        
    inx
    cpx #25
    bne loop

jmp *

positions: .lohifill 25, SCREEN + (i*40) + 20
