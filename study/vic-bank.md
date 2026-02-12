# VIC-II Bank

Il VIC-II vede solo 16KB alla volta. La memoria 64KB è divisa in 4 bank.

## Selezione Bank ($DD00)

| Bit 0-1 | Bank | Indirizzi       | Note |
|---------|------|-----------------|------|
| `%11`   | 0    | $0000-$3FFF     | Default. Char ROM a $1000 |
| `%10`   | 1    | $4000-$7FFF     | Tutto libero! |
| `%01`   | 2    | $8000-$BFFF     | Char ROM a $9000 |
| `%00`   | 3    | $C000-$FFFF     | I/O a $D000 (problema) |

```asm
// Seleziona bank 1
lda $DD00
and #%11111100    // azzera bit 0-1
ora #%00000010    // imposta %10 = bank 1
sta $DD00
```

**Nota:** I valori sono invertiti! %11 = bank 0, %00 = bank 3.

**Character ROM:** Nel bank 0 e 2, il VIC vede la ROM charset a $1000/$9000 invece della RAM. Nel bank 1 e 3 non c'è questo problema.

---

## VIC vs CPU: due "viste" diverse

Quando diciamo "il VIC vede", parliamo di dove **il chip video** legge i dati per disegnare.
La CPU (il tuo codice Assembly) non ha sempre la stessa vista.

- **Vista VIC (grafica):**
  - in bank 0: charset ROM visibile a offset `+$1000`
  - in bank 2: charset ROM visibile a offset `+$1000` del bank (indirizzo assoluto `$9000`)
- **Vista CPU (6510):**
  - l'area `$D000-$DFFF` e' una finestra mappata
  - con `CHAREN=1` (default) vedi I/O (VIC/SID/CIA)
  - con `CHAREN=0` vedi Character ROM (utile per copiarla in RAM)

Quindi non sposti nulla fisicamente: cambi solo **cosa e' visibile** in quella finestra.

### Flusso pratico per copiare il charset ROM

1. Salva il valore corrente di `$01`.
2. Metti `CHAREN=0` (es. configurazione `$33`) per leggere la Character ROM da `$D000-$D7FF`.
3. Copia 2048 byte in una zona RAM del bank VIC scelto.
4. Ripristina il valore originale di `$01`.
5. Imposta `$D018` per far leggere al VIC il charset RAM.

Nota: mentre `CHAREN=0`, i registri I/O in `$D000-$DFFF` non sono visibili alla CPU.

---

## Offset schermo e charset ($D018)

Dentro il bank corrente, $D018 imposta gli offset:
- **Bit 4-7**: schermo (× $0400)
- **Bit 1-3**: charset (× $0800)

### Offset schermo

| Schermo | Offset | Bit 4-7 |
| ------- | ------ | ------- |
| +$0000  | 0      | %0000   |
| +$0400  | 1      | %0001   |
| +$0800  | 2      | %0010   |
| +$0C00  | 3      | %0011   |

### Offset charset

| Charset | Offset | Bit 1-3 |
| ------- | ------ | ------- |
| +$0000  | 0      | %000    |
| +$0800  | 1      | %001    |
| +$1000  | 2      | %010    | <- default (Char ROM in bank 0/2)
| +$1800  | 3      | %011    |
| +$2000  | 4      | %100    |

```asm
// Imposta schermo a offset $0400 (mantenendo charset)
lda $D018
and #%00001111
ora #%00010000
sta $D018

// Imposta charset a offset $2000 (mantenendo schermo)
lda $D018
and #%11110001
ora #%00001000    // %100 << 1 = %1000
sta $D018
```

**Indirizzo finale** = base bank + offset $D018

Esempio: bank 1 + offset $0400 = schermo a $4400

---

## Configurazione tipica per giochi

**Bank 1** ($4000-$7FFF) consigliato:
- $4000-$47FF: Charset custom (2KB)
- $4800-$4BFF: Screen RAM (1KB)
- $4C00-$7FFF: Sprite data, grafica, dati gioco

**Codice** a $0800 o $C000 (fuori dal bank VIC).
