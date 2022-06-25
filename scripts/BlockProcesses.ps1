if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
	Start-Process -FilePath PowerShell -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`" `"$($MyInvocation.MyCommand.UnboundArguments)`""
	Exit
}
Set-Location $PSScriptRoot

function Set-ConsoleWindow([int]$Width, [int]$Height) {
	$WindowSize = $Host.UI.RawUI.WindowSize
	$WindowSize.Width = [Math]::Min($Width, $Host.UI.RawUI.BufferSize.Width)
	$WindowSize.Height = $Height

	try {
		$Host.UI.RawUI.WindowSize = $WindowSize
	} catch [System.Management.Automation.SetValueInvocationException] {
		$Maxvalue = ($_.Exception.Message | Select-String "\d+").Matches[0].Value
		$WindowSize.Height = $Maxvalue
		$Host.UI.RawUI.WindowSize = $WindowSize
	}
}

$Host.UI.RawUI.WindowTitle = "CCStopper - Block Adobe Processes"
# Set-ConsoleWindow -Width 73 -Height 42

function Get-UninstallKey ([String]$ID) {
	return (Get-ChildItem HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall -Recurse | Where-Object {$_.PSChildName -Like "$ID*"}).Name
}

$PSAppLocation = (Get-ItemProperty -Path Registry::$(Get-UninstallKey -ID "PHSP")).InstallLocation

# Thanks to Verix#2020, from GenP Discord.
$Files = @("${Env:ProgramFiles(x86)}\Adobe\Adobe Sync\CoreSync\CoreSync.exe", "$Env:ProgramFiles\Adobe\Adobe Creative Cloud Experience\CCXProcess.exe", "${Env:ProgramFiles(x86)}\Common Files\Adobe\Adobe Desktop Common\ADS\Adobe Desktop Service.exe", "$Env:ProgramFiles\Common Files\Adobe\Creative Cloud Libraries\CCLibrary.exe", "$PSAppLocation\LogTransport2.exe", "${Env:ProgramFiles(x86)}\Adobe\Acrobat DC\Acrobat\AdobeCollabSync.exe")

$IsNotBlocked = $false
$IsBlocked = $false

# Check if files are already blocked
Foreach($File in $Files) {
	$Exists = Test-Path -Path $File -PathType Leaf
	if($Exists) {
		(Get-Acl $File).Access | ForEach-Object {
			if(($_.AccessControlType -eq "Deny") -and ($_.FileSystemRights -eq "FullControl") -and ($_.IdentityReference -eq "BUILTIN\Administrators")) {
				$IsBlocked = $true	
			} else {
				$IsNotBlocked = $true
			}
		}
	}
}

function Done {
	Clear-Host
	# Thanks https://github.com/massgravel/Microsoft-Activation-Scripts for the UI
	Write-Host "`n"
	Write-Host "`n"
	Write-Host "                   _______________________________________________________________"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                           CCSTOPPER                           `|"
	Write-Host "                  `|                     BlockProcesses Module                     `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	if($IsBlocked) {
	Write-Host "                  `|                      Unblocked processes!                     `|"
	} elseif($IsNotBlocked) {
	Write-Host "                  `|              Blocking adobe processes complete!               `|"
	}
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      [Q] Exit Module                                          `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|_______________________________________________________________`|"
	Write-Host "`n"
	$Choice = Read-Host ">                                            Select [Q]"
	Clear-Host
	Switch($Choice) {
		Q { Exit }
	}
}

function MainScript {
	Powershell -ExecutionPolicy RemoteSigned -File .\StopProcesses.ps1
	Foreach($File in $Files) {
		$Exists = Test-Path -Path $File -PathType Leaf
		if($Exists) {
			$Acl = Get-Acl -Path $File
			Set-Acl -Path $File -AclObject $Acl # Reorder ACL to canonical order to prevent errors

			if($IsBlocked) {
				# Enable inheritence
				$Acl.SetAccessRuleProtection($false,$true)
				Set-Acl -Path $File -AclObject $Acl
				# Create new empty ACL, removing all inherited ACLs
				$NewAcl = New-Object System.Security.AccessControl.FileSecurity
				Set-Acl -Path $File -AclObject $NewAcl
			} elseif($IsNotBlocked) {
				$FileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList @("BUILTIN\Administrators", "FullControl", "Deny")
				$Acl.SetAccessRule($FileSystemAccessRule)
				Set-Acl -Path $File -AclObject $Acl
			}
		}
	}
	Done
}

if($IsBlocked) {
	Clear-Host
	Write-Host "`n"
	Write-Host "`n"
	Write-Host "                   _______________________________________________________________"
	Write-Host "                  `|                                                               `| "
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                           CCSTOPPER                           `|"
	Write-Host "                  `|                     BlockProcesses Module                     `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|             ADOBE PROCESSES ARE ALREADY BLOCKED!              `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|          Would you like to restore those processes?           `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      [1] Restore Adobe processes                              `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      [Q] Exit Module                                          `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|_______________________________________________________________`|"
	Write-Host "`n"
	$Choice = Read-Host ">                                            Select [1,Q]"
	Clear-Host
	Switch($Choice) {
		Q { Exit }
		1 { MainScript }
	}
} elseif($IsNotBlocked) { MainScript }