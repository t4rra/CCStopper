if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
	Start-Process -FilePath PowerShell -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`" `"$($MyInvocation.MyCommand.UnboundArguments)`""
	Exit
}
Set-Location $PSScriptRoot
Clear-Host

$Host.UI.RawUI.WindowTitle = "CCStopper - Hide Trial Banner"
# Set-ConsoleWindow -Width 73 -Height 42


function Get-Subkey([String]$Key, [String]$SubkeyPattern) {
	return (Get-ChildItem Registry::$Key -Recurse | Where-Object {$_.PSChildName -Like "$SubkeyPattern"}).Name
}

$PSAppLocation = (Get-ItemProperty -Path Registry::$(Get-Subkey -Key "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" -SubkeyPattern "PHSP*")).InstallLocation
$AIAppLocation = (Get-ItemProperty -Path Registry::$(Get-Subkey -Key "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" -SubkeyPattern "ILST*")).InstallLocation
$CommonExtensions = Join-Path -Path ${env:ProgramFiles} -ChildPath "Common Files\Adobe\UXP\extensions"

$StylePath = "$CommonExtensions\$((Get-ChildItem $CommonExtensions -Recurse | Where-Object {$_.PSChildName -Like 'com.adobe.ccx.start-*' } | Select-Object -Last 1).Name)\css\styles.css"
$StylePath1 = "$($PSAppLocation)\Required\UXP\com.adobe.ccx.start\css\styles.css"
$StylePath2 = "$($AIAppLocation)\Support Files\Required\UXP\extensions\com.adobe.ccx.start\css\styles.css"
$LocalePath = Join-Path -Path ${env:ProgramFiles(x86)} -ChildPath "\Common Files\Adobe\AdobeGCClient\locales"

$Style_None = '{"display":"none"}'
$Style_TrialExpiresBanner = '{"background-color":"#1473E6"}'
$Style_TrialEnded = '{"background-color":"#d7373f"}'

# Back up file
(Get-Content $StylePath) | Out-File -encoding ASCII '$StylePath.bak'

# Replace contents

$StylePaths = @($StylePath, $StylePath1, $StylePath2)
$StylePaths | ForEach-Object {
   (Get-Content "$_" -Raw) -replace $Style_TrialExpiresBanner, $Style_None | Set-Content $_
   (Get-Content "$_" -Raw) -replace $Style_TrialEnded, $Style_None | Set-Content $_
}

# Delete Language Packs
$ErrorActionPreference= 'silentlycontinue'
Remove-Item "$LocalePath" -Force -Recurse

Do {
	# Thanks https://github.com/massgravel/Microsoft-Activation-Scripts for the UI
	Clear-Host
	Write-Output "`n"
	Write-Output "`n"
	Write-Output "                   _______________________________________________________________"
	Write-Output "                  `|                                                               `| "
	Write-Output "                  `|                                                               `|"
	Write-Output "                  `|                            CCSTOPPER                          `|"
	Write-Output "                  `|                      HideTrialBanner Module                   `|"
	Write-Output "                  `|      ___________________________________________________      `|"
	Write-Output "                  `|                                                               `|"
	Write-Output "                  `|                  Hiding Trial Banner complete!                `|"
	Write-Output "                  `|      ___________________________________________________      `|"
	Write-Output "                  `|                                                               `|"
	Write-Output "                  `|      [Q] Exit Module                                          `|"
	Write-Output "                  `|                                                               `|"
	Write-Output "                  `|                                                               `|"
	Write-Output "                  `|_______________________________________________________________`|"
	Write-Output "`n"
	ReadKey
	Switch($Choice) {
		Q { Exit }
		Default {
			$Invalid = $true

		}
	}
} Until (!($Invalid))