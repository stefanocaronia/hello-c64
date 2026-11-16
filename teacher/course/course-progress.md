# Progressi Corso

**Media: 4.9/10** (142 concetti appresi, 7 da imparare)

Punteggio: 0-10 (0=argomento ancora da studiare, 1=visto di sfuggita, 3=capito con aiuto, 5=capito, 7=applicato in autonomia, 10=padronanza). La media considera solo i concetti con score maggiore di 0.

Ultimo ripasso: data dell'ultima volta in cui il concetto è stato esercitato o interrogato. Le date fino al 2026-02-28 sono ricavate dalla cronologia git del file.

## Da studiare

| Concetto | Score | Ultimo ripasso |
|----------|-------|----------------|
| Conversione coordinate sprite → cella della mappa (riga/colonna char) | 0 | - |
| Collisione su tilemap leggendo il material della cella | 0 | - |
| SFX SID su eventi di gioco e priorità SFX/musica | 0 | - |
| Punteggio, vite e HUD | 0 | - |
| State machine di gioco (titolo, partita, game over) | 0 | - |
| Separazione in moduli (input, physics, render, audio) | 0 | - |
| SID Factory II: HR table, Tempo table, Init table, Commands | 0 | - |

## Fondamentali KickAssembler

| Concetto | Score | Ultimo ripasso |
|----------|-------|----------------|
| Punto di ingresso con `BasicUpstart2(start)` | 7 | 2026-01-27 |
| Costanti con `.const` | 7 | 2026-01-27 |
| Espressioni immediate in KickAssembler (es. `#16+40*5`) | 5 | 2026-01-27 |
| Scopes con blocchi `{ }` per organizzare subroutine | 4 | 2026-01-27 |

## I/O e memoria video

| Concetto | Score | Ultimo ripasso |
|----------|-------|----------------|
| Registri VIC-II per colori: `BORDER $D020`, `BACKGROUND $D021` | 6 | 2026-01-27 |
| Memoria schermo `SCREEN $0400` e colori `COLOR $D800` | 7 | 2026-01-27 |
| Scrittura diretta di screen codes e colori con `sta` | 7 | 2026-01-27 |
| Pulizia schermo scrivendo spazio (`$20`) su 4 pagine da 256 byte | 4 | 2026-01-27 |
| Cambio charset via KERNAL `CHROUT` con codici `$0E` / `$8E` | 3 | 2026-01-27 |

## Controllo flusso e loop

| Concetto | Score | Ultimo ripasso |
|----------|-------|----------------|
| Loop con `LDX`, `INX`, `CPX`, `BNE` | 7 | 2026-01-27 |
| Uso di `TXA`, `CLC`, `ADC` per generare valori in A | 4 | 2026-01-27 |
| Loop infinito con `jmp *` | 8 | 2026-01-27 |

## Subroutine e chiamate KERNAL

| Concetto | Score | Ultimo ripasso |
|----------|-------|----------------|
| Chiamare routine KERNAL con `JSR` (`$FFD2` CHROUT) | 5 | 2026-01-27 |
| Definire subroutine con `rts` | 5 | 2026-01-27 |

## Stringhe e puntatori

| Concetto | Score | Ultimo ripasso |
|----------|-------|----------------|
| Definire stringhe con `.encoding` + `.text` + terminatore `0` | 3 | 2026-01-27 |
| Puntatori in zero page e indirizzamento `(PNT),y` | 6 | 2026-02-24 |
| Aggiunta di un offset a un puntatore (lo/hi con carry) | 3 | 2026-01-27 |

## VIC-II e doppio schermo

| Concetto | Score | Ultimo ripasso |
|----------|-------|----------------|
| Selezione della screen base con `$D018` (bit 4-7) | 4 | 2026-01-27 |
| Mascherare `D018` con `AND`/`ORA` per preservare il charset | 4 | 2026-01-27 |
| Gestione di due screen buffer (`$0400` e `$0C00`) | 3 | 2026-01-27 |
| Cambio colori globali e riempimento color RAM | 3 | 2026-01-27 |

## Timing

| Concetto | Score | Ultimo ripasso |
|----------|-------|----------------|
| Attesa di un frame via raster `$D012` | 3 | 2026-01-27 |
| Delay in frames con contatore in X | 3 | 2026-01-27 |

## Input da tastiera

