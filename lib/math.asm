// ============================================================
// LIBRERIA MATH - Operazioni matematiche per C64
// ============================================================

// ------------------------------------------------------------
// Multiply8x8
// ------------------------------------------------------------
// Moltiplica due numeri a 8 bit, risultato a 16 bit
//
// Input:  mulA = primo fattore (8 bit)
//         mulB = secondo fattore (8 bit)
// Output: resultLo = byte basso del risultato
//         resultHi = byte alto del risultato
//
// Esempio: 12 * 40 = 480
//          mulA=12, mulB=40 -> resultHi:resultLo = $01E0 (480)
// ------------------------------------------------------------
Multiply8x8: {
    lda #0
    sta resultLo
    sta resultHi
    sta mulBHi          // IMPORTANTE: azzera il byte alto di mulB!
    ldx #8              // 8 bit da processare

loop:
    lsr mulA            // shift right mulA, bit 0 -> Carry
    bcc skip            // se Carry=0, salta l'addizione

    // Aggiungi mulB (16 bit) al risultato
    clc
    lda resultLo
    adc mulB
    sta resultLo
    lda resultHi
    adc mulBHi          // FIX: aggiungi anche il byte alto!
    sta resultHi

skip:
    // Shift left mulB (16 bit)
    asl mulB
    rol mulBHi

    dex
    bne loop
    rts
}

// Variabili per Multiply8x8
mulA:     .byte 0       // primo fattore
mulB:     .byte 0       // secondo fattore (byte basso)
mulBHi:   .byte 0       // secondo fattore (byte alto, usato internamente)
resultLo: .byte 0       // risultato byte basso
resultHi: .byte 0       // risultato byte alto


// ------------------------------------------------------------
// Add16
// ------------------------------------------------------------
// Somma un valore a 8 bit a un risultato a 16 bit
//
// Input:  A = valore da sommare
//         resultLo/resultHi = valore attuale
// Output: resultLo/resultHi = risultato
// ------------------------------------------------------------
Add16: {
    clc
    adc resultLo
    sta resultLo
    lda resultHi
    adc #0
    sta resultHi
    rts
}
