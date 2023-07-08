$fileLocation = "$env:TEMP\CCStopper\Downloader.ps1"

irm "https://[url]" | Out-File $fileLocation -Force

Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$fileLocation`" -shortcut" -Wait
Remove-Item -Path $fileLocation -Force
Remove-Item -Path $MyInvocation.MyCommand.Path -Force
