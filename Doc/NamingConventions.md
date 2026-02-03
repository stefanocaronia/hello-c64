# KickAssembler Naming Convention

## Overview

This document defines the naming conventions used in this project for KickAssembler code.

---

## Constants and Addresses

| Category | Convention | Example |
|----------|------------|---------|
| Hardware registers | `CHIP_NAME` (SCREAMING_SNAKE with chip prefix) | `VIC_BORDER`, `SID_VOLUME`, `CIA1_PORTA` |
| Memory addresses | `SCREAMING_SNAKE` | `SPRITE_DATA`, `SCREEN_RAM`, `CHARSET_ADDR` |
| Zero page addresses | `ZP_NAME` | `ZP_TEMP`, `ZP_PLAYER_X`, `ZP_POINTER_LO` |
| Numeric constants | `PascalCase` | `ColorWhite`, `MaxSprites`, `PlayerSpeed` |

### Examples

```asm
// Hardware registers (chip prefix)
.const VIC_BORDER = $d020
.const VIC_BACKGROUND = $d021
.const SID_VOLUME = $d418
.const CIA1_PORTA = $dc00

// Memory addresses
.const SCREEN_RAM = $0400
.const SPRITE_DATA = $2000
.const CHARSET_ADDR = $3800
.const MUSIC_ADDR = $1000

// Zero page
.const ZP_TEMP = $02
.const ZP_PLAYER_X = $fb
.const ZP_POINTER_LO = $fc
.const ZP_POINTER_HI = $fd

// Numeric constants
.const ColorBlack = $00
.const ColorWhite = $01
.const ColorRed = $02
.const MaxLives = 3
.const PlayerSpeed = 2
.const SpriteCount = 8
```

---

## Variables

| Category | Convention | Example |
|----------|------------|---------|
| Variables (RAM) | `camelCase` | `playerScore`, `currentLevel`, `enemyCount` |

### Examples

```asm
.label playerScore = $c000
.label currentLevel = $c002
.label gameState = $c003
```

---

## Labels

| Category | Convention | Example |
|----------|------------|---------|
| Subroutines | `PascalCase` (verb + noun) | `InitGame`, `DrawSprite`, `ClearScreen` |
| Position labels | `camelCase` | `mainLoop`, `skip`, `done`, `noCollision` |
| Local labels | `!name:` (KickAssembler syntax) | `!loop:`, `!skip:`, `!done:` |

### Examples

```asm
// Subroutine
InitPlayer:
    lda #$00
    sta playerScore
    rts

// Subroutine with position labels
UpdateGame:
mainLoop:
    jsr ReadInput
    jsr UpdatePlayer
    jsr CheckCollision
    beq noCollision
    jsr HandleCollision
noCollision:
    jsr DrawScreen
    jmp mainLoop

// Local labels for small loops
ClearScreen:
    lda #$20
    ldx #$00
!loop:
    sta SCREEN_RAM,x
    sta SCREEN_RAM + $100,x
    sta SCREEN_RAM + $200,x
    sta SCREEN_RAM + $300,x
    inx
    bne !loop-
    rts
```

---

## Namespaces

| Category | Convention | Example |
|----------|------------|---------|
| Namespace | `PascalCase` | `Player`, `Sprites`, `Sound`, `Tiles` |

### Examples

```asm
.namespace Player {
    .const SPRITE_POINTER = SCREEN_RAM + $3f8

    .label xPos = ZP_PLAYER_X
    .label yPos = ZP_PLAYER_Y

    Init:
        lda #$00
        sta xPos
        sta yPos
        rts

    Update:
        jsr ReadJoystick
        jsr Move
        jsr Animate
        rts

    Move:
    !skip:
        // ...
        rts
}

// Usage
jsr Player.Init
jsr Player.Update
```

---

## Macros, Functions, and Pseudo-commands

| Category | Convention | Example |
|----------|------------|---------|
| Macros | `PascalCase` | `SetBorderColor`, `WaitFrame` |
| Functions | `camelCase` | `toScreenCode`, `calculateOffset` |
| Pseudo-commands | `camelCase` | `mov`, `push`, `pop` |

### Examples

```asm
// Macro
.macro SetBorderColor(color) {
    lda #color
    sta VIC_BORDER
}

// Function (returns a value at compile time)
.function toScreenCode(char) {
    .return char ^ $40
}

// Pseudo-command (looks like an instruction)
.pseudocommand mov src : dest {
    lda src
    sta dest
}
```

---

## Data and Tables

| Category | Convention | Example |
|----------|------------|---------|
| Data blocks | `camelCase` + descriptive suffix | `spriteData`, `colorTable`, `sinLookup` |

### Examples

```asm
spriteData:
    .import binary "player.bin"

colorTable:
    .byte ColorBlack, ColorWhite, ColorRed, ColorCyan

sinLookup:
    .fill 256, 128 + 127 * sin(i * PI * 2 / 256)

levelMap:
    .import binary "level1.bin"
```

---

## Quick Reference

```
CHIP_NAME         Hardware registers      VIC_BORDER, SID_VOLUME
SCREAMING_SNAKE   Memory addresses        SCREEN_RAM, SPRITE_DATA
ZP_NAME           Zero page addresses     ZP_TEMP, ZP_PLAYER_X
PascalCase        Numeric constants       ColorWhite, MaxSprites
camelCase         Variables               playerScore, currentLevel
PascalCase        Subroutines             InitGame, DrawSprite
camelCase         Position labels         mainLoop, skip, done
!name:            Local labels            !loop:, !skip:
PascalCase        Namespaces              Player, Sound, Tiles
PascalCase        Macros                  SetBorderColor, WaitFrame
camelCase         Functions               toScreenCode
camelCase         Pseudo-commands         mov, push
camelCase         Data/tables             spriteData, sinLookup
```
