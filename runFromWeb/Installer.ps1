$fileLocation = "$env:TEMP\CCStopperDownloader.ps1"

irm "https://raw.githubusercontent.com/eaaasun/CCStopper/dev/runFromWeb/Downloader.ps1" | Out-File $fileLocation -Force

Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$fileLocation`" -install" -Verb runas -Wait
Remove-Item -Path $fileLocation -Force
Remove-Item -Path $MyInvocation.MyCommand.Path -Force
