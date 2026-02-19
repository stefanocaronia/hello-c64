# CharPad C64 - Materiali e Attributi

## Material (Collision Detection)

Ogni character ha un valore **material** (4 bit, 0-15) assegnabile dalla Project Palette.

I material sono usati per la **collision detection** nei giochi: il codice assembly può consultare il material del character sotto uno sprite/giocatore per decidere l'effetto (solido, letale, collezionabile, ecc.).

### Material Vision
CharPad offre una modalità di rendering "Material Vision" (tasto **M**) che mostra immediatamente i dati di collisione sovrapposti alla grafica.

### Valori Tipici
- 0 = vuoto / attraversabile
- 1 = solido / muro
- 2 = letale / danno
- 3-15 = definiti dall'utente (piattaforme, scale, acqua, ecc.)

---

## Attribute Bytes

Gli attribute byte memorizzano dati di colore (4 bit) e material (4 bit) per ogni character.

Ogni attribute byte consiste di due nybble (1 nybble = 4 bit = mezzo byte).

### Due Layer: L1 e L2

- **L1**: sempre disponibile (material + colore)
- **L2**: solo per bitmap mode (colori screen matrix)

I non-bitmap mode usano solo L1.

### Formato per Display Mode

```
Display Mode            # Colori Cella    L1 Byte         L2 Byte
------------------------------------------------------------------------
Text Hi-res             2 (1 matrix)      MMMM:CCCC       n/a
Text Multi-colour       4 (1 matrix)      MMMM:CCCC       n/a
Text ECM                2 (1 matrix)      MMMM:CCCC       n/a
Bitmap Hi-res           2 (2 matrix)      MMMM:xxxx       SSSS:ssss
Bitmap Multi-colour     4 (3 matrix)      MMMM:CCCC       SSSS:ssss
```

- **M** = bit Material (high nybble)
- **C** = bit Colour (Colour Matrix low nybble)
- **S** = bit Colour (Screen Matrix high nybble)
- **s** = bit Colour (Screen Matrix low nybble)
- **x** = bit inutilizzato

### Tile Attribute Bytes

- Rilevanti solo con colouring method "Per Tile"
- Stesso formato dei char attribute ma i bit material sono sempre 0

---

## Uso in Assembly

### Collision Detection con Material

```asm
; Esempio: leggere il material del char sotto lo sprite
; 1. Convertire posizione sprite in coordinate mappa (div per 8)
; 2. Leggere l'indice del char/tile dalla mappa
; 3. Consultare la tabella dei material (esportata da CharPad)
; 4. Decidere azione in base al valore material

    ; char_index = mappa[posY * map_width + posX]
    ; material = char_materials[char_index]
    ; if material == 1 then solid collision
```

### Dati Esportati da CharPad
- **Character Set**: 8 byte per immagine (pixel data)
- **Char Attributes L1**: 1 byte per char → `MMMM:CCCC` (material | colour)
- **Char Materials** (solo material): estratti dal nybble alto di L1
- **Tile Set**: W*H byte per tile (indici char)
- **Map**: W*H byte/word (indici char o tile)
