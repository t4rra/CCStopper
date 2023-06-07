$ErrorActionPreference = "Stop"
# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
		Start-Process -FilePath $((Get-Process -Id $PID).Path) -Verb Runas -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" `"$args $($PSBoundParameters.Values)`""
	}
}
Set-Location $PSScriptRoot
Clear-Host

$CCStopperAIOURL = "https://raw.githubusercontent.com/eaaasun/CCStopper/dev/CCStopper_AIO.ps1"
$CCStopperLogoURL = "https://raw.githubusercontent.com/eaaasun/CCStopper/dev/CCStopper%20logo.ico"

# check if CCStopper folder exists and files are inside, if so, ask if user wants to reinstall or uninstall
if (Test-Path "$env:ProgramFiles\CCStopper\CCStopper_AIO.ps1") {
	Write-Host "CCStopper is already installed!"
	Write-Host ""
	do {
		Write-Host "Do you want to reinstall or uninstall CCStopper? (R/U)"
		$Reinstall = Read-Host
		if ($Reinstall -eq "R" -or $Reinstall -eq "r") {
			Remove-Item -Path "$env:ProgramFiles\CCStopper" -Recurse -Force
			break
		}
		elseif ($Reinstall -eq "U" -or $Reinstall -eq "u") {
			Remove-Item -Path "$env:ProgramFiles\CCStopper" -Recurse -Force
			Write-Host "CCStopper uninstalled!"
			Pause
			exit
		}
		else {
			Write-Host "Invalid input, please try again."
		}
	} until ($validInput -eq $true)
}



# Create CCStopper program folder
New-Item -Path "$env:ProgramFiles\CCStopper" -ItemType Directory -Force | Out-Null

# Download CCStopper into it
Invoke-WebRequest -Uri $CCStopperAIOURL -OutFile "$env:ProgramFiles\CCStopper\CCStopper_AIO.ps1" -UseBasicParsing
Invoke-WebRequest -Uri $CCStopperLogoURL -OutFile "$env:ProgramFiles\CCStopper\CCStopper_icon.ico" -UseBasicParsing


Write-Host "CCStopper downloaded to $env:ProgramFiles\CCStopper"
Write-Host ""

# make desktop shortcut that targets ```powershell.exe -command "& '$env:ProgramFiles\CCStopper\CCStopper_AIO.ps1'"```
$ShortcutPath = "$env:USERPROFILE\Desktop\CCStopper.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-command ""& '$env:ProgramFiles\CCStopper\CCStopper_AIO.ps1'"""
$Shortcut.IconLocation = "$env:ProgramFiles\CCStopper\CCStopper_icon.ico"
$Shortcut.Save()

Write-Host "Desktop shortcut created!"

Write-Host ""
Write-Host "CCStopper has been installed!"
Pause