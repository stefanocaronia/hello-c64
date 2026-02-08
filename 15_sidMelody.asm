// ============================================================================
// Esercizio 15: SID - Melodia semplice
// ============================================================================
// Obiettivo:
// - Suonare una sequenza di note usando una tabella dati
// - Spegnere le note con gate OFF (fase Release)
// - Usare waitFrame per il timing
//
// Concetti nuovi:
// - Gate OFF: scrivere waveform SENZA bit 0 → inizia Release
// - Tabella note: array di frequenze lo/hi lette con indice X
// - Terminatore: valore speciale ($00) per segnalare fine tabella
//
// Struttura melodia (ogni nota = 2 byte):
// .byte freqLo, freqHi, freqLo, freqHi, ... $00
//
// Flow:
// 1. Setup SID (volume, ADSR, waveform)
// 2. Loop:
//    a. Leggi freqLo dalla tabella (se $00, ricomincia)
//    b. Leggi freqHi dalla tabella
//    c. Scrivi frequenza nei registri SID
//    d. Gate ON
//    e. Aspetta N frame (durata nota)
//    f. Gate OFF
//    g. Aspetta qualche frame (pausa tra note)
//    h. Avanza indice, torna a (a)
// ============================================================================

#import "lib/timing.asm"

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

// Numeric constants
.label MaxVolume = $0F
.label WaveTriangleGateOn = $11   // %00010001 = triangle + gate ON
.label WaveTriangleGateOff = $10  // %00010000 = triangle + gate OFF
.label NoteDuration = 4        // frame per nota (12 frame = ~0.24s)
.label NotePause = 1             // frame di pausa tra note

// ============================================================================
// SETUP
// ============================================================================
start:
    // TODO 1: Imposta volume globale al massimo
    lda #MaxVolume
    sta SID_VOLUME

    // TODO 2: Imposta ADSR (stesso dell'esercizio 14, o sperimenta)
    lda #%00011001
    sta SID_V1_ATTACK_DECAY
    lda #%11110100
    sta SID_V1_SUSTAIN_RELEASE

    lda #WaveTriangleGateOn
    sta SID_V1_CONTROL

// ============================================================================
// PLAY LOOP
// ============================================================================
playLoop:
    ldy #0
nextNote:
    lda melody,Y
    bne play
    ldy #0
    lda melody,Y
play:
    sta SID_V1_FREQ_HI
    iny
    lda melody,Y
    sta SID_V1_FREQ_LO

    ldx #NoteDuration
    jsr Wait

    iny
    jmp nextNote

// ============================================================================
// DATA - Melodia (coppie freqHi/freqLo, terminata da $00)
// ============================================================================
melody:
    .byte $04,$5A    
    .byte $05,$2D    
    .byte $06,$27    
    .byte $07,$51    
    .byte $08,$B4    
    .byte $0A,$59    
    .byte $0C,$4E    
    .byte $0E,$A2  
    .byte $0C,$4E     
    .byte $0A,$59    
    .byte $08,$B4     
    .byte $07,$51    
    .byte $06,$27   
    .byte $05,$2D   
    .byte $00      
