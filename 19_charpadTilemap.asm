// ============================================================================
// Esercizio 19: CharPad Tilemap - Visualizzazione aula
// ============================================================================
// Obiettivo:
// - Caricare charset, mappa e attributi esportati da CharPad
// - Configurare il VIC-II per Text Multi-colour
// - Visualizzare la mappa a schermo con i colori corretti
//
// Concetti nuovi:
// 1) Import di dati binari da CharPad
// 2) Setup VIC per Text Multicolour
// 3) Riempimento Colour RAM dagli attributi dei char
//
// File CharPad esportati in assets/maps/classroom/
// ============================================================================

BasicUpstart2(start)

#import "lib/colors.asm"

// TODO 1: Definisci le label per i registri VIC-II necessari
//         e le costanti per i colori scelti in CharPad.

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

// ZP
.label ZP_SRC = $FB
.label ZP_DST = $FD

start:

    // TODO 3: Configura il VIC-II per Text Multi-colour.
    //         - Colori background, mc1, mc2
    //         - Abilita multicolour in $D016
    //         - Punta il charset a $5000 tramite $D018

    //  Select VIC bank
    lda VIC_BANK
    and #%11111100
    ora #%00000010 // bank 1
    sta VIC_BANK

    // Set VIC bank offsets
    lda #%00010100 // screen offset $0400, charmap offset $1000
    sta VIC_POINTERS

    // Set multicolor mode
    lda VIC_SCREEN_CONTROL
    and #%11101111
    ora #%00010000
    sta VIC_SCREEN_CONTROL

    // Set background and border colors
    lda #COLORS.BLACK
    sta VIC_BORDER
    lda #COLORS.BLACK
    sta VIC_BACKGROUND

    // Set multicolor colors
    lda #COLORS.DARK_GREY
    sta VIC_MULTICOLOR_1
    lda #COLORS.LIGHT_GREY
    sta VIC_MULTICOLOR_2

    // TODO 4: Copia la mappa su Screen RAM ($4400).
    //         La mappa è 40×24 = 960 byte. Servono puntatori zero page.
    
    lda #<MAP
    sta ZP_SRC
    lda #>MAP
    sta ZP_SRC+1

    lda #<SCREEN
    sta ZP_DST
    lda #>SCREEN
    sta ZP_DST+1

    ldx #3
    ldy #0
!loop:
    lda (ZP_SRC),y
    sta (ZP_DST),y
    iny
    bne !loop-
    inc ZP_SRC+1
    inc ZP_DST+1
    dex
    bne !loop-

    ldx #232
!loop:
    lda (ZP_SRC),y
    sta (ZP_DST),y   
    iny
    dex
    bne !loop-

    // TODO 5: Riempi la Colour RAM ($D800).
    //         Per ogni cella: leggi quale char c'è, cerca il suo colore
    //         negli attributi (low nybble), scrivi in Colour RAM.

    lda #<MAP
    sta ZP_SRC
    lda #>MAP
    sta ZP_SRC+1

    lda #<COLOR
    sta ZP_DST
    lda #>COLOR
    sta ZP_DST+1

    ldx #3
    ldy #0
!loop:
    txa; pha
    lda (ZP_SRC),y
    tax
    lda CHAR_ATTR,x
    and #%00001111
    sta (ZP_DST),y
    pla; tax
    iny
    bne !loop-
    inc ZP_SRC+1
    inc ZP_DST+1
    dex
    bne !loop-

    ldx #232
!loop:
    txa
    pha
    lda (ZP_SRC),y
    tax
    lda CHAR_ATTR,x
    and #%00001111
    sta (ZP_DST),y
    pla
    tax
    iny
    dex
    bne !loop-



jmp *


// TODO 2: Importa i dati binari da CharPad.
//         - Il charset deve andare a $2000 (il VIC lo leggerà da lì)
//         - Mappa e attributi possono stare dove vuoi dopo il codice
//         Ragiona sulle dimensioni: quanti char hai? quanto è grande la mappa?

* = CHARSET "Charset"
.import binary "assets/maps/classroom/classroom_charset.bin", 0, $200

* = CHAR_ATTR "Attributes"
.import binary "assets/maps/classroom/classroom_charset_attr.bin", 0, $40

* = MAP "Map"
.import binary "assets/maps/classroom/classroom_map.bin", 0, 1000

