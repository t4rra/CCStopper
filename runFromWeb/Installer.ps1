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
$CCStopperLogoURL = "https://raw.githubusercontent.com/eaaasun/CCStopper/dev/runFromWeb/logo.ico"

function uninstall {
	Remove-Item -Path "$env:ProgramFiles\CCStopper" -Recurse -Force
	# delete desktop icon
	$ShortcutPath = "$env:USERPROFILE\Desktop\CCStopper.lnk"
	if (Test-Path $ShortcutPath) {
		Remove-Item $ShortcutPath
	}
}

# check if CCStopper folder exists and files are inside, if so, ask if user wants to reinstall or uninstall
if (Test-Path "$env:ProgramFiles\CCStopper\CCStopper_AIO.ps1") {
	Write-Host "CCStopper is already installed!"
	Write-Host ""
	do {
		Write-Host "Do you want to reinstall or uninstall CCStopper? (R/U)"
		$Reinstall = Read-Host
		if ($Reinstall -eq "R" -or $Reinstall -eq "r") {
			uninstall
			break
		}
		elseif ($Reinstall -eq "U" -or $Reinstall -eq "u") {
			uninstall
			Pause
			exit
		}
		else {
			Write-Host "Invalid input, please try again."
		}
	} until ($validInput -eq $true)
}



# Create CCStopper program folder if it doesn't exist
if (!(Test-Path "$env:ProgramFiles\CCStopper")) {
	New-Item -Path "$env:ProgramFiles\CCStopper" -ItemType Directory -Force | Out-Null
}

# Download CCStopper into it
Invoke-WebRequest -Uri $CCStopperAIOURL -OutFile "$env:ProgramFiles\CCStopper\CCStopper_AIO.ps1" -UseBasicParsing
Invoke-WebRequest -Uri $CCStopperLogoURL -OutFile "$env:ProgramFiles\CCStopper\icon.ico" -UseBasicParsing


Write-Host "CCStopper downloaded to $env:ProgramFiles\CCStopper"
Write-Host ""

# make desktop shortcut that targets ```powershell.exe -command "& '$env:ProgramFiles\CCStopper\CCStopper_AIO.ps1'"```
$ShortcutPath = "$env:USERPROFILE\Desktop\CCStopper.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-command ""& '$env:ProgramFiles\CCStopper\CCStopper_AIO.ps1'"""
$Shortcut.IconLocation = "$env:ProgramFiles\CCStopper\icon.ico"

$Shortcut.Save()

# thanks https://www.reddit.com/r/PowerShell/comments/7xa4sk/programmatically_create_shortcuts_w_run_as_admin/
$bytes = [System.IO.File]::ReadAllBytes("$ShortcutPath")
$bytes[0x15] = $bytes[0x15] -bor 0x20
[System.IO.File]::WriteAllBytes("$ShortcutPath", $bytes)


Write-Host "Desktop shortcut created!"

Write-Host ""
Write-Host "CCStopper has been installed!"
Pause