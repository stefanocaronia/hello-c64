# Documentation

## Documentation in `doc` folder

- `doc/Commodore 64 Programmer's Reference Guide.pdf`
- `doc/Commodore 64 User's Guide.pdf`
- `doc/KickAssembler.pdf`
- `doc/Commodore 64 memory map.md` - PRIMARY reference for C64 memory. Always consult this file for addresses, VIC-II registers, SID, CIA, Zero Page, etc.
- `doc/c64-sound-frequencies-440hz-PAL.md`
- `doc/SID Factory II/user_manual.pdf`
- `doc/SID Factory II/user_manual.md`
- `doc/SID Factory II/notes.md`
- `doc/SID Factory II/faq.md`
- `doc/SID Factory II/converter.md`

## Web Documentation

C64 memmap: http://sta.c64.org/cbm64mem.html
C64 opcodes: http://www.oxyron.de/html/opcodes02.html

### KickAssembler (official, manuals, examples)
- KickAssembler - official site: https://theweb.dk/KickAssembler/Main.html
- KickAssembler - PDF manual: https://theweb.dk/KickAssembler/KickAssembler.pdf
- KickAssembler - web help/introduction: https://www.theweb.dk/KickAssembler/webhelp/content/cpt_Introduction.html
- C64-Wiki - KickAssembler page (overview + links): https://www.c64-wiki.com/wiki/KickAssembler
- KickAssembler examples (repo): https://github.com/nealvis/c64_samples_kick

### Toolchain & Cross-Development (workflow, editor, build)
- Codebase64 - Cross Development (general setup): https://codebase64.net/doku.php?id=base:crossdev
- KickAssembler + VS Code (article): https://hackaday.com/2024/06/06/using-kick-assembler-and-vs-code-to-write-c64-assembler/

### Memory Map & General Reference (RAM/ROM/I/O, addresses)
- Ultimate C64 Reference - Memory Map: https://www.pagetable.com/c64ref/c64mem/
- sta.c64.org - C64 memory map: https://sta.c64.org/cbm64mem.html
- zimmers.net - C64.MemoryMap.txt (plain text): https://www.zimmers.net/anonftp/pub/cbm/maps/C64.MemoryMap.txt
- C64-Wiki - Memory Map: https://www.c64-wiki.com/wiki/Memory_Map

### KERNAL / BASIC ROM (API and routines)
- Ultimate C64 Reference - KERNAL API: https://www.pagetable.com/c64ref/kernal/
- C64-Wiki - KERNAL: https://www.c64-wiki.com/wiki/Kernal
- C64-Wiki - CHROUT ($FFD2): https://www.c64-wiki.com/wiki/CHROUT

### VIC-II (graphics, raster, sprites, timing)
- C64-Wiki - VIC-II: https://www.c64-wiki.com/wiki/VIC
- Dustlayer - VIC-II for Beginners (series): https://dustlayer.com/vic-ii/2013/4/22/when-visibility-matters
- VIC quirks deep dive (DMA/badlines, etc.): https://pscarlett.me.uk/post/c64/vic/vic.html

### SID (audio, registers, concepts)
- C64-Wiki - SID: https://www.c64-wiki.com/wiki/SID

### SID Factory II (resources and documentation)
- Download/News (Chordian): http://blog.chordian.net/sf2/
- Community Facebook group: https://www.facebook.com/groups/255114778886664/
- Local manual (PDF): `doc/SID Factory II/user_manual.pdf`
- Local manual (Markdown): `doc/SID Factory II/user_manual.md`
- Local driver notes: `doc/SID Factory II/notes_driver11.md` ... `doc/SID Factory II/notes_driver16.md`
- Local FAQ: `doc/SID Factory II/faq.md`

### 6510/6502 (ISA, cycles, illegal opcodes)
- Masswerk - 6502 instruction set + undocumented: https://www.masswerk.at/6502/6502_instruction_set.html
- NMOS 6510 Unintended Opcodes (PDF): https://hitmen.c02.at/files/docs/c64/NoMoreSecrets-NMOS6510UnintendedOpcodes-20162412.pdf
- Codebase64 - 6502/6510 coding (notes + tricks): https://codebase64.net/doku.php?id=base:6502_6510_coding

### Debug & Monitor (VICE)
- VICE manual - Monitor: https://vice-emu.sourceforge.io/vice_12.html
- VICE manual - Monitor commands (next section): https://vice-emu.sourceforge.io/vice_13.html
- VICE manual - full index: https://vice-emu.sourceforge.io/vice_toc.html
- VICE - Binary remote monitor (automation): https://vice-emu.sourceforge.io/vice_7.html#SEC166

### KickAssembler libraries / reusable codebases
- c64lib (org): https://github.com/c64lib
- c64lib (docs): https://c64lib.github.io/
- Magic Desk CRT (example repo): https://github.com/c64lib/magic-desk-crt
- barryw/c64lib (another collection): https://github.com/barryw/c64lib

### Tutorials / guided paths
- 64bites - From Basic to Assembly (KickAssembler-centric): https://64bites.com/seasons/001-from-basic-to-assembly/

### (Optional) Existing base link
- Pickledlight - Commodore 64 Guides: https://pickledlight.blogspot.com/p/commodore-64-guides.html
