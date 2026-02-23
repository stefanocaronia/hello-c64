# Esercizio 19: CharPad Tilemap

## Obiettivo
Creare una mappa in CharPad (Text Multi-colour, Per Char, senza tile) e visualizzarla in assembly.

## Concetti nuovi
1. Workflow CharPad: charset, mappa, attributi, material, export binari
2. Text Multicolour mode: setup VIC ($D016 bit 4), colori condivisi ($D022/$D023)
3. Copia mappa su screen RAM con loop multi-pagina e puntatori zero page
4. Riempimento colour RAM da char attributes (lookup indiretta)
5. Material predisposti per collision detection (esercizio futuro)

## Scena: un'aula top-down pseudo-3D

Mappa 40×25 char (1000 byte). Vista dall'alto, muri con facciata visibile sul lato top.
Elementi: muri, finestre, porta, lavagna, cattedra, banchi.

## Decisioni finali (cambiate rispetto al piano originale)

- **Niente tile 2x2**: per una singola stanza con char individuali è più flessibile
- **Colouring method: Per Char** (non Per Tile, dato che non usiamo tile)
- **Mappa diretta 40x25**: ogni cella della mappa è un char index, non un tile index
- **VIC Bank 1** ($4000-$7FFF): charset a $5000, screen a $4400

## Palette colori (Text Multi-colour)

- Background ($D021): nero (0)
- MC1 ($D022): grigio scuro (11)
- MC2 ($D023): grigio chiaro (15)
- Foreground: colore specifico per char (dalla Colour RAM)

## Setup CharPad

1. New Project
2. Display Mode = Text - Multi-colour
3. Colouring Method = Per Char
4. Tile Set = No
5. Impostare colori VIC ($D021, $D022, $D023)
6. Disegnare i character (4x8 pixel in MC)
7. Assegnare material ai character (0=vuoto, 1=solido, 2=facciata, 3=mobili)
8. Dipingere la mappa 40×25 nel Map Editor
9. Export binari in `assets/maps/classroom/`:
   - classroom_charset.bin (512 byte = 64 char × 8)
   - classroom_charset_attr.bin (64 byte, high nybble=material, low nybble=colour)
   - classroom_map.bin (1000 byte = 40×25)

## Memory layout assembly

| Indirizzo | Contenuto |
|-----------|-----------|
| $4400 | Screen RAM (Bank 1, offset $0400) |
| $5000 | Charset (Bank 1, offset $1000) |
| $5400 | Char Attributes (dopo charset) |
| $6000 | Map data |
| $D800 | Colour RAM (scritto dal codice) |

$DD00 = Bank 1 (bit invertiti: `%10`)
$D018 = `%00010100`: screen offset $0400 + charset offset $1000

## Algoritmo

```
1. Configura VIC Bank 1, multicolour, colori
2. Copia MAP → SCREEN (1000 byte = 3 pagine + 232 remainder)
3. Per ogni cella dello schermo:
   - Leggi char index dalla mappa
   - Usa come indice nella tabella attributi
   - Estrai low nybble (AND #$0F) = colore
   - Scrivi in Colour RAM
4. jmp * (loop infinito)
```

## Difficoltà riscontrate dallo studente

- Confusione MC flag: serve colore >= 8 nella Colour RAM per attivare multicolour
- Loop multi-pagina con puntatori ZP: concetto pagina vs riga
- Gestione registri: X usato come contatore E come indice → risolto con PHA/PLA
- $DD00 bit invertiti: `%10` = Bank 1, non `%01`
- Confusione hex/decimale: $0960 ≠ 960

## File

- `19_charpadTilemap.asm` - codice assembly
- `lib/colors.asm` - costanti colori C64
- `assets/maps/classroom/` - binari esportati da CharPad
- `assets/charpad/tilemap1/tilemap1.ctm` - progetto CharPad
