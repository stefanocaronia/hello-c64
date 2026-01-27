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
