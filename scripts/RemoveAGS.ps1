if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
	Start-Process -FilePath $((Get-Process -Id $PID).Path) -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`" `"$($MyInvocation.MyCommand.UnboundArguments)`""
	Exit
}
Set-Location $PSScriptRoot
Clear-Host

$Host.UI.RawUI.WindowTitle = "CCStopper - Hide Trial Banner"
# Set-ConsoleWindow -Width 73 -Height 42

$AGCCFolder = "${Env:ProgramFiles(x86)}\Common Files\Adobe\AdobeGCClient"
$AGVApp = "${Env:ProgramFiles(x86)}\Adobe\Adobe Creative Cloud\Utils\AdobeGenuineValidator.exe" 

$BlockItems = $AGVApp, $AGCCFolder

# Disables AGSSerivce from starting up, then stops it
Foreach ($Service in @("AGSService", "AGMService")) {
	Get-Service -DisplayName $Service | Set-Service -StartupType Disabled
	Get-Service -DisplayName $Service | Stop-Service
	Stop-Process -Name $Service -Force | Out-Null
}

function CreateFiles {
	New-Item -Path $AGCCFolder -ItemType "Directory"
	New-Item -Path $AGVApp -ItemType "File" -Force

}

foreach ($BlockItem in $BlockItems) {
	if (Test-Path -Path $BlockItem) {
		Remove-Item -Path $BlockItem -Force -Recurse
	}
	takeown /f $BlockItem
	CreateFiles
	$Acl = Get-Acl -Path $BlockItem
	Set-Acl -Path $BlockItem -AclObject $Acl # Reorder ACL to canonical order to prevent errors
	$FileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList @("BUILTIN\Administrators", "FullControl", "Deny")
	$Acl.SetAccessRule($FileSystemAccessRule)
	Set-Acl -Path $BlockItem -AclObject $Acl
}
pause 

Do {
	Clear-Host
	Write-Output "`n"
	Write-Output "`n"
	Write-Output "                   _______________________________________________________________"
	Write-Output "                  `|                                                               `| "
	Write-Output "                  `|                                                               `|"
	Write-Output "                  `|                            CCSTOPPER                          `|"
	Write-Output "                  `|                         RemoveAGS Module                      `|"
	Write-Output "                  `|      ___________________________________________________      `|"
	Write-Output "                  `|                                                               `|"
	Write-Output "                  `|                     Removing AGS complete!                    `|"
	Write-Output "                  `|      ___________________________________________________      `|"
	Write-Output "                  `|                                                               `|"
	Write-Output "                  `|      [Q] Exit Module                                          `|"
	Write-Output "                  `|                                                               `|"
	Write-Output "                  `|                                                               `|"
	Write-Output "                  `|_______________________________________________________________`|"
	Write-Output "`n"
	ReadKey
	Switch ($Choice) {
		Q { Exit }
		Default {
			$Invalid = $true
		}
	}
} Until (!($Invalid))