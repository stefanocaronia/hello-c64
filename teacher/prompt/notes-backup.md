# Notes Backup

After updating Markdown notes, run these commands using `notes_backup_path` from `config.yaml`.

## Backup study notes (`study/*.md`)

```powershell
robocopy "study" "<notes_backup_path from config.yaml>" *.md /MIR /FFT /Z /R:2 /W:2
```

## Backup course files (`teacher/course/*.md`)

```powershell
robocopy "teacher\\course" "<notes_backup_path from config.yaml>\\course" *.md /MIR /FFT /Z /R:2 /W:2
```
