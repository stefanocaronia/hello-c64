# Esercizio 19: CharPad Tilemap

## Obiettivo
Creare una tilemap in CharPad (Text Multi-colour, tile 2x2) e visualizzarla in assembly.

## Concetti nuovi
1. Workflow CharPad: charset, tile, mappa, material, export binari
2. Text Multicolour mode: setup VIC ($D016 bit 4), colori condivisi ($D022/$D023)
3. Algoritmo di espansione tile → screen RAM
4. Riempimento colour RAM da tile attributes
5. Material predisposti per collision detection (esercizio futuro)

## Scena: un'aula top-down pseudo-3D

Mappa 20×12 tile (= 40×24 char). Vista dall'alto, muri con facciata visibile sul lato top.

```
M  MF MF MF MF MF MF MF MF MF MF MF MF MF MF MF MF MF MF M
M  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  M
FI P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  M
M  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  M
M  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  M
FI P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  M
M  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  M
M  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  M
M  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  PO
M  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  M
M  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  M
M  M  M  M  M  M  M  M  M  M  M  M  M  M  M  M  M  M  M  M
```

## Tile set (5 tile, 2×2 ciascuno)

| # | Tile | Descrizione | Material |
|---|------|-------------|----------|
| 0 | Pavimento | Texture piatta | 0 (vuoto) |
| 1 | Muro-facciata | Sopra: tetto, sotto: parete scura | 1 (solido) |
| 2 | Muro | Blocco solido uniforme | 1 (solido) |
| 3 | Finestra | Muro con vetro/apertura | 1 (solido) |
| 4 | Porta | Apertura (colore pavimento) | 0 (vuoto) |

## Palette colori (Text Multi-colour)

- Background ($D021): nero (0)
- MC1 ($D022): grigio scuro (11) - facciate, ombre
- MC2 ($D023): grigio medio (12) - dettagli
- Foreground (per tile): colore specifico (marrone muri, verde pavimento, ecc.)

## Setup CharPad

1. New Project
2. Display Mode = Text - Multi-colour
3. Colouring Method = Per Tile
4. Tile Set = Yes, dimensione 2×2
5. Impostare colori VIC ($D021, $D022, $D023)
6. Disegnare i character (8x8 pixel, 4x8 MC)
7. Assegnare material ai character
8. Comporre i 5 tile nel Tile Editor
9. Dipingere la mappa 20×12 nel Map Editor
10. Compress per rimuovere duplicati
11. Export binari in `assets/charpad/tilemap1/`:
    - charset.bin, charattribs.bin, tileset.bin, tileattribs.bin, map.bin

## Memory layout assembly

| Indirizzo | Contenuto |
|-----------|-----------|
| $0400 | Screen RAM (default) |
| $0801 | Codice assembly |
| $2000 | Charset (importato) |
| $D800 | Colour RAM (scritto dal codice) |
| dopo codice | Tileset, Map, Attributi |

$D018 = $18: screen $0400 + charset $2000

## Algoritmo RenderMap

```
Per ogni tile row (0..11):
  Per ogni tile col (0..19):
    tileIdx = map[row * 20 + col]
    tileOffset = tileIdx × 4
    Leggi 4 char dal tileset[tileOffset..+3]
    Scrivi 2×2 char su screen RAM
    Leggi colore tile da tileattribs[tileIdx]
    Scrivi colore (con MC flag) su colour RAM per le 4 celle
```

## File

- `19_charpadTilemap.asm` - codice assembly (skeleton con TODO)
- `assets/charpad/tilemap1/` - dati esportati da CharPad
