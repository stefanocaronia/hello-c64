// ============================================================================
// Esercizio 9b: Copia Character ROM in RAM
// ============================================================================
// Obiettivo:
// - Copiare i 2048 byte del charset ROM ($D000-$D7FF) in RAM
// - Attivare il charset copiato via VIC-II ($D018)
//
// Concetti nuovi (max 2):
// 1) Mapping Character ROM tramite CPU port $01
// 2) Copia a pagine (8 x 256 byte) con puntatori in zero page
//
// Nota:
// Questo e' un esercizio guidato: completa i TODO uno alla volta.
// ============================================================================

BasicUpstart2(start)

// VIC-II
.label VIC_BORDER = $D020
.label VIC_BG = $D021
.label VIC_MEMORY_POINTERS = $D018
.label VIC_BANK = $DD00

// CPU Port
.label CPU_PORT = $01

// Costanti memoria
.label CHAR_ROM = $D000
.label CHAR_RAM = $3000       // bank 0, slot charset #6

// D018 per screen=$0400 + charset=$3000
// screen offset: $0400 / 1024 = 1  -> bits 4-7 = %0001
// charset offset: $3000 / 2048 = 6 -> bits 1-3 = %110
// valore: %0001_1100 = $1C
.label Screen400_Char3000 = %00011100

// Numero pagine da copiare: 2048 / 256 = 8
.label CharsetPages = 8

// Zero page pointers
.label srcPtr = $FB
.label dstPtr = $FD

.label FullByte = $FF

.const ChangedCharOffset = 8 * 1

start:
    // Importante: blocchiamo gli IRQ durante la finestra CHAREN=0.
    // In quel momento la CPU non vede I/O a $D000-$DFFF ma Character ROM.
    // Se parte l'IRQ KERNAL mentre l'I/O e' "nascosto", puo' comportarsi male.
    sei

    lda #0
    sta VIC_BG
    lda #6
    sta VIC_BORDER

    // Set VIC BANK 0
    lda VIC_BANK
    ora #%00000011
    sta VIC_BANK

    // TODO 1:
    // Salva il valore iniziale di $01 in oldCpuPort
    // (servira' per ripristinare la configurazione alla fine)
    lda CPU_PORT
    sta oldCpuPort

    // TODO 2:
    // Rendi visibile Character ROM alla CPU su area $D000-$DFFF.
    // Suggerimento: usa $01 con CHAREN=0 (es. #$33).
    // $33 lascia RAM sotto ROM e disattiva CHAREN: da CPU leggi davvero la char ROM.
    lda #$33
    sta CPU_PORT

    // TODO 3:
    // Inizializza srcPtr = CHAR_ROM e dstPtr = CHAR_RAM
    // (lo byte e hi byte dei puntatori)
    lda #<CHAR_ROM
    sta srcPtr
    lda #>CHAR_ROM
    sta srcPtr+1

    lda #<CHAR_RAM
    sta dstPtr
    lda #>CHAR_RAM
    sta dstPtr+1

    // TODO 4:
    // Copia 8 pagine da ROM a RAM.
    // Struttura suggerita:
    // - X = contatore pagine (8)
    // - Y = indice byte (0..255)
    // - loop byte: lda (srcPtr),y / sta (dstPtr),y / iny / bne
    // - fine pagina: inc srcPtr+1 / inc dstPtr+1 / dex / bne
    ldx #CharsetPages
    ldy #0
loopChars:
    lda (srcPtr),y
    sta (dstPtr),y
    iny
    bne loopChars
    inc srcPtr+1
    inc dstPtr+1
    dex
    bne loopChars

    // TODO 5:
    // Ripristina il valore originale di $01 da oldCpuPort
    lda oldCpuPort
    sta CPU_PORT

    // Ora che la mappa I/O e' tornata normale, possiamo riabilitare gli IRQ.
    cli

    // TODO 6:
    // Attiva charset in RAM scrivendo VIC_D018 = D018_SCREEN0400_CHAR3000
    lda #Screen400_Char3000
    sta VIC_MEMORY_POINTERS

    // TODO 7 (mini test):
    // Modifica 1 byte in CHAR_RAM per verificare che il charset attivo sia in RAM.
    // Esempio: cambia il primo byte del carattere 0.
    lda #FullByte
    ldx #0
!:  
    sta CHAR_RAM+ChangedCharOffset,X
    inx
    cpx #8
    bne !-

    jmp *


// Variables
oldCpuPort: .byte 0
