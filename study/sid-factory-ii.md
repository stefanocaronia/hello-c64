# SID Factory II - Guida alle Tabelle (Driver 11)

## Corrispondenza nibble / bit

```
1 nibble (cifra hex) =  4 bit   → max $F       = 15
2 nibble (1 byte)    =  8 bit   → max $FF      = 255
3 nibble             = 12 bit   → max $FFF     = 4095
4 nibble (2 byte)    = 16 bit   → max $FFFF    = 65535
```

## Instrument

Ogni strumento ha 6 byte:

| Byte | Contenuto |
|------|-----------|
| 0 | AD (Attack/Decay) |
| 1 | SR (Sustain/Release) |
| 2 | Flags (vedi sotto) |
| 3 | Indice Filter table |
| 4 | Indice Pulse table |
| 5 | Indice Wave table |

### Flags (byte 2) - ogni bit è indipendente, si combinano

```
Bit:  7    6    5    4    3    2 1 0
      $80  $40  $20  $10  $08  indice HR (0-7)

$80 - Abilita hard restart
$40 - Avvia programma filtro (usa indice byte 3)
$20 - Abilita filtro sul canale
$10 - Oscillator reset (waveform 09 al primo frame)
$08 - Non resettare pulse program su note-on
$00-$07 - Indice HR table (0-7)
```

Esempio: `$C0` = `%11000000` = HR ($80) + avvia filtro ($40).

**Tip:** in SF2 usa `Shift+Enter` sul byte flags per editare i bit visualmente.

## Wave Table

Eseguita **1 riga per frame** (1/50s su PAL). Ogni riga:

```
XX YY    XX = waveform, YY = semitoni/nota
7f XX    Salta a indice XX (loop se salta a sé stesso = stop)
```

### Colonna YY (semitoni) - due modalità

- **$00-$7F** → semitoni **aggiunti** alla nota nella sequence
- **$80-$DF** → nota **assoluta** (ignora la nota in sequence)

La nota assoluta serve per i **drum**: il suono è sempre uguale
indipendentemente dalla nota scritta nella sequence.

### Esempio: lead con attacco percussivo

```
00: 81 00   ← frame 1: noise (click)
01: 41 00   ← frame 2+: pulse (corpo)
02: 7f 01   ← loop su riga 01
```

### Esempio: drum (nota assoluta)

```
00: 81 88   ← noise, nota fissa
01: 7f 01   ← stop
```

## Pulse Table

Controlla la **pulse width** — la larghezza dell'onda pulse ($41).
La pulse width determina il timbro: 0 = silenzio, $800 (50%) = pieno.

```
 Pulse width bassa (~10%):    Alta (~50%):
 ██                           ████████
 █ █                          █      █
─┘ └──────────                ┘      └────────
 Suono sottile, nasale        Suono pieno, grasso
```

**Senza Pulse table la width parte da 0 = silenzio!**

### Comandi (3 tipi)

| Primo nibble | Formato | Significato |
|---|---|---|
| `8` | `8X XX YY` | **SET** pulse width a `$XXX`, dura `YY` frame |
| `0` | `0X XX YY` | **ADD** `$XXX` alla width, per `YY` frame |
| `7f` | `7f -- XX` | **JUMP** a indice XX (loop su sé = stop) |

I 3 nibble dopo il comando formano un valore a 12 bit (0-$FFF = 0-4095).

### ADD: positivo e negativo (complemento a due 12 bit)

Nel comando ADD i 12 bit usano il complemento a due:

```
$000 - $7FF → positivo (pulse sale)
$800 - $FFF → negativo (pulse scende)
```

Per calcolare il negativo: $FFF - valore + 1

```
Esempio: -$010 → $FFF - $010 + 1 = $FF0
```

Nel SET invece il valore è sempre positivo (0-4095).

### Esempio: pulse oscillante classica

```
00: 88 00 01   ← SET a $800 (50%), 1 frame
01: 00 10 40   ← ADD +$010 per 64 frame (si allarga)
02: 0F F0 40   ← ADD -$010 per 64 frame (si restringe)
03: 7f -- 01   ← JUMP a riga 01 (loop)
```

