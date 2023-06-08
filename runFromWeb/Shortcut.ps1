$ErrorActionPreference = "Stop"
$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
if (-not $isAdmin) {
	Write-Warning "Please run this command as administrator"
	pause
	Exit 1
}

# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$CCStopperLogoURL = "https://raw.githubusercontent.com/eaaasun/CCStopper/dev/runFromWeb/logo.ico"

# Create CCStopper program folder if it doesn't already exist
if (!(Test-Path "$env:ProgramFiles\CCStopper")) {
	New-Item -Path "$env:ProgramFiles\CCStopper" -ItemType Directory -Force | Out-Null
}

# Download CCStopper logo into it
Invoke-WebRequest -Uri $CCStopperLogoURL -OutFile "$env:ProgramFiles\CCStopper\icon.ico" -UseBasicParsing

Write-Host "CCStopper icon downloaded to $env:ProgramFiles\CCStopper"
Write-Host ""

# make desktop shortcut
$ShortcutPath = "$env:USERPROFILE\Desktop\CCStopper (Online).lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = '-command "irm https://ccstopper.netlify.app/run | iex"'
$Shortcut.IconLocation = "$env:ProgramFiles\CCStopper\icon.ico"

$Shortcut.Save()

# thanks https://www.reddit.com/r/PowerShell/comments/7xa4sk/programmatically_create_shortcuts_w_run_as_admin/
$bytes = [System.IO.File]::ReadAllBytes("$ShortcutPath")
$bytes[0x15] = $bytes[0x15] -bor 0x20
[System.IO.File]::WriteAllBytes("$ShortcutPath", $bytes)


Write-Host "Desktop shortcut created!"

Pause