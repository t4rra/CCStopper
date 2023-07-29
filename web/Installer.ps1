$fileLocation = "$env:TEMP\CCStopperDownloader.ps1"

Invoke-RestMethod "https://raw.githubusercontent.com/eaaasun/CCStopper/main/web/Downloader.ps1" -UseBasicParsing | Out-File $fileLocation -Force

Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$fileLocation`" -install" -Verb runas -Wait
Remove-Item -Path $fileLocation -Force
