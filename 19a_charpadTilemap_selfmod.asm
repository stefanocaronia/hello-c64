// ============================================================================
// Esercizio 19a: Come il 19, ma con Self-Modifying Code al posto delle Zero Page
// ============================================================================
// Stesso risultato del 19_charpadTilemap.asm, ma i loop di copia usano
// self-modifying code invece di puntatori in zero page.
//
// Il trucco: invece di cambiare un puntatore in zero page, cambiamo
// direttamente i byte delle istruzioni LDA/STA nel nostro stesso codice.
// ============================================================================

BasicUpstart2(start)

#import "lib/colors.asm"

// VIC
.label VIC_BANK = $DD00
.label VIC_POINTERS = $D018
.label VIC_SCREEN_CONTROL = $D016
.label VIC_BACKGROUND = $D021
.label VIC_BORDER = $D020
.label VIC_MULTICOLOR_1 = $D022
.label VIC_MULTICOLOR_2 = $D023

// MEMORY
.label CHARSET = $5000
.label CHAR_ATTR = $5400
.label MAP = $6000
.label SCREEN = $4400
.label COLOR = $D800

// Niente ZP_SRC / ZP_DST! Non ci servono più.

start:

    // --- Setup VIC-II (identico al 19) ---

    lda VIC_BANK
    and #%11111100
    ora #%00000010
    sta VIC_BANK

    lda #%00010100
    sta VIC_POINTERS

    lda VIC_SCREEN_CONTROL
    and #%11101111
    ora #%00010000
    sta VIC_SCREEN_CONTROL

    lda #COLORS.BLACK
    sta VIC_BORDER
    lda #COLORS.BLACK
    sta VIC_BACKGROUND

    lda #COLORS.DARK_GREY
    sta VIC_MULTICOLOR_1
    lda #COLORS.LIGHT_GREY
    sta VIC_MULTICOLOR_2

    // ========================================================================
    // COPIA MAPPA → SCREEN RAM (self-modifying code)
    // ========================================================================
    // La mappa è 40x25 = 1000 byte = 3 pagine da 256 + 232 byte.
    //
    // In memoria, "LDA MAP,X" diventa 3 byte:
    //   [0] $BD = opcode LDA absolute,X
    //   [1] $00 = byte basso di MAP ($6000)
    //   [2] $60 = byte ALTO di MAP ($6000)  ← questo lo modifichiamo!
    //
    // Facendo INC su quel byte alto, l'istruzione cambia da sola:
    //   LDA $6000,X  →  LDA $6100,X  →  LDA $6200,X
    // ========================================================================

    ldx #0
    ldy #3                  // 3 pagine intere da copiare

copy_map_loop:
    lda MAP,x              // ← SELF-MOD: il byte alto verrà incrementato!
copy_map_sta:
    sta SCREEN,x           // ← SELF-MOD: anche questo byte alto!
    inx
    bne copy_map_loop      // 256 iterazioni (X: 0→1→...→255→0)

    // X è tornato a 0. Incrementiamo i byte alti per la pagina successiva.
    // Usiamo le label per calcolare l'offset corretto e non contare a mano.
    inc copy_map_loop+2    // byte alto di LDA: $60 → $61 → $62
    inc copy_map_sta+2     // byte alto di STA: $44 → $45 → $46
    dey
    bne copy_map_loop

    // Restano 1000 - 768 = 232 byte.
    // Li copiamo con un loop semplice, senza self-mod (non serve per 1 pagina).
    ldx #0
copy_map_tail:
    lda MAP+768,x
    sta SCREEN+768,x
    inx
    cpx #232
    bne copy_map_tail

    // ========================================================================
    // RIEMPI COLOUR RAM (self-modifying code)
    // ========================================================================
    // Per ogni cella: leggi il char dalla mappa, usalo come indice nella
    // tabella attributi, prendi il colore (low nibble), scrivi in Colour RAM.
    //
    // Qui modifichiamo il byte alto di due istruzioni: la LDA che legge
    // dalla mappa e la STA che scrive in Colour RAM.
    // La LDA CHAR_ATTR,X nel mezzo NON va modificata (gli attributi sono
    // solo 64 byte, stanno tutti in una pagina).
    // ========================================================================

    ldx #0
    lda #3
    sta counter             // 3 pagine intere

colour_loop:
    lda MAP,x              // ← SELF-MOD: leggi char dalla mappa
    tay                     // Y = numero del char (indice per gli attributi)
    lda CHAR_ATTR,y         // leggi il colore del char dalla tabella attributi
    and #%00001111          // solo i bit 0-3 (low nibble = colore)
colour_sta:
    sta COLOR,x            // ← SELF-MOD: scrivi in Colour RAM
    inx
    bne colour_loop

    // Incrementa byte alti per la pagina successiva.
    // Usiamo le label così non dobbiamo contare i byte a mano.
    inc colour_loop+2       // byte alto di LDA MAP,X
    inc colour_sta+2        // byte alto di STA COLOR,X
    dec counter
    bne colour_loop

    // Restanti 232 byte
    ldx #0
colour_tail:
    lda MAP+768,x
    tay
    lda CHAR_ATTR,y
    and #%00001111
    sta COLOR+768,x
    inx
    cpx #232
    bne colour_tail

jmp *

// Variables
counter: .byte 0

// ============================================================================
// Dati CharPad (identici al 19)
// ============================================================================

* = CHARSET "Charset"
.import binary "assets/maps/classroom/classroom_charset.bin", 0, $200

* = CHAR_ATTR "Attributes"
.import binary "assets/maps/classroom/classroom_charset_attr.bin", 0, $40

* = MAP "Map"
.import binary "assets/maps/classroom/classroom_map.bin", 0, 1000
