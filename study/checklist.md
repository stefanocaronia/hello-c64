# Checklist di apprendimento

## Fondamentali KickAssembler

- [x] Punto di ingresso con `BasicUpstart2(start)`.
- [x] Costanti con `.const`.
- [x] Espressioni immediate in KickAssembler (es. `#16+40*5`).
- [x] Scopes con blocchi `{ }` per organizzare subroutine.

## I/O e memoria video

- [x] Registri VIC-II per colori: `BORDER $D020`, `BACKGROUND $D021`.
- [x] Memoria schermo `SCREEN $0400` e colori `COLOR $D800`.
- [x] Scrittura diretta di screen codes e colori con `sta`.
- [x] Pulizia schermo scrivendo spazio (`$20`) su 4 pagine da 256 byte.
- [x] Cambio charset via KERNAL `CHROUT` con codici `$0E` / `$8E`.

## Controllo flusso e loop

- [x] Loop con `LDX`, `INX`, `CPX`, `BNE`.
- [x] Uso di `TXA`, `CLC`, `ADC` per generare valori in A.
- [x] Loop infinito con `jmp`.

## Subroutine e chiamate KERNAL

- [x] Chiamare routine KERNAL con `JSR` (`$FFD2` CHROUT).
- [x] Definire subroutine con `rts`.

## Stringhe e puntatori

- [x] Definire stringhe con `.encoding` + `.text` + terminatore `0`.
- [x] Puntatori in zero page (`PNT`, `PNT2`) e indirizzamento `(PNT),y`.
- [x] Aggiunta di un offset a un puntatore (lo/hi con carry).

## VIC-II e doppio schermo

- [x] Selezione della screen base con `$D018` (bit 4-7).
- [x] Mascherare `D018` con `AND`/`ORA` per preservare il charset.
- [x] Gestione di due screen buffer (`$0400` e `$0C00`).
- [x] Cambio colori globali e riempimento color RAM.

## Timing

- [x] Attesa di un frame via raster `$D012`.
- [x] Delay in frames con contatore in X.

## Input da tastiera

- [x] Lettura tasto con KERNAL `GETIN` (`$FFE4`).
- [x] GETIN restituisce 0 se nessun tasto è premuto.
- [x] Confronto con `CMP` e branch condizionale `BEQ`.
- [x] Differenza PETSCII (I/O) vs screen codes (memoria video).
- [x] Gestione tasti cursore (UP=$91, DOWN=$11, LEFT=$9D, RIGHT=$1D).
- [x] Main loop con polling tastiera e dispatch multiplo.

## Movimento e coordinate

- [x] Variabili posX/posY per tracciare posizione su schermo.
- [x] Incremento/decremento coordinate con `INC`/`DEC`.
- [x] Wrap-around ai bordi (0-39 per X, 0-24 per Y).
- [x] Cancellare posizione precedente scrivendo spazio ($20).

## Matematica e librerie

- [x] Calcolo indirizzo schermo: SCREEN + Y*40 + X.
- [x] Moltiplicazione 8x8 bit con risultato 16 bit (shift-and-add).
- [x] Uso di libreria esterna con `#import`.
- [x] Indirizzamento indiretto indicizzato `(ZP),y` per scrivere a indirizzo calcolato.
- [x] Aritmetica a 16 bit (somma con carry su due byte).

## Sintassi KickAssembler avanzata

- [x] Differenza tra `.const` (costante compile-time) e `.label` (alias per indirizzo fisso).
- [x] Label automatiche con `:` per variabili con indirizzo calcolato dall'assembler.
- [x] `BasicUpstart2(label)` genera linea BASIC con SYS per avvio automatico.
- [x] Direttiva `*=` per impostare il program counter / indirizzo di caricamento.

## Stack

- [x] Lo stack è in pagina 1 ($0100-$01FF), cresce verso il basso.
- [x] `PHA` salva A sullo stack, `PLA` lo recupera.
- [x] Per salvare X: `TXA` + `PHA`, per ripristinare: `PLA` + `TAX`.
- [x] Regola LIFO: ultimo salvato = primo recuperato.
- [x] Convenzione: chi modifica un registro lo salva all'inizio e lo ripristina alla fine.
- [x] Prima di usare lo stack, valutare se basta un altro registro o una variabile.

## Lookup table

- [x] `.lohifill` per generare tabelle di byte lo/hi con espressione.
- [x] Accesso con `tabella.lo,x` e `tabella.hi,x`.
- [x] Precalcolare indirizzi invece di moltiplicare a runtime.
