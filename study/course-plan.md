# Piano Corso C64 Assembly (KickAssembler)

## Obiettivo del corso

Portarti da livello base a livello intermedio solido su C64 Assembly, con esercizi piccoli e progressivi (1-2 concetti nuovi per volta), fino a saper costruire mini-demo e piccoli framework riusabili.

## Come leggere questo piano

- Stato: `Non iniziato`, `In corso`, `Consolidamento`, `Pronto`.
- Preparazione attuale: sintesi concisa della tua situazione su quell'argomento (derivata da `study/checklist.md`).
- Uscita modulo: cosa devi saper fare prima di passare al modulo successivo.

## Stato attuale sintetico

| Area | Preparazione attuale | Priorita |
|------|-----------------------|----------|
| Fondamentali ASM + KickAssembler | Buona base, da consolidare su scope/compile-time tools | Media |
| Schermo, input, timing base | Funziona, ma serve ripasso operativo su timing e tastiera | Alta |
| Puntatori, 16 bit, matematica | Punto piu debole tra gli argomenti gia toccati | Alta |
| VIC-II (bank/screen/charset) | Base discreta, mancano pezzi importanti (copy charset) | Alta |
| Sprite e joystick | Base buona, manca il blocco collisioni | Media |
| IRQ/raster | Buona base pratica; stable raster in progresso (quiz timing superati) | Media |
| SID | Buon livello base + player SF2 funzionante | Media |
| Argomenti a score 0 | Restano 2 argomenti non ancora studiati | Pianificata |

## Moduli del corso

### Modulo 0 - Setup mentale e workflow

- Stato: `Pronto`
- Preparazione attuale: build/run e debug di base gia operativi.
- Uscita modulo:
  - Compilare e avviare in VICE senza supporto.
  - Sapere dove guardare memory map e simboli.

### Modulo 1 - Fondamentali Assembly e memoria video

- Stato: `Consolidamento`
- Preparazione attuale: buona su loop, label base, scrittura schermo; da rafforzare scope e pulizia schermo strutturata.
- Uscita modulo:
  - Scrivere routine piccole con `jsr/rts`.
  - Gestire `SCREEN` e `COLOR RAM` con loop puliti.

### Modulo 2 - Input, timing e game loop base

- Stato: `Consolidamento`
- Preparazione attuale: lettura tastiera/joystick presente; timing in frame ancora fragile nei casi limite.
- Uscita modulo:
  - Costruire main loop con polling robusto.
  - Gestire delay in frame senza bug (es. caso `X=0`).

### Modulo 3 - Puntatori, addressing e aritmetica 16 bit

- Stato: `In corso`
- Preparazione attuale: comprensione presente ma poco automatica su `(ZP),Y`, carry e offset pointer.
- Uscita modulo:
  - Scorrere stringhe/buffer con puntatori ZP.
  - Sommare indirizzi a 16 bit in modo affidabile.
  - Applicare moltiplicazione 8x8 quando serve.

### Modulo 4 - VIC-II: bank, screen base, charset

- Stato: `In corso`
- Preparazione attuale: bank e `$D018` compresi a livello base; copia charset nel bank non ancora studiata.
- Uscita modulo:
  - Configurare bank VIC + screen base in modo consapevole.
  - Copiare charset ROM->RAM e attivarlo.

### Modulo 5 - Sprite e movimento

- Stato: `Consolidamento`
- Preparazione attuale: setup/movimento/posizionamento ok; collisioni non ancora affrontate.
- Uscita modulo:
  - Gestire sprite con limiti, MSB X e aggiornamento fluido.
  - Leggere e resettare correttamente i registri collisione.

### Modulo 6 - IRQ e raster avanzato

- Stato: `In corso`
- Preparazione attuale: raster IRQ e split funzionano; stable raster avviato con buona comprensione teorica.
- Uscita modulo:
  - Gestire IRQ robusti con save/restore e ack corretti.
  - Implementare stable raster (double IRQ) in esempio minimo.
- Esito quiz rapido (E17):
  - Equazione cicli risolta correttamente (`5*n-1+2=126 -> n=25`).
  - Formula generale impostata correttamente (`X = (R*63 - P + 1)/5`).
  - Vincolo `X` a 8 bit compreso (per fasce alte serve catena IRQ o doppio loop).

### Modulo 7 - SID base e player SF2

- Stato: `Consolidamento`
- Preparazione attuale: note ADSR + player SF2 in IRQ acquisiti; buon controllo degli entry point.
- Uscita modulo:
  - Suonare SFX semplici e musica in parallelo con logica di gioco.
  - Documentare `INIT/TICK`, ZP del player e timing IRQ.

## Backlog ripasso prioritario (score 2-3)

1. Moltiplicazione 8x8 shift-and-add.
2. Timing frame-safe (`WaitFrame/Wait`) e casi limite.
3. Puntatori ZP con offset (carry su byte alto).
4. Tastiera: mapping PETSCII vs screen codes.
5. Gestione due screen buffer e aggiornamento colore coerente.

## Nuovi argomenti pianificati (score 0)

1. Copia Character ROM nel bank RAM.
2. Collisioni sprite (`$D01E/$D01F`).

## Prossimi esercizi consigliati

1. `17_charsetCopy.asm` - copia charset ROM in RAM e attivazione via `$D018`.
2. `18_spriteCollision.asm` - rilevazione collisione sprite/sfondo e reset flag.
3. `19_stableRaster.asm` - completare catena 3 IRQ (`arm/top/bottom`) per fascia stabile.

## Regola di manutenzione del piano

Dopo ogni esercizio:

1. aggiornare `study/checklist.md`;
2. aggiornare questo file (`study/course-plan.md`) con:
   - stato dei moduli toccati;
   - breve nota su cosa e stato consolidato;
   - prossimi 1-2 passi consigliati.
