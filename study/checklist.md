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

## Matematica e librerie (avanzato)

- [x] Calcolo indirizzo schermo: SCREEN + Y*40 + X.
- [x] Moltiplicazione 8x8 bit con risultato 16 bit (shift-and-add).
- [x] Uso di libreria esterna con `#import`.
- [x] Indirizzamento indiretto indicizzato `(ZP),y` per scrivere a indirizzo calcolato.
- [x] Trucco colore: aggiungere $D4 al byte alto per passare da screen a color RAM.
