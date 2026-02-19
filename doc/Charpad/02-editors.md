# CharPad C64 - Editor e Form

## Project Palette

Controlla la configurazione del progetto: penne, colori, materiali, display mode.

### Penne
- **Bg** (00/0) - Background
- **Fg** (11/1) - Foreground
- **M1** (01) - Multi-colour 1
- **M2** (10) - Multi-colour 2

I numeri indicano i valori binari (1 o 2 bit) che la penna applica ai dati immagine. Il colore effettivo dipende dal display mode e dal colouring method.

### 7 Sorgenti Colore
- VIC Bg0 ($D021, screen colour)
- VIC Bg1 ($D022, multi-colour 1)
- VIC Bg2 ($D023, multi-colour 2)
- VIC Bg3 ($D024)
- Colour Matrix (low nybble)
- Screen Matrix (low nybble)
- Screen Matrix (high nybble)

### Matrix Colouring Method
- **Per Map**: un singolo set di colori per tutta la mappa
- **Per Tile**: un set di colori per ogni tile
- **Per Char**: un set di colori per ogni character (più flessibile, più costoso in CPU)

Solo i bitmap mode usano più di un colore matrix.

### Tile Set (On/Off)
- **No**: la mappa riferisce direttamente ai character
- **Yes**: la mappa riferisce ai tile

### Opzioni aggiuntive
- Key Map per Text Entry tool nel Map Editor
- Luminance order (ordinamento colori per luminosità C64)

---

## Character Image Editor

Editing del character selezionato (8x8 pixel).

### Painting
- **LEFT mouse** → disegna con colore selezionato
- **RIGHT mouse** → disegna con colore background
- **MIDDLE mouse** → pick colore dall'immagine
- Tool disponibili: Pen, Flood-fill

### Trasformazioni
- Scroll (su, giù, sinistra, destra)
- Flip (LR, TB)
- Reflect (LR, TB)
- Rotate Z (90/180/270 CW)
- Negative
- Colour swapping (per immagini multi-colour)

**Nota ECM**: editing su char > 63 viene applicato all'equivalente nei primi 64.

---

## Character Set

Visualizza e organizza le immagini character nel set.

### Configurazione
- Quantità: da 1 a 500.000 immagini (digitare nel box e premere ENTER)

### Selezione
- **LEFT click** → primary character (evidenziato giallo, usato come brush con LEFT nel map/tile editor)
- **RIGHT click** → secondary character (evidenziato rosso, usato come brush con RIGHT)
- **SHIFT + LEFT** → seleziona range

### Operazioni
- **Swap**: LEFT click + CTRL+LEFT click su un altro char
- **Crop**: con range selezionato, rimuove tutto fuori dalla selezione
- **Cycle**: con range selezionato, ruota le posizioni nel set di 1 posto (utile per animazioni, non corregge i riferimenti mappa)
- Stesse trasformazioni del Char Editor
