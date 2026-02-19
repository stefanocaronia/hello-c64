# CharPad C64 - Overview

CharPad C64 (v3.80 Pro, Subchrist Software) è un editor grafico per creare dati grafici compatibili con il Commodore 64: character set, tile set e mappe.

## Character Graphics - Concetti Base

- Il C64 ha uno schermo di 320x200 pixel (40x25 celle di 8x8 pixel)
- In character mode, la video matrix è solo 1000 byte (vs 8000 in bitmap mode)
- Un character set di 256 immagini (8x8) occupa 2048 byte (2KB), 8 byte per immagine
- Il C64 ha 2 set di 256 caratteri in ROM (maiuscole/minuscole + simboli)

## Funzionalità Principali

- Supporta **tutti** i display mode standard del C64
- Editing dei **material** per dati di collision detection
- Editing di **tile** (arrangiamenti rettangolari di char) da 1x1 fino a 10x10
- Pixel-level tile editing con compressione/decompressione
- **Map editing** usando character set o tile set
- **Material Vision** per visualizzare immediatamente i dati di collisione
- Import/export SEUCK, Art Studio, Koala Painter
- Ripping dati da snapshot VICE (x64)
- Import/analisi/conversione di immagini bitmap (BMP, PNG, GIF)
- Auto-correzione dei riferimenti per operazioni delete/insert/cut/paste
- Undo/Redo multipli

## I 5 Display Mode del C64

### Text Mode - High Resolution
- Fino a 256 char diversi sulla matrice 40x25
- 8x8 pixel, 1 bit-per-pixel (2 colori per cella)
- Colore foreground per cella via Colour Matrix ($D800)
- Background comune via VIC $D021

### Text Mode - Multi-colour
- Fino a 256 char, supporta mix di char HR (8x8, 1bpp) e MC (4x8, 2bpp)
- Bit 3 della Colour Matrix seleziona il modo per ogni cella (1=MC)
- In MC solo colori 0-7 per foreground (3 bit)
- Colori condivisi: $D021 (bg), $D022 (mc1), $D023 (mc2)

### Text Mode - Extended Colour (ECM)
- Solo 64 char diversi (6 bit per selettore)
- 1bpp, 2 colori per cella
- I 2 bit alti della Screen Matrix selezionano 1 di 4 background ($D021-$D024)
- Trade-off: meno immagini, più flessibilità colore

### Bitmap Mode - High Resolution
- 320x200 pixel indipendenti, 2 colori per cella 8x8
- Pixel data = 8000 byte (come 1000 char unici sequenziali)
- Screen Matrix riproposta per colori: "0"=SmLo, "1"=SmHi

### Bitmap Mode - Multi-colour
- 160x200 pixel "larghi" (2bpp), 4 colori per cella
- "00"=$D021, "01"=SmHi, "10"=SmLo, "11"=CmLo

## Tabella Penne e Sorgenti Colore

```
                 TextHR      TextMC      TextECM     BitmapHR    BitmapMC
penBg (00/0)     VicBg0      VicBg0      VicBg?      SmLo        VicBg0
penFg (11/1)     CmLo        CmLo        CmLo        SmHi        CmLo
penM1 (01)       -           VicBg1      -           -           SmHi
penM2 (10)       -           VicBg2      -           -           SmLo
```

- CmLo = Colour Matrix ($D800), low nybble
- SmLo/SmHi = Screen Matrix, low/high nybble
- VicBg0-3 = Registri VIC $D021-$D024
