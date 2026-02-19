# CharPad C64 - Tile e Mappe

## Tile Editor

Editing del tile selezionato. Un tile è un arrangiamento rettangolare di character image.

### Due Modi di Painting

1. **Char Brush** - assegna manualmente immagini character alle celle del tile (metodo tradizionale, lento)
2. **Pixel Drawing** - disegna il tile come se fosse un'unica immagine bitmap (**richiede decompressione!**)

Per il pixel drawing, il progetto deve essere "decompresso": ogni cella del tile avrà un character unico, trasformando il tile editor in un array di char editor interconnessi.

### Mouse
- LEFT → disegna con colore selezionato
- RIGHT → disegna con background
- MIDDLE → pick colore (con pen/flood-fill) o pick char (con char brush)

### Naming e Tagging
- Ogni tile può avere un **name** (stringa) e un **tag** (byte)
- Utile per identificare tile nel codice assembly

### Trasformazioni
- Scroll, Flip, Reflect, Rotate, Negative, Colour swap
- **SHIFT + Scroll/Flip/Reflect/Cut/Copy/Paste** → opera sui riferimenti char (non sui pixel)

---

## Tile Set

Visualizza e organizza i tile del progetto.

### Configurazione
- **Quantità**: 1 - 65.536 tile
- **Dimensioni**: da 1x1 a 10x10 character per tile (cambio ridimensiona tutti i tile)

### Selezione
- LEFT click → primary tile (brush LEFT nel map editor)
- RIGHT click → secondary tile (brush RIGHT nel map editor)
- SHIFT + LEFT → range

### Operazioni
- Swap, Crop, Cycle (come per il Character Set)
- Naming e Tagging per tile

---

## Map Editor

Editing della mappa del progetto. La mappa è una griglia 2D che referenzia character (senza tile) o tile (con tile abilitati).

### Configurazione
- Dimensioni: da 1x1 fino a 8192x8192

### Navigazione
- **Pan tool** (o SPACE premuto) → click+drag per navigare
- Scroll bars orizzontale e verticale
- CTRL + Mouse Wheel → zoom

### Selezione
- Selection tool + LEFT click → seleziona cella
- SHIFT + LEFT click → seleziona area rettangolare
- Menu Edit: Select All, Crop, Cut, Copy, Paste, Fill

### Painting
- Brush tool + LEFT → primary brush (char/tile selezionato)
- Brush tool + RIGHT → secondary brush
- Flood-fill con LEFT/RIGHT
- MIDDLE mouse → pick brush dalla mappa

### Trasformazioni
- Scroll, Flip, Reflect, Rotate (su tutta la mappa o sulla selezione)

---

## Compressione e Decompressione

### Compressione
Rimuove duplicazioni e item inutilizzati:
- Reset colori irrilevanti ai default
- Reset colori matrix inutilizzati (per char)
- Ordinamento colori bitmap per luminanza
- **Rimuovi character duplicati**
- **Rimuovi tile duplicati**
- **Rimuovi character inutilizzati**
- **Rimuovi tile inutilizzati**
- Ordinamento char per colore o materiale

### Decompressione (Progetto con Tile)
Espande il character set per avere un char unico per ogni cella di ogni tile:
1. Il charset si espande a (numero totale celle in tutti i tile)
2. Le immagini referenziate vengono duplicate
3. Il tile set viene riscritto come sequenza ascendente da 0
4. Ora si può editare ogni tile come immagine bitmap singola

### Decompressione (Progetto senza Tile)
Stesso principio ma sulla mappa:
1. Il charset si espande a (celle della mappa)
2. La mappa viene riscritta come sequenza ascendente da 0
3. Ogni cella ha il proprio char unico editabile

CharPad chiede sempre permesso prima di decomprimere.

---

## Workflow Tipico per Tilemap

1. Nuovo progetto → impostare display mode (es. Text Multicolour)
2. Abilitare Tile Set → Yes, scegliere dimensioni (es. 2x2, 4x4)
3. Impostare colouring method (Per Char per max flessibilità, Per Tile per efficienza)
4. Creare/editare i character nel Char Editor
5. Comporre i tile nel Tile Editor (con char brush o dopo decompress)
6. Assegnare **material** ai character per collision detection
7. Assegnare **name/tag** ai tile per identificarli nel codice
8. Comporre la mappa nel Map Editor usando i tile come brush
9. Comprimere per ottimizzare (rimuovere duplicati)
10. Esportare: charset (bin), tile set (bin), mappa (bin), attributi (bin)
