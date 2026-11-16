# SID Factory II - Guida alle Tabelle (Driver 11)

## Indice

- [Corrispondenza nibble / bit](#corrispondenza-nibble--bit)
- [Instrument](#instrument)
  - [Envelope (byte 0-1)](#envelope-byte-0-1)
  - [Flags (byte 2)](#flags-byte-2---ogni-bit-è-indipendente-si-combinano)
- [Wave Table](#wave-table)
- [Pulse Table](#pulse-table)
- [Filter Table](#filter-table)
- [Arpeggio Table](#arpeggio-table)
- [HR Table (Hard Restart)](#hr-table-hard-restart)
- [Init Table](#init-table)
- [Tempo Table](#tempo-table)
- [Command Table](#command-table)

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


### Envelope (byte 0-1)

00 00
AD SR

- A: ATTACK tempo da 0 a volume massimo
- D: DECAY tempo da volume massimo a volume sustain
- S: SUSTAIN volume
- R: RELEASE tempo da volume sustain a 0

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

## HR Table (Hard Restart)

### Il problema: ADSR bug

Quando suoni note in sequenza rapida, il SID non resetta l'ADSR tra una nota
e l'altra — riparte da dove era rimasto. Questo crea un attacco irregolare
("school band effect": le note non partono tutte allo stesso modo).

### La soluzione: hard restart

**2 frame prima** della nota successiva, il driver:

1. Fa **gate off** (chiude la nota corrente)
2. Sovrascrive l'ADSR con valori dalla **HR table**

Questo "azzera" l'ADSR, così la nota nuova parte sempre con un Attack pulito.

### La HR table

Contiene preset ADSR usati **solo per i 2 frame di reset** tra le note.
Non sostituisce l'ADSR dello strumento — lo rimpiazza solo durante la preparazione.

```
HR table:
00: 0F 00   ← AD=$0F (attack 0, decay max), SR=$00 (sustain 0, release 0)
01: 09 00   ← un preset più morbido (esempio)
```

### Come si attiva

Nel byte 2 (flags) dell'instrument:

- **Bit 7 ($80)** — abilita hard restart
- **Bit 0-2** — indice nella HR table (0-7)

```
$80 = HR abilitato, usa HR table riga 0
$81 = HR abilitato, usa HR table riga 1
$82 = HR abilitato, usa HR table riga 2
```

Per il 99% dei casi: flag `$80` + riga 0 con `$0F $00` e non ci pensi più.

## Init Table

Punto di partenza del brano. Ogni riga = una canzone (per multi-song nei giochi).

```
XX YY
│  └─ volume principale (0-$F, dove $F = massimo)
└──── indice nella Tempo table
```

Esempio per un gioco con 3 brani:

```
Init table:
00: 00 0F   ← canzone 0: tempo riga 0, volume max
01: 02 0F   ← canzone 1: tempo riga 2 (diverso), volume max
02: 00 0A   ← canzone 2: tempo riga 0, volume basso (jingle)
```

Tutte le canzoni condividono instrument, sequence e tabelle.
Per cambiare canzone in assembly: `lda #X` + `jsr INIT` (X = numero canzone).

## Tempo Table

Definisce la **velocità del brano** — quanti frame dura ogni riga della sequence.

```
Tempo table:
00: 06       ← ogni riga dura 6 frame
01: 7f 00    ← loop a riga 00
```

1 frame = 1/50s su PAL. Quindi:
- `$02` = velocissimo
- `$06` = medio
- `$0C` = lento

Con hard restart abilitato, il minimo pratico è `$02` (servono 2 frame per il reset).

### Shuffle/swing

Puoi creare ritmi irregolari con catene di valori diversi:

```
00: 06       ← riga lunga (6 frame)
01: 04       ← riga corta (4 frame)
02: 7f 00    ← loop (lungo-corto-lungo-corto = swing)
```

## Command Table

Effetti applicati dalla **colonna centrale** della sequence.
Ogni entry nella Command table ha 3 byte:

```
TN XX YY
│└─ tipo comando (nibble BASSO)
└── note delay in tick (nibble ALTO, solo driver 11.04+)
```

**Attenzione:** a differenza di Pulse/Filter table, qui il tipo comando è
nel nibble **basso**, non nell'alto!

### Effetti sulla frequenza

| Nibble basso | Nome | XX | YY | Uso |
|---|---|---|---|---|
| `0` | **Slide** | speed hi | speed lo | Pitch bend (XXYY = velocità 16 bit) |
| `1` | **Vibrato** | frequenza | ampiezza | YY piccolo = vibrato forte! |
| `2` | **Portamento** | speed hi | speed lo | Scivola dalla nota precedente alla nuova |
| `3` | **Arpeggio** | velocità | indice arp table | Accordi rapidi |

### Modifica ADSR al volo

| Nibble basso | Nome | XX | YY | Uso |
|---|---|---|---|---|
| `8` | **Set local ADSR** | AD | SR | Cambia ADSR fino alla prossima nota |
| `9` | **Set instr. ADSR** | AD | SR | Cambia ADSR finché non cambi instrument |

### Reindirizzamento tabelle

| Nibble basso | Nome | XX | YY | Uso |
|---|---|---|---|---|
| `A` | **Filter program** | -- | indice | Avvia programma filtro |
| `B` | **Wave program** | -- | indice | Cambia wave table al volo |

### Esempio: Command table con vibrato e arpeggio

```
Command table:
00: 01 04 20   ← vibrato: freq 4, ampiezza $20 (delicato)
01: 01 04 01   ← vibrato: freq 4, ampiezza $01 (intenso)
02: 03 01 00   ← arpeggio: velocità 1, indice arp 00
```

Nella sequence si riferiscono per indice:

```
Sequence:
Inst Cmd  Nota
 01  00   C-4     ← nota con vibrato delicato (cmd 00)
 01  01   E-4     ← nota con vibrato intenso (cmd 01)
 01  02   C-4     ← nota con arpeggio (cmd 02)
```

### Disattivare un portamento

Il portamento continua a scorrere finché non lo fermi.
Per disattivarlo: crea un comando `02 80 00` e usalo nella sequence.
