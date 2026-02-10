# Layout File Esercizi ASM

Questa nota riassume il layout consigliato dei file esercizio (`<n>_nome.asm`) per evitare overlap in memoria.

## Ordine consigliato

1. `BasicUpstart2(start)`
2. Costanti e label (`.const`, `.label`)
3. `#import` librerie con subroutine (es. `lib/screen.asm`)
4. `#import` macro (es. `lib/macros.asm`)
5. Codice runtime (`start`, main loop, IRQ, subroutine)
6. Dati/binari con blocchi dedicati (`*=$xxxx`, `.byte`, `.import binary`)

## Regole pratiche

- Le subroutine importate (`screen.asm`, ecc.) generano byte nel punto corrente del program counter: importa nel blocco codice, non vicino ai blocchi dati/sprite.
- Le macro sono compile-time: non occupano memoria da sole.
- Le macro devono comunque essere importate prima del primo uso.
- Se una libreria richiede label (es. `SCREEN`), definiscile prima del relativo `#import`.

## Perche' succedono gli overlap

Se importi una libreria con codice quando il PC e' in un'area riservata ai dati (o prima di aver fissato bene il layout), il suo codice puo' finire nello stesso range dei dati (`*=$2000`, sprite, musica, ecc.).

## Template minimo

```asm
BasicUpstart2(start)

.label SCREEN = $0400
.label VIC_BORDER = $D020

#import "lib/screen.asm"
#import "lib/macros.asm"

start:
    ; codice
mainLoop:
    jmp mainLoop

*=$2000 "Sprite"
.import binary "assets/sprites/x.bin", 0, 64
```

