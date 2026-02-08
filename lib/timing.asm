// ============================================================
// LIBRERIA TIMING - Sincronizzazione frame per C64 PAL
// ============================================================

// ------------------------------------------------------------
// WaitFrame
// ------------------------------------------------------------
// Aspetta il prossimo inizio frame (transizione raster 311->0).
// Usa bit 7 di $D011 (9° bit raster) per evitare il doppio
// trigger di $D012=0 a riga 0 e riga 256.
//
// Input:  nessuno
// Output: nessuno
// Modifica: flags (N, V tramite BIT)
// ------------------------------------------------------------
WaitFrame: {
    bit $D011
    bpl WaitFrame       // loop while raster < 256
!wait:
    bit $D011
    bmi !wait-          // loop while raster >= 256
    rts
}

// ------------------------------------------------------------
// Wait
// ------------------------------------------------------------
// Aspetta X frame.
//
// Input:  X = numero di frame da aspettare
// Output: X = 0
// ------------------------------------------------------------
Wait: {
!loop:
    jsr WaitFrame
    dex
    bne !loop-
    rts
}
