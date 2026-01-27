# Charset

Il C64 usa caratteri 8x8 pixel. Ogni carattere = 8 byte.

## Character ROM

Il sistema ha una ROM con 2 set di caratteri:
- Uppercase/Graphics (default)
- Lowercase/Uppercase

Nei bank 0 e 2, il VIC vede la Character ROM a $1000/$9000 invece della RAM.

## Cambio charset via KERNAL

```asm
lda #$0E      // Lowercase / Uppercase
jsr $FFD2     // CHROUT

lda #$8E      // Uppercase / Graphics (default)
jsr $FFD2
```

## Charset custom

Per usare un charset custom:

1. Carica il charset in RAM (2KB, 256 caratteri × 8 byte)
2. Imposta $D018 per puntare al charset
3. Se usi bank 0 o 2, evita $1000/$9000 (Character ROM)

```asm
// Charset a $2000 nel bank 0
*=$2000 "Charset"
.import binary "mio-charset.bin"

// Imposta $D018 per charset a $2000
lda $D018
and #%11110001
ora #%00001000    // offset 4 = $2000
sta $D018
```

## Charset in bank 1 (consigliato)

Nel bank 1 non c'è il problema della Character ROM:

```asm
// Seleziona bank 1
lda $DD00
and #%11111100
ora #%00000010
sta $DD00

// Charset a $4000 (offset 0 nel bank)
*=$4000 "Charset"
.import binary "mio-charset.bin"

// $D018: charset offset 0, schermo offset 1 ($4400)
lda #%00010000
sta $D018
```

## Struttura charset

- 256 caratteri
- 8 byte per carattere
- Totale: 2048 byte (2KB)

```
Carattere 'A' (8 byte):
.byte %00011000   // riga 0:    ##
.byte %00111100   // riga 1:   ####
.byte %01100110   // riga 2:  ##  ##
.byte %01111110   // riga 3:  ######
.byte %01100110   // riga 4:  ##  ##
.byte %01100110   // riga 5:  ##  ##
.byte %01100110   // riga 6:  ##  ##
.byte %00000000   // riga 7:
```

## Multicolor mode

In modalità standard (hires), ogni carattere ha 2 colori:
- Bit 0 = background ($D021)
- Bit 1 = colore dalla Color RAM ($D800+)

In **multicolor mode**, ogni carattere può avere 4 colori, ma risoluzione orizzontale dimezzata (4×8 pixel effettivi).

### Abilitare multicolor

```asm
lda $D016
ora #%00010000    // bit 4 = multicolor on
sta $D016
```

### I 4 colori

I bit del charset si leggono a coppie:

| Bit pair | Colore |
|----------|--------|
| `00` | Background ($D021) |
| `01` | Colore 1 ($D022) |
| `10` | Colore 2 ($D023) |
| `11` | Colore dalla Color RAM (bit 0-2, deve avere bit 3 = 1) |

### Color RAM in multicolor

- Se bit 3 della Color RAM = 0 → carattere hires (2 colori)
- Se bit 3 della Color RAM = 1 → carattere multicolor (4 colori)

Questo permette di mescolare caratteri hires e multicolor sullo stesso schermo.

```asm
// Carattere multicolor rosso (colore 2 + bit 3)
lda #%00001010    // $0A = 2 (rosso) + 8 (multicolor flag)
sta $D800         // Color RAM posizione 0
```

### Esempio charset multicolor

```
Carattere multicolor (4x8 pixel):
.byte %00011011   // riga 0: [bg][01][10][11]
.byte %00011011   // ...
```

Ogni coppia di bit = 1 pixel largo il doppio.

## Tool consigliati

- **CharPad** - Editor charset per C64 (supporta multicolor)
- **VChar64** - Editor multipiattaforma