| Concetto | Score | Ultimo ripasso |
|----------|-------|----------------|
| Lettura tasto con KERNAL `GETIN` (`$FFE4`) | 4 | 2026-01-27 |
| GETIN restituisce 0 se nessun tasto è premuto | 5 | 2026-01-27 |
| Confronto con `CMP` e branch condizionale `BEQ` | 5 | 2026-01-27 |
| Differenza PETSCII (I/O) vs screen codes (memoria video) | 4 | 2026-01-27 |
| Gestione tasti cursore (UP=$91, DOWN=$11, LEFT=$9D, RIGHT=$1D) | 3 | 2026-01-27 |
| Main loop con polling tastiera e dispatch multiplo | 3 | 2026-01-27 |

## Movimento e coordinate

| Concetto | Score | Ultimo ripasso |
|----------|-------|----------------|
| Variabili posX/posY per tracciare posizione su schermo | 4 | 2026-01-27 |
| Incremento/decremento coordinate con `INC`/`DEC` | 5 | 2026-01-27 |
| Wrap-around ai bordi (0-39 per X, 0-24 per Y) | 3 | 2026-01-27 |
| Cancellare posizione precedente scrivendo spazio ($20) | 4 | 2026-01-27 |

## Matematica e librerie

| Concetto | Score | Ultimo ripasso |
|----------|-------|----------------|
| Calcolo indirizzo schermo: SCREEN + Y*40 + X | 3 | 2026-01-27 |
| Moltiplicazione 8x8 bit con risultato 16 bit (shift-and-add) | 3 | 2026-02-28 |
| Uso di libreria esterna con `#import` | 5 | 2026-01-27 |
| Indirizzamento indiretto indicizzato `(ZP),y` | 6 | 2026-02-24 |
| Aritmetica a 16 bit (somma con carry su due byte) | 4 | 2026-02-28 |
| Carry flag: riporto della somma, ADC fa A + valore + Carry | 4 | 2026-02-28 |
| ASL moltiplica per 2, bit 7 esce nel Carry | 4 | 2026-02-28 |
| ROL raccoglie Carry nel bit 0 (shift 16-bit con coppia ASL/ROL) | 3 | 2026-02-28 |
| Decomposizione moltiplicazione: 40 = 32+8, N*40 = N*32 + N*8 | 3 | 2026-02-28 |
| `adc #0` per propagare solo il carry al byte alto | 4 | 2026-02-28 |

## Sintassi KickAssembler avanzata

| Concetto | Score | Ultimo ripasso |
|----------|-------|----------------|
| Differenza tra `.const` e `.label` | 6 | 2026-01-27 |
| Label automatiche con `:` equivale a `.label nome = *` | 5 | 2026-01-27 |
| `.var` e `.eval` per variabili assembler (scripting compile-time) | 3 | 2026-01-27 |
| Tutti i simboli spariscono dopo la compilazione | 6 | 2026-01-27 |
| "Variabile runtime" = label fissa + contenuto modificabile | 5 | 2026-01-27 |
| `BasicUpstart2(label)` genera linea BASIC con SYS | 6 | 2026-01-27 |
| Direttiva `*=` per impostare il program counter | 5 | 2026-01-27 |

## Stack

| Concetto | Score | Ultimo ripasso |
|----------|-------|----------------|
| Lo stack è in pagina 1 ($0100-$01FF), cresce verso il basso | 4 | 2026-01-27 |
| `PHA` salva A sullo stack, `PLA` lo recupera | 4 | 2026-01-27 |
| Per salvare X: `TXA` + `PHA`, per ripristinare: `PLA` + `TAX` | 4 | 2026-02-24 |
| Regola LIFO: ultimo salvato = primo recuperato | 4 | 2026-01-27 |
| Convenzione: chi modifica un registro lo salva e ripristina | 3 | 2026-01-27 |

## Lookup table

| Concetto | Score | Ultimo ripasso |
|----------|-------|----------------|
| `.lohifill` per generare tabelle di byte lo/hi con espressione | 4 | 2026-01-27 |
| Accesso con `tabella.lo,x` e `tabella.hi,x` | 4 | 2026-01-27 |
| Precalcolare indirizzi invece di moltiplicare a runtime | 5 | 2026-01-27 |

## VIC-II Bank

| Concetto | Score | Ultimo ripasso |
|----------|-------|----------------|
| Il VIC vede solo 16KB alla volta (4 bank) | 5 | 2026-01-27 |
| Selezione bank via $DD00 bit 0-1 (valori invertiti) | 4 | 2026-01-27 |
| $D018 imposta offset schermo (bit 4-7) e charset (bit 1-3) | 7 | 2026-02-12 |
| Bank 0 e 2 hanno Character ROM a $1000/$9000 | 4 | 2026-01-27 |
| Copiare Character ROM nel bank | 6 | 2026-02-12 |

