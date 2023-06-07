$ErrorActionPreference = "Stop"
# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$CCStopperAIOURL = "https://raw.githubusercontent.com/eaaasun/CCStopper/dev/CCStopper-AIO.ps1"
$CCStopperLaunchURL = "https://raw.githubusercontent.com/eaaasun/CCStopper/dev/CCStopper.bat"


# Create CCStopper program folder
New-Item -Path "$env:ProgramFiles\CCStopper" -ItemType Directory -Force | Out-Null

# Download CCStopper into it
Invoke-WebRequest -Uri $CCStopperAIOURL -OutFile "$env:ProgramFiles\CCStopper\CCStopper_AIO.ps1" -UseBasicParsing
Invoke-WebRequest -Uri $CCStopperLaunchURL -OutFile "$env:ProgramFiles\CCStopper\CCStopper.bat" -UseBasicParsing


Write-Host "CCStopper downloaded to $env:ProgramFiles\CCStopper"
Write-Host ""
do {
    Write-Host "Do you want to create a desktop shortcut? (Y/N)"
    $CreateShortcut = Read-Host
    if ($CreateShortcut -eq "Y" -or $CreateShortcut -eq "y") {
        $WshShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\CCStopper.lnk")
        $Shortcut.TargetPath = "$env:ProgramFiles\CCStopper\CCStopper.bat"
        $Shortcut.Save()
        Write-Host "Desktop shortcut created!"
    } elseif ($CreateShortcut -eq "N" -or $CreateShortcut -eq "n") {
        Write-Host "No desktop shortcut created."
    } else {
        Write-Host "Invalid input. Try again."
        $validInput = $false
    }
} while (-not $validInput)

Write-Host ""
Write-Host "CCStopper has been installed!"
