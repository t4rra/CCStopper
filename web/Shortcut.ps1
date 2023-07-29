$fileLocation = "$env:TEMP\CCStopperDownloader.ps1"

if (Test-Path -Path "$env:USERPROFILE\Desktop\CCStopper (Online).lnk") {
	Write-Host "Shortcut already exists!"
	Pause
	exit
}
else {
	Invoke-RestMethod "https://raw.githubusercontent.com/eaaasun/CCStopper/main/web/Downloader.ps1" -UseBasicParsing | Out-File $fileLocation -Force

	Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$fileLocation`" -shortcut" -Verb runas -Wait
	Remove-Item -Path $fileLocation -Force
	
}