## Sprite

| Concetto | Score | Ultimo ripasso |
|----------|-------|----------------|
| Abilitare sprite via $D015 (bit 0-7 per sprite 0-7) | 5 | 2026-01-27 |
| Posizione X/Y con $D000-$D00F | 5 | 2026-01-27 |
| Colore sprite con $D027-$D02E | 4 | 2026-01-27 |
| Sprite pointer: ultimi 8 byte dello schermo ($07F8-$07FF) | 5 | 2026-01-27 |
| Calcolo pointer: indirizzo_sprite / 64 | 6 | 2026-01-27 |
| Sprite data: 64 byte (21 righe × 3 byte + 1 padding) | 4 | 2026-01-27 |
| Posizionare sprite data con `*=$indirizzo` | 5 | 2026-01-27 |
| MSB per posizione X > 255 ($D010) | 4 | 2026-01-30 |
| Movimento sprite con input | 4 | 2026-01-30 |
| Sprite multicolor | 4 | 2026-01-30 |
| Collisioni sprite | 6 | 2026-02-14 |
| Collisioni sprite-sfondo ($D01F) | 6 | 2026-02-14 |
| Collision registers clear-on-read: salvare in variabile prima di testare | 5 | 2026-02-26 |

## IRQ e Interrupt

| Concetto | Score | Ultimo ripasso |
|----------|-------|----------------|
| SEI/CLI per disabilitare/abilitare interrupt globali | 5 | 2026-02-03 |
| Vettore IRQ hardware $FFFE/$FFFF (con KERNAL off) | 5 | 2026-02-03 |
| Vettore IRQ KERNAL $0314/$0315 (con KERNAL on) | 4 | 2026-02-03 |
| Processor Port $01 per bank switching ROM/RAM | 6 | 2026-02-12 |
| Configurazione $35 = KERNAL off, I/O on | 5 | 2026-02-03 |
| Raster line a 9 bit: $D012 (low) + $D011 bit 7 (high) | 5 | 2026-02-03 |
| Abilitare raster IRQ con $D01A bit 0 | 5 | 2026-02-03 |
| Acknowledge IRQ scrivendo 1 in $D019 | 6 | 2026-02-03 |
| Salvare/ripristinare A/X/Y nell'handler | 5 | 2026-02-03 |
| RTI per tornare dal interrupt | 5 | 2026-02-03 |
| Differenza RTI vs JMP $EA31 vs JMP $EA81 | 4 | 2026-02-03 |
| Raster jitter e sue cause | 5 | 2026-02-09 |
| Stable raster (double IRQ) | 4 | 2026-02-09 |
| Calcolo cicli loop `DEX/BNE` (`5*N-1`) | 6 | 2026-02-09 |
| Formula timing fascia raster: `X = (R*63 - P + 1)/5` | 5 | 2026-02-09 |
| Limite pratico delay con `X` a 8 bit (serve doppio loop/IRQ) | 5 | 2026-02-09 |
| IRQ multipli nello stesso frame (raster split) | 6 | 2026-02-05 |
| CIA1 genera IRQ timer - disabilitare con $DC0D = $7F | 6 | 2026-02-05 |
| CIA2 può generare NMI - disabilitare con $DD0D = $7F | 6 | 2026-02-08 |

## Joystick e CIA

| Concetto | Score | Ultimo ripasso |
|----------|-------|----------------|
| Lettura joystick porta 2 da $DC00 (CIA1 Port A) | 6 | 2026-02-05 |
| Lettura joystick porta 1 da $DC01 (CIA1 Port B) | 4 | 2026-02-05 |
| Bit active-low: 0 = premuto, 1 = rilasciato | 7 | 2026-02-05 |
| Mapping bit: 0=su, 1=giù, 2=sx, 3=dx, 4=fuoco | 7 | 2026-02-05 |
| Pattern LSR + BCS per testare direzioni in sequenza | 7 | 2026-02-05 |
| Pattern AND + BEQ per testare singolo bit | 6 | 2026-02-05 |
| CIA1 ICR ($DC0D) per gestione interrupt CIA | 6 | 2026-02-05 |
| Game loop pattern: input in mainLoop, movimento in IRQ | 7 | 2026-02-10 |

## Bitshift e operazioni sui bit

