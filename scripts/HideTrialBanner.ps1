$MyWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$MyWindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($MyWindowsID)
$AdminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

if($MyWindowsPrincipal.IsInRole($AdminRole)) {
$Host.UI.RawUI.WindowTitle = $MyInvocation.MyCommand.Definition + "(Elevated)"
   Clear-Host
} else {
   $NewProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell"
   $NewProcess.Arguments = $MyInvocation.MyCommand.Definition
   $NewProcess.Verb = "runas"
   [System.Diagnostics.Process]::Start($newProcess)
   exit
}

function Get-UninstallKey ([String]$ID) {
	return (Get-ChildItem HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall -Recurse | Where-Object {$_.PSChildName -Like "$ID*"}).Name
}

$AppLocation = (Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\CORE_1_0_32").InstallLocation
$PSAppLocation = (Get-ItemProperty -Path Registry::$(Get-UninstallKey -ID "PHSP") -Name InstallLocation)
$AIAppLocation = (Get-ItemProperty -Path Registry::$(Get-UninstallKey -ID "ILST") -Name InstallLocation)
# $Button = $Shell.Popup($AppLocation, 0, "Trial Banner Hider", 0)

$CommonExtensions = 'C:\Program Files\Common Files\Adobe\UXP\extensions'
$StylePath = "$CommonExtensions\$((Get-ChildItem $CommonExtensions -Recurse | Where-Object {$_.PSChildName -Like 'com.adobe.ccx.start-*' } | Select -Last 1).Name)\css\styles.css"
$StylePath1 = "$($PSAppLocation)\Required\UXP\com.adobe.ccx.start\css\styles.css"
$StylePath2 = "$($AIAppLocation)\Support Files\Required\UXP\extensions\com.adobe.ccx.start\css\styles.css"
$LocalePath = 'C:\Program Files (x86)\Common Files\Adobe\AdobeGCClient\locales'

$Style_None = '{"display":"none"}'
$Style_TrialExpiresBanner = '{"background-color":"#1473E6"}'
$Style_TrialEnded = '{"background-color":"#d7373f"}'

# Back up file
(Get-Content $StylePath) | Out-File -encoding ASCII '$StylePath.bak'

# Replace contents

(Get-Content $StylePath -Raw) -replace $Style_TrialExpiresBanner, $Style_None | Set-Content $StylePath
(Get-Content $StylePath1 -Raw) -replace $Style_TrialExpiresBanner, $Style_None | Set-Content $StylePath1
(Get-Content $StylePath2 -Raw) -replace $Style_TrialExpiresBanner, $Style_None | Set-Content $StylePath2
(Get-Content $StylePath -Raw) -replace $Style_TrialEnded, $Style_None | Set-Content $StylePath
(Get-Content $StylePath1 -Raw) -replace $Style_TrialEnded, $Style_None | Set-Content $StylePath1
(Get-Content $StylePath2 -Raw) -replace $Style_TrialEnded, $Style_None | Set-Content $StylePath2

# Delete Language Packs
$ErrorActionPreference= 'silentlycontinue'
Remove-Item "$LocalePath" -Force -Recurse

$Shell = New-Object -ComObject "WScript.Shell"
$Shell.Popup("Trial banner has been hidden!", 0, "Trial Banner Hider", 0)
# $Button = $Shell.Popup("Trial banner has been hidden!", 0, "Trial Banner Hider", 0)
