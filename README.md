# HelloC64

Repository didattico per imparare Assembly 6510 su Commodore 64 con KickAssembler, VS Code e VICE.

## Obiettivo del progetto

Il progetto raccoglie esercizi progressivi (`<n>_<nome>.asm`) e materiale di studio per passare dalle basi (screen, loop, input) a temi intermedi (IRQ raster, sprite, SID, VIC bank).

## Corso e monitoraggio progressi

- Piano del corso: `study/course-plan.md`
- Checklist competenze (score 0-10): `study/checklist.md`
- Regole operative del corso/agente: `agents.md`

## Appunti di studio

Riferimento rapido:

- `study/basics.md`

Approfondimenti principali:

- `study/raster-irq.md`
- `study/sprite.md`
- `study/sid.md`
- `study/vic-bank.md`
- `study/charset.md`
- `study/joystick.md`

## Struttura repository

- `*.asm`: esercizi pratici numerati
- `lib/`: macro e librerie riusabili (screen, timing, math)
- `study/`: piano corso, checklist e appunti Markdown
- `Doc/`: manuali e riferimenti C64/KickAssembler
- `sprites/`, `charsets/`, `music/`: asset per esercizi

## Workflow consigliato

1. Scegli l'esercizio successivo dal piano (`study/course-plan.md`).
2. Svolgi un solo step didattico alla volta (1-2 concetti nuovi).
3. Aggiorna `study/checklist.md` e `study/course-plan.md`.
4. Esegui la replica note: `robocopy "study" "\\monolith\Dati\Stefano\Documenti\Studio\C64\Notes" *.md /MIR /FFT /Z /R:2 /W:2`
5. Commit dello step.
