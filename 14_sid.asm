// ============================================================================
// Esercizio 14: SID - Prima nota
// ============================================================================
// Obiettivo:
// - Suonare una singola nota usando la Voce 1 del SID
// - Capire i registri: frequenza, ADSR, waveform, gate, volume
//
// Passi per suonare una nota:
// 1. Impostare il volume globale ($D418)
// 2. Impostare ADSR ($D405/$D406)
// 3. Impostare la frequenza ($D400/$D401)
// 4. Scegliere waveform + gate ON ($D404)
//
// Registro Control ($D404):
// Bit 0 = GATE (1=nota ON, 0=Release)
// Bit 4 = Triangle    ($11 = triangle + gate)
// Bit 5 = Sawtooth    ($21 = sawtooth + gate)
// Bit 6 = Pulse       ($41 = pulse + gate)
// Bit 7 = Noise       ($81 = noise + gate)
//
// ADSR:
// $D405 = %AAAADDDD  (Attack 0-15 nei bit alti, Decay 0-15 nei bassi)
// $D406 = %SSSSRRRR  (Sustain 0-15 nei bit alti, Release 0-15 nei bassi)
// ============================================================================

BasicUpstart2(start)

// Hardware registers - SID Voice 1
.label SID_V1_FREQ_LO = $D400
.label SID_V1_FREQ_HI = $D401
.label SID_V1_PW_LO = $D402
.label SID_V1_PW_HI = $D403
.label SID_V1_CONTROL = $D404
.label SID_V1_ATTACK_DECAY = $D405
.label SID_V1_SUSTAIN_RELEASE = $D406

// Hardware registers - SID Global
.label SID_VOLUME = $D418

// Frequenze note PAL (valori a 16 bit)
// Ottava 4 (middle)
.label FreqC4Lo = $17           // DO
.label FreqC4Hi = $11
.label FreqE4Lo = $31           // MI
.label FreqE4Hi = $15
.label FreqG4Lo = $B5           // SOL
.label FreqG4Hi = $19

// Numeric constants
.label MaxVolume = $0F
.label WaveTriangleGateOn = $11  // %00010001 = triangle + gate
.label WaveSawtoothGateOn = $21  // %00100001 = sawtooth + gate

// ============================================================================
// SETUP
// ============================================================================
start:
    // TODO 1: Imposta il volume globale al massimo (4 bit bassi di SID_VOLUME)
    lda SID_VOLUME
    ora #%00001111
    sta SID_VOLUME

    // TODO 2: Imposta ADSR per Voce 1
    //         Attack=0 (istantaneo), Decay=9 (medio) → $D405
    //         Sustain=15 (max), Release=4 (medio) → $D406
    lda #%00001001
    sta SID_V1_ATTACK_DECAY
    lda #%11110100
    sta SID_V1_SUSTAIN_RELEASE

    // TODO 3: Imposta la frequenza del DO (C4)
    //         Scrivi FreqC4Lo in SID_V1_FREQ_LO
    //         Scrivi FreqC4Hi in SID_V1_FREQ_HI
    lda #FreqC4Lo
    sta SID_V1_FREQ_LO
    lda #FreqC4Hi
    sta SID_V1_FREQ_HI    

    // TODO 4: Scegli waveform triangle e apri il gate (nota ON)
    //         Scrivi WaveTriangleGateOn in SID_V1_CONTROL
    lda #%00010001
    sta SID_V1_CONTROL

    // La nota suona! Loop infinito
    jmp *
