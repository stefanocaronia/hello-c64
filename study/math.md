# Aritmetica sul 6502

## Istruzioni

| Istruzione | Nome | Cosa fa |
|-----------|------|---------|
| `CLC` | Clear Carry | Carry = 0 |
| `SEC` | Set Carry | Carry = 1 |
| `ADC` | Add with Carry | A = A + valore + Carry |
| `SBC` | Subtract with Carry | A = A - valore - (1 - Carry) |
| `ASL` | Arithmetic Shift Left | Tutti i bit a sinistra, bit 7 → Carry, bit 0 ← 0 |
| `LSR` | Logical Shift Right | Tutti i bit a destra, bit 0 → Carry, bit 7 ← 0 |
| `ROL` | Rotate Left | Tutti i bit a sinistra, bit 7 → Carry, bit 0 ← vecchio Carry |
| `ROR` | Rotate Right | Tutti i bit a destra, bit 0 → Carry, bit 7 ← vecchio Carry |

## Il Carry flag

Il Carry è un singolo bit (0 o 1) nel registro dei flag del processore.
È il **riporto** delle somme in colonna, come alle elementari.

### ADC: il riporto nella somma

`ADC` fa sempre: `A + valore + Carry`. Se il risultato supera 255, il "di più" va nel Carry.

```
CLC              // Carry = 0
LDA #3           // A = 3
ADC #2           // 3 + 2 + 0 = 5. Sta in 8 bit → A = 5, Carry = 0

CLC              // Carry = 0
LDA #$FF         // A = 255
ADC #$02         // 255 + 2 + 0 = 257. NON sta in 8 bit!

  11111111  (255)
+ 00000010  (2)
----------
1 00000001  ← 9 bit!
↑ ↑↑↑↑↑↑↑↑
│    A = 00000001 (1)
└─ Carry = 1 (il nono bit "esce" nel flag)
```

### Analogia decimale

Immagina un computer dove ogni registro tiene solo 2 cifre (00-99):

```
99 + 02 = 101 → registro = 01, Carry = 1 (il "cento" esce nel carry)
50 + 30 = 80  → registro = 80, Carry = 0 (nessun riporto)
```

### Somme a 16 bit (due byte)

Somma in colonna, come a scuola: prima i bassi, poi gli alti con il riporto.

```
Sommare 320 + 80 usando due registri da 8 bit:

  hi=$01 lo=$40   (320 = $0140)
+ hi=$00 lo=$50   (80  = $0050)

Passo 1: somma i bassi
  CLC
  $40 + $50 = $90 → lo = $90, Carry = 0

Passo 2: somma gli alti + riporto
  $01 + $00 + Carry(0) = $01 → hi = $01

Risultato: $01:$90 = 400 ✓
```

Altro esempio con riporto:

```
  hi=$01 lo=$C0   (448 = $01C0)
+ hi=$00 lo=$80   (128 = $0080)

Passo 1: bassi
  CLC
  $C0 + $80 = $140 → lo = $40, Carry = 1 (riporto!)

Passo 2: alti + riporto
  $01 + $00 + Carry(1) = $02 → hi = $02

Risultato: $02:$40 = 576 ✓
```

In assembly:

```asm
CLC
LDA byte_basso_1
ADC byte_basso_2     // somma bassi, riporto va nel Carry
STA risultato_lo
LDA byte_alto_1
ADC byte_alto_2      // somma alti + riporto (NON fare CLC qui!)
STA risultato_hi
```

## ASL e ROL: moltiplicare per 2

`ASL` moltiplica per 2 shiftando i bit a sinistra. Ma se il risultato supera 255, il bit 7 esce nel Carry e si perde.

`ROL` su un byte alto "raccoglie" quel Carry, permettendo moltiplicazioni a 16 bit.

```
ASL su byte basso:        ROL su byte alto:

Carry ← [76543210] ← 0   Carry ← [76543210] ← vecchio Carry
         ↑                                      ↑
         bit 7 esce                  lo raccoglie qui
```

Esempio: moltiplicare 160 × 2 = 320

```
Prima:   hi=00000000  lo=10100000  Carry=0   (160)

ASL lo:  hi=00000000  lo=01000000  Carry=1   (bit 7 di 160 esce!)
ROL hi:  hi=00000001  lo=01000000  Carry=0   (il carry entra nel bit 0 di hi)

Dopo:    $01:$40 = 320 ✓
```