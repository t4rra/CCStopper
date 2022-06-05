$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator

if($myWindowsPrincipal.IsInRole($adminRole)) {
$Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
   Clear-Host
} else {
   $NewProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell";
   $NewProcess.Arguments = $myInvocation.MyCommand.Definition;
   $NewProcess.Verb = "runas";
   [System.Diagnostics.Process]::Start($newProcess);

   exit
}

$StylePath = 'C:\Program Files\Common Files\Adobe\UXP\extensions\com.adobe.ccx.start-5.9.0\css\styles.css'
$StylePath1 = 'C:\Program Files\Adobe\Adobe Photoshop 2022\Required\UXP\com.adobe.ccx.start\css\styles.css'
$StylePath2 = 'C:\Program Files\Adobe\Adobe Illustrator 2022\Support Files\Required\UXP\extensions\com.adobe.ccx.start\css\styles.css'
$LocalePath = 'C:\Program Files (x86)\Common Files\Adobe\AdobeGCClient\locales'

$Style_None = '{"display":"none"}'
$Style_TrialExpiresBanner = '{"background-color":"#1473E6"}'
$Style_TrialEnded = '{"background-color":"#d7373f"}'

# Back up file
powershell -Command "(gc '$StylePath') | Out-File -encoding ASCII '$StylePath.bak'"

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