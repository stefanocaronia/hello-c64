# CharPad C64 - Import/Export e Formato File

## Export

### File Binari (Raw)
Dati puri senza header. Formati:

| Dato | Formato |
|------|---------|
| Character Set | 8 byte/immagine (byte 0 = riga pixel top di img 0) |
| Char Attributes L1 | 1 byte/img (high nybble=Material, low nybble=CmLo) |
| Char Attributes L2 | 1 byte/img (high nybble=SmHi, low nybble=SmLo) |
| Tile Set | W×H byte/tile (byte 0 = angolo top-left di tile 0) |
| Tile Attributes L1 | 1 byte/tile (high nybble=0, low nybble=CmLo) |
| Tile Attributes L2 | 1 byte/tile (high nybble=SmHi, low nybble=SmLo) |
| Map | W×H byte (byte 0 = angolo top-left) |

### File Testo (ASM)
File ASCII leggibile, con estensione `.asm`, assemblabile direttamente con 64TASS o simili.

### File Immagine
BMP o PNG della mappa/viewport corrente.

### Export Speciali
- **SEUCK background**: charset + tileset + map (requisiti: Per Tile, 254 char, tile 5x5, 128 tile, map 8x512)
- **Art Studio**: bitmap HR (requisiti: Bitmap HR, Per Char, no tile, map 40x25)
- **Advanced Art Studio**: bitmap MC
- **Koala Painter**: bitmap MC

---

## Import

### File Binari
- Stesso formato dell'export
- I file charset possono avere un header PRG opzionale di 2 byte (load address)
- Per tile/map: impostare le dimensioni corrette **prima** dell'import (i binari non contengono info dimensionali)

### Immagini (BMP, PNG, GIF)
- Tools → Image Importer
- Algoritmo di colour processing automatico
- Converte ogni regione 8x8 in un character adatto al display mode scelto

### Snapshot VICE (VSF)
- Tools → Emulator Snapshot Ripper
- Cerca char set, attributi, tile set e mappa nel dump RAM 64KB
- Char set su boundary 2K (32 posizioni possibili in 64KB)
- Supporta cipher XOR e ROR sulla mappa
- Picture rip mode per bitmap fullscreen

### SEUCK / Art Studio / Koala Painter
- Import diretto dei formati nativi

---

## Formato CTM v9 (Formato Progetto Nativo)

Il formato più recente (CharPad 3.5+). File binario con header + blocchi dati.

### Header (19 byte, offset $00-$12)

| Offset | Campo | Descrizione |
|--------|-------|-------------|
| $00-02 | ID_STR | "CTM" (ASCII) |
| $03 | VERSION | 9 |
| $04 | DISP_MODE | 0=TextHR, 1=TextMC, 2=TextECM, 3=BitmapHR, 4=BitmapMC |
| $05 | COLR_METH | 0=Per-project, 1=Per-tile, 2=Per-char |
| $06 | FLAGS | High nybble=Key Map (0-10), bit0=tile system on/off |
| $07-0A | FGRID | Flexi-grid width/height (16-bit LE ciascuno) |
| $0B | FGRID_CFG | Configurazione flexi-grid |
| $0C-0F | VCOLR | Bg0-Bg3 ($D021-$D024) |
| $10-12 | MTRXCOLRS | Colori base cella (CmLo, SmLo, SmHi) |

### Blocchi Dati (in ordine)

Ogni blocco inizia con marker `$DA, $Bn` (n = numero blocco progressivo).

1. **Character Set Data** (sempre) - 8 byte/img × count
2. **Character Materials** (sempre) - 1 byte/img (low nybble = material 0-15)
3. **Character Colours** (solo per-char) - 1-3 byte/img a seconda del display mode
4. **Tile Set Data** (se tile abilitati) - 16 bit/cella (LE), W×H celle × tile count
5. **Tile Colours** (se tile + per-tile) - 1-3 byte/tile
6. **Tile Tags** (se tile) - 1 byte/tile
7. **Tile Names** (se tile) - stringhe ASCII zero-terminated (max 32 char)
8. **Map Data** (sempre) - 16 bit/cella (LE), W×H celle

### Limiti
- Max char: 65.536 | Max tile: 65.536
- Max tile size: 10×10 | Max map size: 8192×8192

---

## Keyboard Shortcuts Principali

### Globali
| Shortcut | Azione |
|----------|--------|
| CTRL+N | Nuovo progetto |
| CTRL+O | Apri progetto CTM |
| CTRL+S | Salva progetto CTM |
| CTRL+Z | Undo |
| CTRL+ALT+Z | Redo |
| F1-F4 | Selezione penna (Bg/Fg/M1/M2) |

### Editor (dipende dalla finestra attiva)
| Shortcut | Azione |
|----------|--------|
| CTRL+U/D/L/R | Scroll su/giù/sx/dx |
| CTRL+F/G | Flip LR/TB |
| CTRL+H/J | Reflect LR/TB |
| CTRL+X/C/V | Cut/Copy/Paste |
| INS/DEL | Inserisci/Elimina item |
| G | Grid on/off |
| M | Material Vision on/off |
| B | Blur on/off |
| 1/2 | Pen size 1/2 |
| 3 | Flood fill |
| +/- | Zoom in/out |
| SPACE (premuto) | Pan tool temporaneo |
| MIDDLE mouse | Pick char/tile (Map) o colore (Char/Tile editor) |
| CTRL+LEFT click | Swap item nel set |
| CTRL+Mouse Wheel | Zoom |
