# Checklist di apprendimento

**Media: 4.6/10** (104 concetti appresi, 3 da imparare)

Punteggio: 1-10 (1=visto di sfuggita, 5=capito, 10=padronanza)

## Fondamentali KickAssembler

| Concetto | Score |
|----------|-------|
| Punto di ingresso con `BasicUpstart2(start)` | 7 |
| Costanti con `.const` | 7 |
| Espressioni immediate in KickAssembler (es. `#16+40*5`) | 5 |
| Scopes con blocchi `{ }` per organizzare subroutine | 4 |

## I/O e memoria video

| Concetto | Score |
|----------|-------|
| Registri VIC-II per colori: `BORDER $D020`, `BACKGROUND $D021` | 6 |
| Memoria schermo `SCREEN $0400` e colori `COLOR $D800` | 7 |
| Scrittura diretta di screen codes e colori con `sta` | 7 |
| Pulizia schermo scrivendo spazio (`$20`) su 4 pagine da 256 byte | 4 |
| Cambio charset via KERNAL `CHROUT` con codici `$0E` / `$8E` | 3 |

## Controllo flusso e loop

| Concetto | Score |
|----------|-------|
| Loop con `LDX`, `INX`, `CPX`, `BNE` | 7 |
| Uso di `TXA`, `CLC`, `ADC` per generare valori in A | 4 |
| Loop infinito con `jmp *` | 8 |

## Subroutine e chiamate KERNAL

| Concetto | Score |
|----------|-------|
| Chiamare routine KERNAL con `JSR` (`$FFD2` CHROUT) | 5 |
| Definire subroutine con `rts` | 5 |

## Stringhe e puntatori

| Concetto | Score |
|----------|-------|
| Definire stringhe con `.encoding` + `.text` + terminatore `0` | 3 |
| Puntatori in zero page e indirizzamento `(PNT),y` | 4 |
| Aggiunta di un offset a un puntatore (lo/hi con carry) | 3 |

## VIC-II e doppio schermo

| Concetto | Score |
|----------|-------|
| Selezione della screen base con `$D018` (bit 4-7) | 4 |
| Mascherare `D018` con `AND`/`ORA` per preservare il charset | 4 |
| Gestione di due screen buffer (`$0400` e `$0C00`) | 3 |
| Cambio colori globali e riempimento color RAM | 3 |

## Timing

| Concetto | Score |
|----------|-------|
| Attesa di un frame via raster `$D012` | 3 |
| Delay in frames con contatore in X | 3 |

## Input da tastiera

| Concetto | Score |
|----------|-------|
| Lettura tasto con KERNAL `GETIN` (`$FFE4`) | 4 |
| GETIN restituisce 0 se nessun tasto è premuto | 5 |
| Confronto con `CMP` e branch condizionale `BEQ` | 5 |
| Differenza PETSCII (I/O) vs screen codes (memoria video) | 4 |
| Gestione tasti cursore (UP=$91, DOWN=$11, LEFT=$9D, RIGHT=$1D) | 3 |
| Main loop con polling tastiera e dispatch multiplo | 3 |

## Movimento e coordinate

| Concetto | Score |
|----------|-------|
| Variabili posX/posY per tracciare posizione su schermo | 4 |
| Incremento/decremento coordinate con `INC`/`DEC` | 5 |
| Wrap-around ai bordi (0-39 per X, 0-24 per Y) | 3 |
| Cancellare posizione precedente scrivendo spazio ($20) | 4 |

## Matematica e librerie

| Concetto | Score |
|----------|-------|
| Calcolo indirizzo schermo: SCREEN + Y*40 + X | 3 |
| Moltiplicazione 8x8 bit con risultato 16 bit (shift-and-add) | 2 |
| Uso di libreria esterna con `#import` | 5 |
| Indirizzamento indiretto indicizzato `(ZP),y` | 4 |
| Aritmetica a 16 bit (somma con carry su due byte) | 3 |

## Sintassi KickAssembler avanzata

| Concetto | Score |
|----------|-------|
| Differenza tra `.const` e `.label` | 6 |
| Label automatiche con `:` equivale a `.label nome = *` | 5 |
| `.var` e `.eval` per variabili assembler (scripting compile-time) | 3 |
| Tutti i simboli spariscono dopo la compilazione | 6 |
| "Variabile runtime" = label fissa + contenuto modificabile | 5 |
| `BasicUpstart2(label)` genera linea BASIC con SYS | 6 |
| Direttiva `*=` per impostare il program counter | 5 |

## Stack

| Concetto | Score |
|----------|-------|
| Lo stack è in pagina 1 ($0100-$01FF), cresce verso il basso | 4 |
| `PHA` salva A sullo stack, `PLA` lo recupera | 4 |
| Per salvare X: `TXA` + `PHA`, per ripristinare: `PLA` + `TAX` | 3 |
| Regola LIFO: ultimo salvato = primo recuperato | 4 |
| Convenzione: chi modifica un registro lo salva e ripristina | 3 |

