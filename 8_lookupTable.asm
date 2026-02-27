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

// ============================================================================
// Come funziona .lohifill
// ============================================================================
// .lohifill genera DUE tabelle consecutive: prima tutti i byte bassi (lo),
// poi tutti i byte alti (hi). La variabile `i` va da 0 a N-1.
//
// Sintassi: .lohifill <N>, <espressione con i>
//
// L'istruzione qui sopra con SCREEN=$0400 genera 50 byte:
//
// positions.lo:  (25 byte bassi)
//   i=0:  <($0400 + 0*40 + 20)  = <$0414 = $14
//   i=1:  <($0400 + 1*40 + 20)  = <$043C = $3C
//   i=2:  <($0400 + 2*40 + 20)  = <$0464 = $64
//   i=3:  <($0400 + 3*40 + 20)  = <$048C = $8C
//   ...
//   i=24: <($0400 + 24*40 + 20) = <$07B4 = $B4
//
// positions.hi:  (25 byte alti)
//   i=0:  >($0414) = $04
//   i=1:  >($043C) = $04
//   i=2:  >($0464) = $04
//   i=3:  >($048C) = $04
//   ...
//   i=24: >($07B4) = $07
//
// Accesso: con X come indice, positions.lo,X e positions.hi,X
// ti danno i due byte dell'indirizzo della riga X.
//
// ============================================================================
// Senza .lohifill, avresti dovuto scrivere le due tabelle a mano:
// ============================================================================
//
// positions_lo:
//   .byte <(SCREEN + 0*40 + 20)     // = $14
//   .byte <(SCREEN + 1*40 + 20)     // = $3C
//   .byte <(SCREEN + 2*40 + 20)     // = $64
//   // ... una riga per ognuna delle 25 righe schermo
//   .byte <(SCREEN + 24*40 + 20)    // = $B4
//
// positions_hi:
//   .byte >(SCREEN + 0*40 + 20)     // = $04
//   .byte >(SCREEN + 1*40 + 20)     // = $04
//   .byte >(SCREEN + 2*40 + 20)     // = $04
//   // ...
//   .byte >(SCREEN + 24*40 + 20)    // = $07
//
// .lohifill fa tutto questo in UNA riga, con `i` che va da 0 a N-1.
//
// ============================================================================
// Cosa viene generato in memoria (50 byte consecutivi):
// ============================================================================
//
// positions.lo (25 byte):
//   $14, $3C, $64, $8C, $B4, $DC, $04, $2C, $54, $7C, $A4, $CC, $F4,
//   $1C, $44, $6C, $94, $BC, $E4, $0C, $34, $5C, $84, $AC, $D4
//
// positions.hi (25 byte):
//   $04, $04, $04, $04, $04, $04, $05, $05, $05, $05, $05, $05, $05,
//   $06, $06, $06, $06, $06, $06, $07, $07, $07, $07, $07, $07
//
// ============================================================================
