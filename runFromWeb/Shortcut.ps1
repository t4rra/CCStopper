$fileLocation = "$env:TEMP\CCStopperDownloader.ps1"

Invoke-RestMethod "https://raw.githubusercontent.com/eaaasun/CCStopper/dev/runFromWeb/Downloader.ps1" | Out-File $fileLocation -Force

Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$fileLocation`" -shortcut" -Verb runas -Wait
Remove-Item -Path $fileLocation -Force
