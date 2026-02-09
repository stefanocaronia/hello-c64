# HelloC64

Learning repository for Commodore 64 Assembly (6510) using KickAssembler, VS Code, and VICE.

## Project Goal

This project contains progressive exercises in `exercises/` (`<n>_<name>.asm`) and study material to move from fundamentals (screen, loops, input) to intermediate topics (raster IRQ, sprites, SID, VIC bank).

## Course Tracking

- Course plan: [study/course-plan.md](study/course-plan.md)
- Course progress (0-10): [study/course-progress.md](study/course-progress.md)
- Agent/course operating rules: [agents.md](agents.md)

## Study Notes

Quick reference:

- [study/basics.md](study/basics.md)

Main topic notes:

- [study/raster-irq.md](study/raster-irq.md)
- [study/sprite.md](study/sprite.md)
- [study/sid.md](study/sid.md)
- [study/vic-bank.md](study/vic-bank.md)
- [study/charset.md](study/charset.md)
- [study/joystick.md](study/joystick.md)

## Main Documentation (`doc`)

- Primary memory map: [doc/Commodore 64 memory map.md](doc/Commodore%2064%20memory%20map.md)
- Memory overview: [doc/C64 memory overview.md](doc/C64%20memory%20overview.md)
- PAL frequencies (A=440Hz): [doc/c64-sound-frequencies-440hz-PAL.md](doc/c64-sound-frequencies-440hz-PAL.md)
- SID Factory II manual: [doc/SID Factory II/user_manual.md](doc/SID%20Factory%20II/user_manual.md)
- SID Factory II notes: [doc/SID Factory II/notes.md](doc/SID%20Factory%20II/notes.md)
- SID Factory II FAQ: [doc/SID Factory II/faq.md](doc/SID%20Factory%20II/faq.md)
- SID Factory II converter notes: [doc/SID Factory II/converter.md](doc/SID%20Factory%20II/converter.md)

## Local Configuration

Create your own `config.yaml` from `config-template.yaml`:

```powershell
Copy-Item config-template.yaml config.yaml
```

Then edit `config.yaml` with your local values:

```yaml
language: "it"
notes_backup_path: "\\\\server\\share\\path\\to\\notes"
```

Notes:

- `config.yaml` is ignored by git (local machine only).
- `config-template.yaml` is tracked and serves as the shared template.
- `language` is the language used for the course interactions.
- `notes_backup_path` is used as target path for the notes mirror copy.

## Repository Structure

- `exercises/`: numbered practical exercises (`<n>_<name>.asm`)
- `lib/`: reusable macros and helper libraries (screen, timing, math)
- `study/`: course plan, course progress, and notes
- `doc/`: manuals and C64/KickAssembler references
- `sprites/`, `charsets/`, `music/`: assets used by exercises

## Suggested Workflow

1. Pick the next exercise from the plan ([study/course-plan.md](study/course-plan.md)).
2. Work in one small learning step at a time (1-2 new concepts).
3. Update [study/course-progress.md](study/course-progress.md) and [study/course-plan.md](study/course-plan.md).
4. Mirror notes using your `config.yaml` path:
   `robocopy "study" "<notes_backup_path from config.yaml>" *.md /MIR /FFT /Z /R:2 /W:2`
5. Commit the learning step.