## Lookup table

| Concetto | Score |
|----------|-------|
| `.lohifill` per generare tabelle di byte lo/hi con espressione | 4 |
| Accesso con `tabella.lo,x` e `tabella.hi,x` | 4 |
| Precalcolare indirizzi invece di moltiplicare a runtime | 5 |

## VIC-II Bank

| Concetto | Score |
|----------|-------|
| Il VIC vede solo 16KB alla volta (4 bank) | 5 |
| Selezione bank via $DD00 bit 0-1 (valori invertiti) | 4 |
| $D018 imposta offset schermo (bit 4-7) e charset (bit 1-3) | 6 |
| Bank 0 e 2 hanno Character ROM a $1000/$9000 | 4 |
| Copiare Character ROM nel bank | 0 |

## Sprite

| Concetto | Score |
|----------|-------|
| Abilitare sprite via $D015 (bit 0-7 per sprite 0-7) | 5 |
| Posizione X/Y con $D000-$D00F | 5 |
| Colore sprite con $D027-$D02E | 4 |
| Sprite pointer: ultimi 8 byte dello schermo ($07F8-$07FF) | 5 |
| Calcolo pointer: indirizzo_sprite / 64 | 6 |
| Sprite data: 64 byte (21 righe × 3 byte + 1 padding) | 4 |
| Posizionare sprite data con `*=$indirizzo` | 5 |
| MSB per posizione X > 255 ($D010) | 4 |
| Movimento sprite con input | 4 |
| Sprite multicolor | 4 |
| Collisioni sprite | 0 |

## IRQ e Interrupt

| Concetto | Score |
|----------|-------|
| SEI/CLI per disabilitare/abilitare interrupt globali | 5 |
| Vettore IRQ hardware $FFFE/$FFFF (con KERNAL off) | 5 |
| Vettore IRQ KERNAL $0314/$0315 (con KERNAL on) | 4 |
| Processor Port $01 per bank switching ROM/RAM | 5 |
| Configurazione $35 = KERNAL off, I/O on | 5 |
| Raster line a 9 bit: $D012 (low) + $D011 bit 7 (high) | 5 |
| Abilitare raster IRQ con $D01A bit 0 | 5 |
| Acknowledge IRQ scrivendo 1 in $D019 | 6 |
| Salvare/ripristinare A/X/Y nell'handler | 5 |
| RTI per tornare dal interrupt | 5 |
| Differenza RTI vs JMP $EA31 vs JMP $EA81 | 4 |
| Raster jitter e sue cause | 4 |
| Stable raster (double IRQ) | 0 |
| IRQ multipli nello stesso frame (raster split) | 6 |
| CIA1 genera IRQ timer - disabilitare con $DC0D = $7F | 6 |
| CIA2 può generare NMI - disabilitare con $DD0D = $7F | 6 |

## Joystick e CIA

| Concetto | Score |
|----------|-------|
| Lettura joystick porta 2 da $DC00 (CIA1 Port A) | 6 |
| Lettura joystick porta 1 da $DC01 (CIA1 Port B) | 4 |
| Bit active-low: 0 = premuto, 1 = rilasciato | 7 |
| Mapping bit: 0=su, 1=giù, 2=sx, 3=dx, 4=fuoco | 7 |
| Pattern LSR + BCS per testare direzioni in sequenza | 7 |
| Pattern AND + BEQ per testare singolo bit | 6 |
| CIA1 ICR ($DC0D) per gestione interrupt CIA | 6 |
| Game loop pattern: input in mainLoop, movimento in IRQ | 6 |

## Bitshift e operazioni sui bit

| Concetto | Score |
|----------|-------|
| LSR shifta a destra, bit 0 va nel Carry | 7 |
| Dopo N LSR, il bit N originale è nel Carry | 7 |
| BCS salta se Carry=1, BCC salta se Carry=0 | 7 |
| AND con maschera per isolare bit specifici | 6 |
| ORA per settare bit, AND per clearare bit | 5 |

## SID (Sound Interface Device)

| Concetto | Score |
|----------|-------|
| 3 voci indipendenti, 7 registri per voce | 5 |
| Waveform: Triangle, Sawtooth, Pulse, Noise (no Sine) | 5 |
| ADSR: Attack/Decay in $D405, Sustain/Release in $D406 | 6 |
| Frequenza a 16 bit: freq lo/hi ($D400/$D401) | 6 |
| Gate bit (bit 0 di Control): 1=nota ON, 0=Release | 6 |
| Volume globale: 4 bit bassi di $D418 | 6 |
| Ordine setup: volume → ADSR → frequenza → gate ON | 6 |
| Frequenze diverse tra PAL e NTSC (clock diverso) | 4 |
| Player SF2: INIT una volta + TICK a ogni frame in IRQ | 7 |
| Entry point del TICK non fisso: va verificato nel PRG packato | 7 |
| Zero page del player scelta nel pack: evitare conflitti con ZP utente | 6 |
