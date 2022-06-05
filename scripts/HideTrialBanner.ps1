$MyWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$MyWindowsPrincipal=New-Object System.Security.Principal.WindowsPrincipal($MyWindowsID)
$AdminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator

if($MyWindowsPrincipal.IsInRole($AdminRole)) {
$Host.UI.RawUI.WindowTitle = $MyInvocation.MyCommand.Definition + "(Elevated)"
   Clear-Host
} else {
   $NewProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell";
   $NewProcess.Arguments = $MyInvocation.MyCommand.Definition;
   $NewProcess.Verb = "runas";
   [System.Diagnostics.Process]::Start($newProcess);
   exit
}

$PsAppLocation = (Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\PHSP_23_3").InstallLocation
$AiAppLocation = (Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\ILST_26_2_1").InstallLocation
$Button = $Shell.Popup($AppLocation, 0, "Trial Banner Hider", 0)


$StylePath = 'C:\Program Files\Common Files\Adobe\UXP\extensions\com.adobe.ccx.start-5.9.0\css\styles.css'
$StylePath1 = "$($PsAppLocation)\Required\UXP\com.adobe.ccx.start\css\styles.css"
$StylePath2 = "$($AiAppLocation)\Support Files\Required\UXP\extensions\com.adobe.ccx.start\css\styles.css"
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
Remove-Item '$LocalePath' -Force -Recurse

$Shell = New-Object -ComObject "WScript.Shell"
$Button = $Shell.Popup("Trial banner has been hidden!", 0, "Trial Banner Hider", 0)