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
- Il progresso personale viene tracciato in `teacher/course/course-progress.md`.

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
- Esercizi nel repository: `0_loadingScreen.asm`, `00_labels.asm`.
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
- Esercizi nel repository: `1_printChars.asm`, `5_stack.asm`.
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
  - gestione input multiplo con priorità definite.
- Esercizi nel repository: `3_keyboardInput.asm`, `4_moveCharacter.asm`, `13_joystickRasterBar.asm`.
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
- Esercizi nel repository: `6_printString.asm`, `7_printStringZP.asm`, `8_lookupTable.asm`.
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
- Esercizi nel repository: `2_twoScreens.asm`, `9_vicBank.asm`, `9b_copyCharsetRom.asm`.
- Uscita modulo:
  - sai configurare layout video adatto a UI + area gioco.

### Modulo 5 - Sprite e movimento fluido

- Obiettivo: costruire entità di gioco con sprite hardware.
- Prerequisiti: Modulo 4.
- Contenuti:
  - enable/posizione/colore sprite;
  - pointer sprite e MSB X;
  - multicolor sprite.
- Esercizi consigliati:
  - player sprite con movimento 4 direzioni;
  - gestione limiti schermo e velocità costante.
- Esercizi nel repository: `10_sprite.asm`, `11_spriteMove.asm`.
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
- Esercizi nel repository: `12_rasterIRQ.asm`, `12b_rasterIRQ_kernal.asm`, `13_joystickRasterBar.asm`, `17_stableRaster.asm`.
- Uscita modulo:
  - sai sincronizzare update grafico senza jitter visibile significativo.

### Modulo 7 - SID: suono e musica

- Obiettivo: produrre suono e musica senza compromettere il frame budget.
- Prerequisiti: Modulo 6.
- Contenuti:
  - registri SID base (ADSR, waveform, gate, frequenza);
  - integrazione player (es. SID Factory II export / routine init-tick).
- Esercizi consigliati:
  - nota singola e melodia con i registri SID;
  - musica di sottofondo con tick in IRQ.
- Esercizi nel repository: `14_sid.asm`, `15_sidMelody.asm`, `16_sidPlayer.asm`.
- Uscita modulo:
  - sai far suonare una musica in IRQ con timing stabile.

### Modulo 8 - Tilemap e CharPad

- Obiettivo: costruire lo scenario di gioco con charset e mappe disegnati in CharPad.
- Prerequisiti: Modulo 3 (puntatori), Modulo 4 (bank e charset).
- Contenuti:
  - workflow CharPad: charset, mappa, attributi, material, export binari;
  - Text Multicolour (`$D016`, `$D022/$D023`, flag nella Colour RAM);
  - copia della mappa su screen RAM oltre i 256 byte (puntatori ZP o self-modifying code);
  - Colour RAM riempita dagli attributi dei char.
- Esercizi consigliati:
  - visualizzare una mappa 40x25 esportata da CharPad;
  - variante della copia con self-modifying code.
- Esercizi nel repository: `19_charpadTilemap.asm`, `19a_charpadTilemap_selfmod.asm`.
- Uscita modulo:
  - sai portare una mappa da CharPad allo schermo con i colori corretti.

### Modulo 9 - Collisioni e logica gameplay

- Obiettivo: passare da demo tecnica a meccanica di gioco.
- Prerequisiti: Modulo 8.
- Contenuti:
  - collisioni sprite-sprite e sprite-background (registri VIC);
  - collisioni su tilemap via material (coordinate sprite → cella della mappa);
  - gestione vite, punteggio, stato partita;
  - SFX su eventi di gioco, priorità SFX vs musica.
- Esercizi consigliati:
  - sprite che si muove sulla mappa con muri solidi (material);
  - oggetti da evitare/raccogliere;
  - trigger game over e restart.
- Esercizi nel repository: `18_spriteCollision.asm`.
- Uscita modulo:
  - sai implementare una core loop giocabile con regole chiare.

### Modulo 10 - Architettura gioco

- Obiettivo: progettare codice scalabile su progetto reale.
- Prerequisiti: Modulo 9.
- Contenuti:
  - state machine (title, play, pause, game over);
  - separazione moduli (input, physics, render, audio);
  - convenzioni naming, mappe memoria e allocazioni.
- Esercizi consigliati:
  - mini framework con dispatcher stati;
  - bootstrap unico + init moduli.
- Uscita modulo:
  - sai organizzare un progetto C64 non banale in modo mantenibile.

### Modulo 11 - Capstone: mini gioco completo

- Obiettivo: consegnare un gioco completo, piccolo ma rifinito.
- Prerequisiti: Modulo 10.
- Specifiche minime capstone:
  - schermata titolo;
  - gameplay continuo con obiettivo chiaro;
  - punteggio e game over;
  - almeno 2 tipi di entità (player + nemico/oggetto);
  - audio (musica o SFX, preferibilmente entrambi);
  - stabilità video senza artefatti evidenti.
- Uscita modulo:
  - gioco eseguibile in VICE, documentato, con codice comprensibile.

## Milestone consigliate

1. Milestone A - Demo tecnica: input + sprite + raster base.
2. Milestone B - Vertical slice: una meccanica giocabile completa.
3. Milestone C - Capstone: gioco completo con polish base.

## Criteri di qualità

- Correttezza: nessun crash, nessun lock-up in uso normale.
- Stabilità timing: frame regolari e IRQ ben gestiti.
- Leggibilità: etichette chiare, macro/routine con responsabilità nette.
- Riproducibilità: build e run semplici, documentazione aggiornata.

## Manutenzione del piano

Aggiorna questo file quando cambia il design del corso:

1. obiettivi o ordine dei moduli;
2. esercizi suggeriti;
3. criteri di uscita;
4. milestone capstone.

Per il progresso personale usa sempre `teacher/course/course-progress.md`.
