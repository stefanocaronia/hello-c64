# HelloC64

Learning repository for Commodore 64 Assembly (6510) using KickAssembler, VS Code, and VICE.

## Project Goal

This project contains progressive exercises in `exercises/` (`<n>_<name>.asm`) and study material to move from fundamentals (screen, loops, input) to intermediate topics (raster IRQ, sprites, SID, VIC bank).

## Course Tracking

- Course plan: [teacher/course/course-plan.md](teacher/course/course-plan.md)
- Course progress (0-10): [teacher/course/course-progress.md](teacher/course/course-progress.md)
- Agent entry point: [agents.md](agents.md)
- Full teacher instructions: [teacher/instructions/instructions.md](teacher/instructions/instructions.md)

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

## Local Configuration

Create your own `config.yaml` from `config-template.yaml`:

```powershell
Copy-Item config-template.yaml config.yaml
```

Then edit `config.yaml` with your local values:

```yaml
argument: "Learn C64 Assembly"
language: "it"
notes_backup_path: "\\\\server\\share\\path\\to\\notes"
```

Notes:

- `config.yaml` is ignored by git (local machine only).
- `config-template.yaml` is tracked and serves as the shared template.
- `argument` is the high-level course objective/prompt seed for your LLM workflow.
- `language` is the language used for the course interactions.
- `notes_backup_path` is used as target path for the notes mirror copy.

## New Student Workspace Setup

Use these steps when you want to start the course from a clean student workspace.

1. Open this repository folder with your preferred LLM CLI.
2. Choose your starting mode:
   - `Keep reference exercises (recommended)`: keep `exercises/` as examples/reference.
   - `Clean start`: remove `exercises/` to start from zero.
3. Remove agent memory history:
   - delete `teacher/memory/` contents (or the whole folder).
4. Ask the agent to reset study files:
   - clear `teacher/course/course-progress.md`;
   - regenerate `teacher/course/course-plan.md` as a fresh course blueprint for the new student.
5. Continue with normal course workflow.

## Repository Structure

- `exercises/`: numbered practical exercises (`<n>_<name>.asm`)
- `lib/`: reusable macros and helper libraries (screen, timing, math)
- `study/`: topic notes (`basics`, `sprite`, `sid`, etc.)
- `teacher/course/`: course plan and course progress
- `teacher/memory/`: agent memory files
- `teacher/prompt/`: operational prompts (including notes backup)
- `doc/`: manuals and C64/KickAssembler references
- `assets/`: exercise assets
- `assets/sprites/`, `assets/charsets/`, `assets/music/`: sprite, charset, and music assets

## Suggested Workflow

1. Pick the next exercise from the plan ([teacher/course/course-plan.md](teacher/course/course-plan.md)).
2. Work in one small learning step at a time (1-2 new concepts).
3. Update [teacher/course/course-progress.md](teacher/course/course-progress.md) and [teacher/course/course-plan.md](teacher/course/course-plan.md).
4. Run notes backup using [teacher/prompt/notes-backup.md](teacher/prompt/notes-backup.md).
5. Commit the learning step.
