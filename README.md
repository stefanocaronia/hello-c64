# HelloC64

Learning repository for Commodore 64 Assembly (6510) using KickAssembler, VS Code, and VICE.

## Project Goal

This project contains progressive exercises in repository root (`<n>_<name>.asm`) and study material to move from fundamentals (screen, loops, input) to intermediate topics (raster IRQ, sprites, SID, VIC bank).

## Course Tracking

- Course plan: [teacher/course/course-plan.md](teacher/course/course-plan.md)
- Course progress (0-10): [teacher/course/course-progress.md](teacher/course/course-progress.md)
- Current state of the course: [teacher/memory/current.md](teacher/memory/current.md)
- Agent entry point and teaching rules: [AGENTS.md](AGENTS.md)

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
- [study/layout.md](study/layout.md)
- [study/math.md](study/math.md)
- [study/sid-factory-ii.md](study/sid-factory-ii.md)

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

1. Create `config.yaml` (see above) and set `argument` and `language`.
2. Open this repository folder with your preferred LLM CLI.
3. Ask the agent to set up a new student workspace. It follows [teacher/prompt/new-student.md](teacher/prompt/new-student.md): it asks whether to keep the root exercise files as reference, removes the previous student's memory, lessons and quizzes, resets the progress and regenerates the course plan.
4. Continue with normal course workflow.

## Repository Structure

- project root: numbered practical exercises (`<n>_<name>.asm`, variants as `<n><letter>_<name>.asm`)
- `AGENTS.md`: agent entry point with all the teaching rules
- `lib/`: reusable macros and helper libraries (screen, timing, math, colors)
- `quiz/`: review material written during quizzes
- `study/`: topic notes (`basics`, `sprite`, `sid`, etc.)
- `teacher/course/`: course plan and course progress
- `teacher/lessons/`: one lesson file per exercise (goal, new concepts, steps, difficulties)
- `teacher/memory/`: `current.md` (current state) and one log file per session date
- `teacher/instructions/`: documentation index and development environment
- `teacher/prompt/`: operational procedures (notes backup, new student)
- `doc/`: manuals and C64/KickAssembler references
- `assets/sprites/`, `assets/charsets/`, `assets/music/`: sprite, charset, and music assets
- `assets/maps/`, `assets/charpad/`: binaries exported from CharPad and CharPad projects
- `.vscode/`: shared VS Code tasks/workspace automation

## VS Code Build/Run

- `.vscode/tasks.json` is versioned in this repository and defines shared build/run tasks.
- Build output is always generated in root `bin/`.

### Default usage

1. `Ctrl+Shift+B`: runs the default build task (`Run with VICE`), which builds and starts VICE.
2. `Terminal -> Run Task -> Build with Kick Assembler`: build only.
3. `Terminal -> Run Task -> Run with C64 Debugger`: build and run in C64 Debugger.

### Optional F7/F5 mapping

If you want dedicated keys:

1. Open `Preferences -> Keyboard Shortcuts (JSON)`.
2. Add mappings for the task commands, for example:

```json
[
  {
    "key": "f7",
    "command": "workbench.action.tasks.runTask",
    "args": "Build with Kick Assembler"
  },
  {
    "key": "f5",
    "command": "workbench.action.tasks.runTask",
    "args": "Run with VICE"
  },
  {
    "key": "f6",
    "command": "workbench.action.tasks.runTask",
    "args": "Run with C64 Debugger"
  }
]
```

Important:

- The KickAss VS Code extension also defines its own build/run/debug keybindings.
- If those extension keybindings are active, they may bypass workspace task settings.
- To force consistent output in root `bin/`, use the workspace tasks (or remap keys to the tasks as shown above).

## Suggested Workflow

1. Pick the next step from [teacher/memory/current.md](teacher/memory/current.md) and the plan ([teacher/course/course-plan.md](teacher/course/course-plan.md)).
2. Work in one small learning step at a time (1-2 new concepts).
3. Update [teacher/course/course-progress.md](teacher/course/course-progress.md) and [teacher/memory/current.md](teacher/memory/current.md); update the plan only when the course design changes.
4. Run notes backup using [teacher/prompt/notes-backup.md](teacher/prompt/notes-backup.md).
5. Commit the learning step.

## Development notes

Developed with the help of AI coding agents. Everything is designed, reviewed and tested by the project's human maintainer.

**We encourage everyone to use AI for their own purposes.**  
The means of production should belong to the people.  
Fight corporate control of technology, not our right to use it.
