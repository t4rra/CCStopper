$ErrorActionPreference = "Stop"
# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
		Start-Process -FilePath $((Get-Process -Id $PID).Path) -Verb Runas -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" `"$args $($PSBoundParameters.Values)`""
		Exit
	}
}
Set-Location $PSScriptRoot
Clear-Host

$CCStopperAIOURL = "https://raw.githubusercontent.com/eaaasun/CCStopper/dev/CCStopper_AIO.ps1"

# download CCStopper into temp folders
$TempFolder = "$env:TEMP\CCStopper"
New-Item -Path $TempFolder -ItemType Directory -Force | Out-Null
Invoke-WebRequest -Uri $CCStopperAIOURL -OutFile "$TempFolder\CCStopper_AIO.ps1" -UseBasicParsing

# run CCStopper
Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$TempFolder\CCStopper_AIO.ps1`"" -Wait

# delete temp folder
Remove-Item -Path $TempFolder -Recurse -Force

