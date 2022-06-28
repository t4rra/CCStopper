if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
	Start-Process -FilePath PowerShell -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`" `"$($MyInvocation.MyCommand.UnboundArguments)`""
	Exit
}
Set-Location $PSScriptRoot
Clear-Host

function Set-ConsoleWindow([int]$Width, [int]$Height) {
	$WindowSize = $Host.UI.RawUI.WindowSize
	$WindowSize.Width = [Math]::Min($Width, $Host.UI.RawUI.BufferSize.Width)
	$WindowSize.Height = $Height

	try {
		$Host.UI.RawUI.WindowSize = $WindowSize
	} catch [System.Management.Automation.SetValueInvocationException] {
		$MaxValue = ($_.Exception.Message | Select-String "\d+").Matches[0].Value
		$WindowSize.Height = $MaxValue
		$Host.UI.RawUI.WindowSize = $WindowSize
	}
}

$Host.UI.RawUI.WindowTitle = "CCStopper - Hide Trial Banner"
# Set-ConsoleWindow -Width 73 -Height 42

$AGCCFolder = "${Env:ProgramFiles(x86)}\Common Files\Adobe\AdobeGCClient"

# Disables AGSSerivce from starting up, then stops it
Foreach($Service in @("AGSService", "AGMService")) {
	Get-Service -DisplayName $Service | Set-Service -StartupType Disabled
	Get-Service -DisplayName $Service | Stop-Service
	Stop-Process -Name $Service -Force | Out-Null
}

# Checks if AGSService Exists
if (Test-Path -Path $AGCCFolder) {
	Remove-Item -Path $AGCCFolder -Recurse -Force
}

takeown /f $AGCCFolder
New-Item -Path $AGCCFolder -ItemType Directory
$Acl = Get-Acl -Path $AGCCFolder
Set-Acl -Path $AGCCFolder -AclObject $Acl # Reorder ACL to canonical order to prevent errors
$FileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList @("BUILTIN\Administrators", "FullControl", "Deny")
$Acl.SetAccessRule($FileSystemAccessRule)
Set-Acl -Path $AGCCFolder -AclObject $Acl

Do {
	# Thanks https://github.com/massgravel/Microsoft-Activation-Scripts for the UI
	Clear-Host
	Write-Host "`n"
	Write-Host "`n"
	Write-Host "                   _______________________________________________________________"
	Write-Host "                  `|                                                               `| "
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                            CCSTOPPER                          `|"
	Write-Host "                  `|                         RemoveAGS Module                      `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                     Removing AGS complete!                    `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      [Q] Exit Module                                          `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|_______________________________________________________________`|"
	Write-Host "`n"          
	$Invalid = $false
	$Choice = Read-Host ">                                            Select [Q]"
	Switch($Choice) {
		Q { Exit }
		Default {
			$Invalid = $true
			[Console]::Beep(500,100)
		}
	}
} Until (!($Invalid))