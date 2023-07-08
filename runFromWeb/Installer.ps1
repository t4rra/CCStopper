$fileLocation = "$env:TEMP\CCStopper\Downloader.ps1"
mkdir "$env:TEMP\CCStopper"

irm "https://https://raw.githubusercontent.com/eaaasun/CCStopper/dev/runFromWeb/Downloader.ps1" | Out-File $fileLocation -Force

Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$fileLocation`" -install" -Verb runas -Wait
Remove-Item -Path $fileLocation -Force
Remove-Item -Path $MyInvocation.MyCommand.Path -Force
