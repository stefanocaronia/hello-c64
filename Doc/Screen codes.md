# Screen Codes (C64)

Gli screen codes sono i valori da scrivere direttamente nella memoria video ($0400-$07E7).

**ATTENZIONE:** Gli screen codes sono DIVERSI dai codici PETSCII!

## Caratteri stampabili

| Carattere | Dec   | Hex       | Note                      |
| --------- | ----- | --------- | ------------------------- |
| @         | 0     | $00       |                           |
| A-Z       | 1-26  | $01-$1A   | Lettere maiuscole         |
| [         | 27    | $1B       |                           |
| £         | 28    | $1C       | Sterlina                  |
| ]         | 29    | $1D       |                           |
| ↑         | 30    | $1E       | Freccia su                |
| ←         | 31    | $1F       | Freccia sinistra          |
| SPACE     | 32    | $20       | Spazio                    |
| !         | 33    | $21       |                           |
| "         | 34    | $22       |                           |
| #         | 35    | $23       |                           |
| $         | 36    | $24       |                           |
| %         | 37    | $25       |                           |
| &         | 38    | $26       |                           |
| '         | 39    | $27       |                           |
| (         | 40    | $28       |                           |
| )         | 41    | $29       |                           |
| *         | 42    | $2A       | Asterisco                 |
| +         | 43    | $2B       |                           |
| ,         | 44    | $2C       |                           |
| -         | 45    | $2D       |                           |
| .         | 46    | $2E       |                           |
| /         | 47    | $2F       |                           |
| 0-9       | 48-57 | $30-$39   | Numeri                    |
| :         | 58    | $3A       |                           |
| ;         | 59    | $3B       |                           |
| <         | 60    | $3C       |                           |
| =         | 61    | $3D       |                           |
| >         | 62    | $3E       |                           |
| ?         | 63    | $3F       |                           |

## Caratteri grafici (64-95)

| Simbolo | Dec | Hex  | Descrizione                      |
| ------- | --- | ---- | -------------------------------- |
| ─       | 64  | $40  | Linea orizzontale                |
| ♠       | 65  | $41  | Spade (carte)                    |
| │       | 66  | $42  | Linea verticale                  |
| ─       | 67  | $43  | Linea orizzontale (round)        |
| ▒       | 68  | $44  | Pattern checker                  |
| ▒       | 69  | $45  | Pattern checker 2                |
| ▒       | 70  | $46  | Pattern diagonal                 |
| ▁       | 71  | $47  | Barra basso 1/8                  |
| ▒       | 72  | $48  | Pattern diagonal inv             |
| ╮       | 73  | $49  | Angolo alto destra (round)       |
| ╰       | 74  | $4A  | Angolo basso sinistra (round)    |
| ╯       | 75  | $4B  | Angolo basso destra (round)      |
| ╭       | 76  | $4C  | Angolo alto sinistra (round)     |
| ╲       | 77  | $4D  | Diagonale \                      |
| ╱       | 78  | $4E  | Diagonale /                      |
| ▂       | 79  | $4F  | Barra basso 2/8                  |
| ▃       | 80  | $50  | Barra basso 3/8                  |
| ▁       | 81  | $51  | Barra basso 1/8 (left half)      |
| ▔       | 82  | $52  | Barra alto                       |
| ▄       | 83  | $53  | Barra basso 4/8 (metà)           |
| ▎       | 84  | $54  | Barra sinistra                   |
| ▌       | 85  | $55  | Mezzo blocco sinistro            |
| ▅       | 86  | $56  | Barra basso 5/8                  |
| ▆       | 87  | $57  | Barra basso 6/8                  |
| ▇       | 88  | $58  | Barra basso 7/8                  |
| ▉       | 89  | $59  | Barra sinistra larga             |
| ▊       | 90  | $5A  | Blocco quasi pieno               |
| ♥       | 91  | $5B  | Cuori (carte)                    |
| ▕       | 92  | $5C  | Barra destra                     |
| ╳       | 93  | $5D  | X / croce                        |
| ○       | 94  | $5E  | Cerchio                          |
| ♣       | 95  | $5F  | Fiori (carte)                    |

