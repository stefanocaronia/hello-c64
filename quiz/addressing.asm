// ============================================================================
// Esercizi di indirizzamento - Quiz risolti in chat
// ============================================================================
// Raccolta di mini-esercizi sui vari modi di accedere alla memoria sul 6502.
// Non è necessario che compilino: sono riferimento e ripasso.
// ============================================================================


// ----------------------------------------------------------------------------
// Es. 1: Scrivi $01 alla colonna 15 della riga 10 usando una lookup table
// ----------------------------------------------------------------------------

.label ZP_PTR = $FB

ldx #10
lda rows.lo,x
sta ZP_PTR
lda rows.hi,x
sta ZP_PTR+1

ldy #15
lda #$01
sta (ZP_PTR),y

rows: .lohifill 25, $0400 + (i * 40)


// ----------------------------------------------------------------------------
// Es. 2: Scrivi $01 alla colonna 15 della riga 10 SENZA lookup table.
//        Calcola l'indirizzo a runtime: $0400 + 10*40 + 15
//        Il 6502 non ha MUL. Hint: 40 = 32 + 8, e ASL moltiplica per 2.
//        Il risultato è > 255 quindi serve aritmetica a 16 bit.
// ----------------------------------------------------------------------------

.label SCREEN = $0400
.label ZP_PTR = $FB

// Obiettivo: calcolare 10*40 = 400, usando 40 = 32 + 8
// Quindi: 10*8 + 10*32 = 80 + 320 = 400

lda #0
sta result_hi               // azzera byte alto (parte da 0)

lda #10                     // A = 10
asl                         // A = 20   (10*2)    Carry=0
rol result_hi               // hi = 0   (raccoglie Carry)
asl                         // A = 40   (10*4)    Carry=0
rol result_hi               // hi = 0
asl                         // A = 80   (10*8)    Carry=0
rol result_hi               // hi = 0
sta result_lo               // result = $00:$50 = 80 (N*8) ✓

sta temp                    // temp = 80 (salva N*8 per dopo)

lda result_lo               // A = 80
asl                         // A = 160  (10*16)   Carry=0
rol result_hi               // hi = 0
asl                         // A = 64!! (10*32=320, overflow!) Carry=1
rol result_hi               // hi = 1   (il Carry entra nel bit 0!)
sta result_lo               // result = $01:$40 = 320 (N*32) ✓

// Ora somma: N*32 (320) + N*8 (80) = N*40 (400)
clc                         // pulisci Carry prima della somma
lda result_lo               // A = $40 (byte basso di 320)
adc temp                    // A = $40 + $50 = $90   Carry=0
sta result_lo               // salva byte basso! (mancava prima)
lda result_hi               // A = $01 (byte alto di 320)
adc #0                      // A = $01 + 0 + Carry(0) = $01
sta result_hi               // result = $01:$90 = 400 ✓

// Aggiungi base schermo $0400: 400 + $0400 = $0590
clc                         // pulisci Carry
lda result_lo               // A = $90
adc #<SCREEN                // A = $90 + $00 = $90   Carry=0
sta result_lo               // lo = $90
lda result_hi               // A = $01
adc #>SCREEN                // A = $01 + $04 + Carry(0) = $05
sta result_hi               // result = $05:$90 = riga 10 dello schermo ✓

// Copia in puntatore zero page
lda result_lo               // lo = $90
sta ZP_PTR                  // ZP_PTR = $90
lda result_hi               // hi = $05
sta ZP_PTR+1                // ZP_PTR+1 = $05 → punta a $0590

// Scrivi $01 alla colonna 15 (usando Y come offset)
ldy #15                     // colonna 15
lda #$01                    // carattere da scrivere
sta (ZP_PTR), y             // scrive a $0590 + 15 = $059F ✓

result_lo: .byte 0
result_hi: .byte 0
temp: .byte 0


