# Notes Backup

After updating Markdown notes, run these commands using `notes_backup_path` from `config.yaml`.

`robocopy` returns a non-zero exit code even when it succeeds: any code below 8 is a success (1 = files copied, 3 = files copied and extra files removed). Treat only 8 or higher as a failure.

## Backup study notes (`study/*.md`)

`/XD course` protects the `course` folder of the destination, which holds the second backup: without it `/MIR` would delete that folder, because it does not exist in `study`.

```powershell
robocopy "study" "<notes_backup_path from config.yaml>" *.md /MIR /XD course /FFT /Z /R:2 /W:2
```

## Backup course files (`teacher/course/*.md`)

```powershell
robocopy "teacher\\course" "<notes_backup_path from config.yaml>\\course" *.md /MIR /FFT /Z /R:2 /W:2
```