| Concetto | Score | Ultimo ripasso |
|----------|-------|----------------|
| LSR shifta a destra, bit 0 va nel Carry | 7 | 2026-02-05 |
| Dopo N LSR, il bit N originale è nel Carry | 7 | 2026-02-05 |
| BCS salta se Carry=1, BCC salta se Carry=0 | 7 | 2026-02-05 |
| AND con maschera per isolare bit specifici | 6 | 2026-02-05 |
| ORA per settare bit, AND per clearare bit | 5 | 2026-02-05 |
| EOR per invertire (toggle) bit specifici | 4 | 2026-02-26 |

## SID (Sound Interface Device)

| Concetto | Score | Ultimo ripasso |
|----------|-------|----------------|
| 3 voci indipendenti, 7 registri per voce | 5 | 2026-02-07 |
| Waveform: Triangle, Sawtooth, Pulse, Noise (no Sine) | 5 | 2026-02-07 |
| ADSR: Attack/Decay in $D405, Sustain/Release in $D406 | 6 | 2026-02-07 |
| Frequenza a 16 bit: freq lo/hi ($D400/$D401) | 6 | 2026-02-07 |
| Gate bit (bit 0 di Control): 1=nota ON, 0=Release | 6 | 2026-02-07 |
| Volume globale: 4 bit bassi di $D418 | 6 | 2026-02-07 |
| Ordine setup: volume → ADSR → frequenza → gate ON | 6 | 2026-02-07 |
| Frequenze diverse tra PAL e NTSC (clock diverso) | 4 | 2026-02-07 |
| Player SF2: INIT una volta + TICK a ogni frame in IRQ | 7 | 2026-02-08 |
| Entry point del TICK non fisso: va verificato nel PRG packato | 7 | 2026-02-08 |
| Zero page del player scelta nel pack: evitare conflitti con ZP utente | 6 | 2026-02-08 |

## CharPad e Tilemap

| Concetto | Score | Ultimo ripasso |
|----------|-------|----------------|
| Creare progetto CharPad: display mode, colouring method, tile on/off | 5 | 2026-02-23 |
| Disegnare character in multicolour (4 penne: Bg/Fg/M1/M2) | 4 | 2026-02-23 |
| Assegnare material ai character per collision detection | 5 | 2026-02-23 |
| Dipingere mappa nel Map Editor | 5 | 2026-02-23 |
| Export binari da CharPad (charset, attributi, mappa) | 6 | 2026-02-23 |
| Import binari in assembly con `.import binary` e `*=` | 6 | 2026-02-23 |
| Text Multicolour mode: $D016 bit 4, colori $D022/$D023 | 5 | 2026-02-23 |
| Colour RAM: colore 0-7 = HR, colore 8-15 = MC (bit 3 = flag) | 4 | 2026-02-23 |
| VIC Bank selection via $DD00 (bit invertiti!) | 5 | 2026-02-23 |
| Copia blocco memoria multi-pagina con puntatori zero page | 5 | 2026-02-24 |
| Lookup indiretta: leggere char index → cercare attributo in tabella | 5 | 2026-02-24 |
| Alternativa allo stack: usare variabile RAM come contatore (counter pattern) | 5 | 2026-02-24 |
| Attribute byte: high nybble = material, low nybble = colour (AND #$0F) | 5 | 2026-02-23 |

## Self-Modifying Code

| Concetto | Score | Ultimo ripasso |
|----------|-------|----------------|
| Il codice può modificare i propri byte di istruzione in RAM a runtime | 4 | 2026-02-26 |
| INC su byte alto di un indirizzo per avanzare di pagina (+256 byte) | 4 | 2026-02-26 |
| Label sulle istruzioni da modificare per evitare conteggi manuali dei byte | 4 | 2026-02-26 |
| Confronto SMC vs Zero Page: SMC più veloce ma solo per accesso lineare | 4 | 2026-02-26 |

## Modalità di indirizzamento 6502

| Concetto | Score | Ultimo ripasso |
|----------|-------|----------------|
| Immediato (`LDA #$35`): 2 cicli, valore nell'istruzione | 6 | 2026-02-26 |
| Zero Page (`LDA $35`): 3 cicli, più veloce di Absolute | 5 | 2026-02-26 |
| Absolute (`LDA $0400`): 4 cicli | 5 | 2026-02-26 |
| Zero Page vs Absolute: stesso indirizzo, ZP è 1 ciclo più veloce | 5 | 2026-02-26 |
| Relativo: usato SOLO dai branch (BEQ, BNE...), offset -128/+127 | 5 | 2026-02-26 |