## Caratteri grafici (96-127) - uppercase/graphics charset

| Simbolo | Dec | Hex  | Descrizione                      |
| ------- | --- | ---- | -------------------------------- |
| ▌       | 96  | $60  | Mezzo blocco sinistro (alt)      |
| ▄       | 97  | $61  | Mezzo blocco basso               |
| ▔       | 98  | $62  | Linea superiore                  |
| ▁       | 99  | $63  | Linea inferiore                  |
| ▏       | 100 | $64  | Linea sinistra sottile           |
| ▕       | 101 | $65  | Linea destra                     |
| ▒       | 102 | $66  | Pattern quadrati                 |
| ▚       | 103 | $67  | Quadranti diagonali              |
| ▞       | 104 | $68  | Quadranti diagonali inv          |
| ┌       | 105 | $69  | Angolo alto sinistra             |
| ▗       | 106 | $6A  | Quadrante basso destra           |
| ┐       | 107 | $6B  | Angolo alto destra               |
| └       | 108 | $6C  | Angolo basso sinistra            |
| ┘       | 109 | $6D  | Angolo basso destra              |
| ├       | 110 | $6E  | T sinistra                       |
| ┤       | 111 | $6F  | T destra                         |
| ┬       | 112 | $70  | T alto                           |
| ┴       | 113 | $71  | T basso                          |
| ┼       | 114 | $72  | Croce                            |
| ▘       | 115 | $73  | Quadrante alto sinistra          |
| ▝       | 116 | $74  | Quadrante alto destra            |
| ▖       | 117 | $75  | Quadrante basso sinistra         |
| ▗       | 118 | $76  | Quadrante basso destra           |
| ▎       | 119 | $77  | Barra sinistra sottile           |
| ▌       | 120 | $78  | Mezzo blocco                     |
| ▃       | 121 | $79  | Blocco basso                     |
| ●       | 122 | $7A  | Cerchio pieno                    |
| ♦       | 123 | $7B  | Quadri (carte)                   |
| ╭       | 124 | $7C  | Curva                            |
| ╮       | 125 | $7D  | Curva                            |
| ╰       | 126 | $7E  | Curva                            |
| ╯       | 127 | $7F  | Curva                            |

## Reverse (caratteri invertiti)

Per ottenere la versione "reverse" (invertita) di un carattere, aggiungi 128 ($80):

| Carattere normale | Dec | Reverse | Dec |
| ----------------- | --- | ------- | --- |
| SPACE             | 32  | ▌       | 160 |
| A                 | 1   | A inv   | 129 |
| *                 | 42  | * inv   | 170 |

Formula: `screen_code_reverse = screen_code + 128`

## Confronto PETSCII vs Screen Code

| Carattere | PETSCII | Screen Code |
| --------- | ------- | ----------- |
| @         | 64      | 0           |
| A         | 65      | 1           |
| B         | 66      | 2           |
| Z         | 90      | 26          |
| SPACE     | 32      | 32          |
| 0         | 48      | 48          |
| *         | 42      | 42          |

**Regola pratica:**
- Lettere: `screen_code = PETSCII - 64`
- Numeri e simboli base: spesso coincidono

## Uso in KickAssembler

```asm
// Per stringhe in memoria video, usa l'encoding:
.encoding "screencode_upper"
msg: .text "HELLO"    // Produce: 8, 5, 12, 12, 15

// Per un singolo carattere:
lda #42               // Asterisco '*' (stesso valore)
sta $0400

// Oppure direttamente:
lda #'*'              // KickAssembler converte in screen code se encoding attivo
```

## Memoria

- Screen RAM: `$0400-$07E7` (1000 bytes, 40x25)
- Color RAM: `$D800-$DBE7` (1000 bytes, un colore per carattere)
