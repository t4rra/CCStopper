$ErrorActionPreference = "Stop"

# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$CCStopperAIOURL = "https://raw.githubusercontent.com/eaaasun/CCStopper/dev/CCStopper_AIO.ps1"

# download CCStopper into temp folders
$TempFolder = "$env:TEMP\CCStopper"
New-Item -Path $TempFolder -ItemType Directory -Force | Out-Null
Invoke-WebRequest -Uri $CCStopperAIOURL -OutFile "$TempFolder\CCStopper_AIO.ps1" -UseBasicParsing

# run CCStopper
Write-Host "Starting CCStopper..."
Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$TempFolder\CCStopper_AIO.ps1`"" -Wait

Write-Host "Cleaning up..."
# delete temp folder
Remove-Item -Path $TempFolder -Recurse -Force
Write-Host "Cleaned up! Goodbye!"
