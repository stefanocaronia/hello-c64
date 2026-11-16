# Development Environment

- VS Code
- Java JDK
- KickAssembler
- VICE Emulator
- SID Factory II
- VS Code extension KickAss
- C64 65XE NES Debugger: https://sourceforge.net/projects/c64-debugger/
- Shared VS Code tasks are in `.vscode/tasks.json` (build output in root `bin/`).
- If KickAss extension keybindings are used instead of workspace tasks, they may bypass workspace task settings; prefer task-based build/run/debug.

SpritePad/Charpad: https://www.subchristsoftware.com/

## Setup on a new machine

1. Java JDK (needed by KickAssembler): `winget install --id EclipseAdoptium.Temurin.21.JDK -e`, then open a new terminal and check with `java -version`.
2. VS Code extension KickAss (C64) (syntax highlighting): `code --install-extension CaptainJiNX.kickass-c64`.
3. KickAssembler, VICE, C64 Debugger, CharPad/SpritePad and SID Factory II have no installer: download them from the links in `documentation.md` and above, and unzip them in a folder of your choice.
4. Set the paths of `KickAss.jar`, `x64sc.exe` and `C64Debugger.exe` in `.vscode/tasks.json`.
5. Check the toolchain by assembling an exercise (next section) and running the `Run with VICE` task.

## Building from the command line

Tool paths are specific to the machine and are defined in `.vscode/tasks.json`. To assemble an exercise without VS Code, run from the repository root the same command as the `Build with Kick Assembler` task:

```powershell
java -jar "<path of KickAss.jar from .vscode/tasks.json>" <n>_<exerciseName>.asm -o bin/<n>_<exerciseName>.prg
```

KickAssembler prints the errors with file and line number. Use this to check the student's code before giving feedback.

If `java` is not found, the JDK is missing or not in `PATH`: tell the student, and review the code by reading it until the JDK is installed.
