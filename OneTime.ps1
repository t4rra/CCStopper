$ErrorActionPreference = "Stop"

$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
if (-not $isAdmin) {
	Write-Warning "Please run this command as administrator"
	pause
	Exit 1
}


# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12




$CCStopperAIOURL = "https://raw.githubusercontent.com/eaaasun/CCStopper/dev/CCStopper_AIO.ps1"

# download CCStopper into temp folders
$TempFolder = "$env:TEMP\CCStopper"
New-Item -Path $TempFolder -ItemType Directory -Force | Out-Null
Invoke-WebRequest -Uri $CCStopperAIOURL -OutFile "$TempFolder\CCStopper_AIO.ps1" -UseBasicParsing

# run CCStopper
Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$TempFolder\CCStopper_AIO.ps1`"" -Wait

# delete temp folder
Remove-Item -Path $TempFolder -Recurse -Force

