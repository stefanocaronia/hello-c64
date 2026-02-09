# Piano Corso C64 Assembly (KickAssembler)

## Visione del corso

Obiettivo finale: portarti a progettare e sviluppare piccoli giochi completi per Commodore 64 in Assembly 6510, con toolchain moderna (KickAssembler + VS Code + VICE), codice mantenibile e debug consapevole.

## Obiettivi di uscita (capstone)

Al termine del percorso dovrai saper:

1. progettare il loop principale di un gioco (stati, input, update, render);
2. usare VIC-II per schermo, sprite, split raster e sincronizzazione a frame;
3. gestire input tastiera/joystick e logica di collisione;
4. integrare audio SID (SFX + musica) senza rompere il timing;
5. organizzare il codice in moduli riusabili (lib, macro, routine);
6. costruire e debuggare un mini gioco completo (titolo, gameplay base, game over/restart).

## Metodo didattico

- Ogni esercizio introduce al massimo 1-2 concetti nuovi.
- Ogni modulo ha prerequisiti chiari e criteri di uscita verificabili.
- Prima si consolida il controllo tecnico (memoria, cicli, IRQ), poi si compone il gameplay.
- Il progresso personale viene tracciato in `study/course-progress.md`.

## Struttura moduli

### Modulo 0 - Setup e workflow operativo

- Obiettivo: ambiente stabile di sviluppo e debug.
- Prerequisiti: nessuno.
- Contenuti:
  - build/run con KickAssembler;
  - avvio in VICE;
  - lettura memory map e uso monitor base.
- Esercizi consigliati:
  - compilazione e avvio file minimale;
  - prova breakpoint su una routine semplice.
- Uscita modulo:
  - sai compilare, eseguire e ispezionare memoria/registri senza supporto.

### Modulo 1 - Fondamentali 6510 e memoria video

- Obiettivo: controllo base CPU/memoria/schermo.
- Prerequisiti: Modulo 0.
- Contenuti:
  - registri A/X/Y, branch, loop;
  - screen RAM e color RAM;
  - subroutine e convenzioni base (`jsr/rts`).
- Esercizi consigliati:
  - stampa caratteri e pattern;
  - routine di clear screen strutturata.
- Uscita modulo:
  - sai scrivere routine leggibili per disegno testo/attributi a schermo.

### Modulo 2 - Input e game loop base

- Obiettivo: creare un ciclo gioco stabile con input.
- Prerequisiti: Modulo 1.
- Contenuti:
  - polling tastiera (`GETIN`) e joystick (CIA);
  - loop di update con controllo timing elementare.
- Esercizi consigliati:
  - movimento di un cursore/oggetto con limiti schermo;
  - gestione input multiplo con priorita` definite.
- Uscita modulo:
  - sai implementare un loop input->update->render senza blocchi.

### Modulo 3 - Puntatori, addressing e aritmetica 16 bit

- Obiettivo: manipolare buffer e indirizzi in modo robusto.
- Prerequisiti: Modulo 2.
- Contenuti:
  - addressing indiretto `(ZP),Y`;
  - carry e somme 16 bit;
  - calcolo offset e lookup table.
- Esercizi consigliati:
  - print stringa via puntatore ZP;
  - calcolo `SCREEN + y*40 + x` con tabella.
- Uscita modulo:
  - sai gestire dati dinamici e indirizzamento senza errori di pagina.

### Modulo 4 - VIC-II: bank, charset e layout schermo

- Obiettivo: controllo della memoria video avanzata.
- Prerequisiti: Modulo 3.
- Contenuti:
  - VIC bank via CIA2;
  - `D018` (screen/charset base);
  - copia charset ROM->RAM e attivazione custom charset.
- Esercizi consigliati:
  - switch tra screen buffer;
  - set caratteri personalizzati per HUD.
- Uscita modulo:
  - sai configurare layout video adatto a UI + area gioco.

### Modulo 5 - Sprite e movimento fluido

- Obiettivo: costruire entita` di gioco con sprite hardware.
- Prerequisiti: Modulo 4.
- Contenuti:
  - enable/posizione/colore sprite;
  - pointer sprite e MSB X;
  - multicolor sprite.
