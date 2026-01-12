## Screen e colori

- Border color: `$D020`
- Background color: `$D021`
- Screen RAM base: `$0400`
- Color RAM base: `$D800`
- [C64 Screen Codes](c64-screen-codes.html)

### Tabella colori

| HEX  | DEC  | Color         |
| ---- | ---- | ------------- |
| `$0` | `0`  | nero          |
| `$1` | `1`  | bianco        |
| `$2` | `2`  | rosso         |
| `$3` | `3`  | ciano         |
| `$4` | `4`  | viola         |
| `$5` | `5`  | verde         |
| `$6` | `6`  | blu           |
| `$7` | `7`  | giallo        |
| `$8` | `8`  | arancione     |
| `$9` | `9`  | marrone       |
| `$A` | `10` | rosa          |
| `$B` | `11` | grigio scuro  |
| `$C` | `12` | grigio        |
| `$D` | `13` | verde chiaro  |
| `$E` | `14` | azzurro       |
| `$F` | `15` | grigio chiaro |

## KERNAL CHROUT ($FFD2)

| Code    | Effect                        |
| ------- | ----------------------------- |
| **$93** | CLR/HOME (clear screen)       |
| **$0E** | Lowercase / Uppercase charset |
| **$8E** | Uppercase / Graphics charset  |

```asm
lda #$93      // CLR/HOME (clear screen)
jsr $ffd2     // CHROUT
```

## VIC-II: screen base in $D018

I bit 4-7 selezionano lo screen buffer (index * 1024).

| Schermo | Indirizzo | Index |
| ------- | --------- | ----- |
| $0400   | 1024      | 1     |
| $0800   | 2048      | 2     |
| $0C00   | 3072      | 3     |

```asm
// imposta screen a $0400 mantenendo il charset
lda $d018
and #%00001111
ora #%00010000
sta $d018
```

## Encoding e stringhe

```asm
.encoding "screencode_upper"
msg: .text "SCREEN A"
     .byte 0
```

## Puntatori in zero page

```asm
PNT  = $FB
PNT2 = $FD

lda #<msg    // low
sta PNT2
lda #>msg    // high
sta PNT2+1

ldy #0
loop:
    lda (PNT2),y
    beq done
    sta (PNT),y
    iny
    bne loop
done:
```

## Offset su puntatore

```asm
clc
lda PNT
adc offLo
sta PNT
lda PNT+1
adc offHi
sta PNT+1
```

## Clear screen (space)

```asm
ldx #$00
loop:
    lda #$20
    sta SCREEN,x
    sta SCREEN+$0100,x
    sta SCREEN+$0200,x
    sta SCREEN+$0300,x
    inx
    bne loop
```

## Wait frame (raster $D012)

```asm
waitFrame:
    lda $d012
    bne waitFrame   // aspetta linea 0
waitNext:
    lda $d012
    beq waitNext    // aspetta che riparta
    rts
```