## Filter Table

Il filtro del SID è **globale** (uno solo per il chip intero).
Si applica a uno o più canali tramite bitmask.

Per usare il filtro, nell'instrument servono **entrambi** i flag:
- `$40` — avvia il programma filtro
- `$20` — abilita il filtro su questo canale
- Quindi almeno `$60` nel byte 2 dei flags

### Comandi (3 tipi)

| Primo nibble | Formato | Significato |
|---|---|---|
| `9`-`F` | `XY YY RB` | **SET** filtro (4 byte per riga) |
| `0` | `0X XX YY` | **ADD** `$XXX` al cutoff, per `YY` frame |
| `7f` | `7f -- XX` | **JUMP** a indice XX |

### SET — dettaglio dei 4 byte

```
XY YY RB

X = tipo filtro (passband):
    9 = Low-pass   (caldo, ovattato)
    B = Band-pass  (nasale, medio)
    D = High-pass  (sottile, brillante)
    F = tutti combinati

YYY = cutoff 12 bit (0-$FFF) — frequenza di taglio
R   = resonance (0-$F) — amplifica le frequenze vicine al cutoff
B   = bitmask canali:
      1 = voce 1
      2 = voce 2
      4 = voce 3
      Combinabili: 3 = voci 1+2, 7 = tutte
```

### ADD — identico alla Pulse table

Complemento a due 12 bit per salire/scendere col cutoff.

### Esempio: sweep low-pass

```
00: 92 00 A1   ← SET: LP, cutoff $200, reso A, voce 1
01: 00 08 30   ← ADD +$008 per 48 frame (filtro si apre)
02: 0F F8 30   ← ADD -$008 per 48 frame (filtro si chiude)
03: 7f -- 01   ← loop
```

## Arpeggio Table

Tabella separata dalla Wave per fare **accordi rapidi**.
Si attiva dalla **sequence** con il comando `03`, non dall'instrument.

### Formato

| Valore | Significato |
|---|---|
| `XX` (< $70) | Semitoni da aggiungere alla nota |
| `7X` | Salta indietro di `X` posizioni dall'indice di partenza |

### Comando nella sequence

```
03 XX YY
    │  └─ indice di partenza nella Arp table
    └──── velocità (ogni quanti frame cambia nota)
```

### Esempio completo

Immagina questa Arp table:

```
Arp table:
00: 00   ← +0  (nota base)
01: 04   ← +4  (terza maggiore)
02: 07   ← +7  (quinta)
03: 70   ← salta a indice 0 (loop dall'inizio)
```

Ora nella sequence puoi usarla in modi diversi:

```
Sequence voce 1:
Inst Cmd  Nota
 01  03 01 00  C-4     ← arpeggio velocità 1, parte da indice 00
                         cicla: C → E → G → C → E → G ...
                         (accordo maggiore completo)

Sequence voce 2:
 01  03 02 01  C-4     ← arpeggio velocità 2, parte da indice 01
                         cicla: E → G → E → G ...
                         (solo terza e quinta, cambia ogni 2 frame)

Sequence voce 3:
 01  03 01 02  C-4     ← arpeggio velocità 1, parte da indice 02
                         cicla: G → G → G ...
                         (solo quinta, perché 70 lo riporta a 02)
```

Il jump `70` significa "torna a 0 posizioni indietro dal punto di partenza",
cioè torna all'indice con cui è stato chiamato.
`71` tornerebbe 1 posizione dopo, `72` due posizioni dopo, ecc.

### Interazione con Wave table

L'arpeggio agisce **solo** sulle righe della Wave table dove i semitoni
(colonna YY) sono `$00`. Se la wave table ha un valore diverso da zero
su quella riga, l'arpeggio viene ignorato.

### Differenze dalla Wave table

| | Wave table | Arp table |
|---|---|---|
| Velocità | sempre 1 frame/riga | controllabile col comando |
| Timbro | cambia waveform + nota | cambia solo la nota |
| Attivazione | dall'instrument (byte 5) | dal comando `03` nella sequence |
| Riuso | una wave per instrument | stessa arp per qualsiasi instrument |