- Esercizi consigliati:
  - player sprite con movimento 4 direzioni;
  - gestione limiti schermo e velocita` costante.
- Uscita modulo:
  - sai gestire almeno 1-2 sprite con controllo affidabile.

### Modulo 6 - IRQ raster e sincronizzazione frame

- Obiettivo: timing stabile per effetti e logica periodica.
- Prerequisiti: Modulo 5.
- Contenuti:
  - setup IRQ (`$D01A/$D019`, vettori IRQ, `SEI/CLI`);
  - save/restore registri;
  - split raster e stable raster (double/triple IRQ).
- Esercizi consigliati:
  - raster bar stabile;
  - fascia colore con IRQ top/bottom;
  - catena IRQ `arm/top/bottom`.
- Uscita modulo:
  - sai sincronizzare update grafico senza jitter visibile significativo.

### Modulo 7 - Collisioni e logica gameplay

- Obiettivo: passare da demo tecnica a meccanica di gioco.
- Prerequisiti: Modulo 6.
- Contenuti:
  - collisioni sprite-sprite e sprite-background;
  - gestione vite, punteggio, stato partita.
- Esercizi consigliati:
  - oggetti da evitare/raccogliere;
  - trigger game over e restart.
- Uscita modulo:
  - sai implementare una core loop giocabile con regole chiare.

### Modulo 8 - SID: SFX e musica in gioco

- Obiettivo: integrare audio senza compromettere il frame budget.
- Prerequisiti: Modulo 7.
- Contenuti:
  - registri SID base (ADSR, waveform, gate);
  - integrazione player (es. SID Factory II export / routine init-tick);
  - priorita` SFX vs musica.
- Esercizi consigliati:
  - SFX su eventi gameplay;
  - musica di sottofondo con tick in IRQ.
- Uscita modulo:
  - sai orchestrare audio coerente col gioco e con timing stabile.

### Modulo 9 - Architettura gioco

- Obiettivo: progettare codice scalabile su progetto reale.
- Prerequisiti: Modulo 8.
- Contenuti:
  - state machine (title, play, pause, game over);
  - separazione moduli (input, physics, render, audio);
  - convenzioni naming, mappe memoria e allocazioni.
- Esercizi consigliati:
  - mini framework con dispatcher stati;
  - bootstrap unico + init moduli.
- Uscita modulo:
  - sai organizzare un progetto C64 non banale in modo mantenibile.

### Modulo 10 - Capstone: mini gioco completo

- Obiettivo: consegnare un gioco completo, piccolo ma rifinito.
- Prerequisiti: Modulo 9.
- Specifiche minime capstone:
  - schermata titolo;
  - gameplay continuo con obiettivo chiaro;
  - punteggio e game over;
  - almeno 2 tipi di entita` (player + nemico/oggetto);
  - audio (musica o SFX, preferibilmente entrambi);
  - stabilita` video senza artefatti evidenti.
- Uscita modulo:
  - gioco eseguibile in VICE, documentato, con codice comprensibile.

## Milestone consigliate

1. Milestone A - Demo tecnica: input + sprite + raster base.
2. Milestone B - Vertical slice: una meccanica giocabile completa.
3. Milestone C - Capstone: gioco completo con polish base.

## Criteri di qualita`

- Correttezza: nessun crash, nessun lock-up in uso normale.
- Stabilita` timing: frame regolari e IRQ ben gestiti.
- Leggibilita`: etichette chiare, macro/routine con responsabilita` nette.
- Riproducibilita`: build e run semplici, documentazione aggiornata.

## Manutenzione del piano

Aggiorna questo file quando cambia il design del corso:

1. obiettivi o ordine dei moduli;
2. esercizi suggeriti;
3. criteri di uscita;
4. milestone capstone.

Per il progresso personale usa sempre `study/course-progress.md`.
