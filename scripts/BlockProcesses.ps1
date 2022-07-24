Import-Module $PSScriptRoot\Functions.ps1
Init -Title "Block Adobe Processes"

function Get-Subkey([String]$Key, [String]$SubkeyPattern) {
	return (Get-ChildItem $Key -Recurse | Where-Object { $_.PSChildName -Like "$SubkeyPattern" }).Name
}

$PSAppLocation = (Get-ItemProperty -Path Registry::$(Get-Subkey -Key "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" -SubkeyPattern "PHSP*")).InstallLocation

# Thanks to Verix#2020, from GenP Discord.
$Files = @("${Env:ProgramFiles(x86)}\Adobe\Adobe Sync\CoreSync\CoreSync.exe", "$Env:ProgramFiles\Adobe\Adobe Creative Cloud Experience\CCXProcess.exe", "${Env:ProgramFiles(x86)}\Common Files\Adobe\Adobe Desktop Common\ADS\Adobe Desktop Service.exe", "$Env:ProgramFiles\Common Files\Adobe\Creative Cloud Libraries\CCLibrary.exe", "$PSAppLocation\LogTransport2.exe", "${Env:ProgramFiles(x86)}\Adobe\Acrobat DC\Acrobat\AdobeCollabSync.exe")

$IsNotBlocked = $false
$IsBlocked = $false

# Check if files are already blocked
foreach ($File in $Files) {
	$Exists = Test-Path -Path $File -PathType Leaf
	if ($Exists) {
		(Get-Acl $File).Access | ForEach-Object {
			if (($_.AccessControlType -eq "Deny") -and ($_.FileSystemRights -eq "FullControl") -and ($_.IdentityReference -eq "BUILTIN\Administrators")) {
				$IsBlocked = $true
			} else {
				$IsNotBlocked = $true
			}
		}
	}
}

function Done {
	ShowMenu -Subtitles "BlockProcesses Module" if ($IsBlocked) { -Header "Unblocked processes!" } elseif ($IsNotBlocked) { -Header "Blocking Adobe processes complete!" }
}

function MainScript {
	Clear-Host
	.\StopProcesses.ps1
	foreach ($File in $Files) {
		if ((Test-Path -Path $File -PathType Leaf)) {
			$Acl = Get-Acl -Path $File
			Set-Acl -Path $File -AclObject $Acl # Reorder ACL to canonical order to prevent errors

			if ($IsBlocked) {
				# Enable inheritence
				$Acl.SetAccessRuleProtection($false, $true)
				Set-Acl -Path $File -AclObject $Acl
				# Create new empty ACL, removing all inherited ACLs
				$NewAcl = New-Object System.Security.AccessControl.FileSecurity
				Set-Acl -Path $File -AclObject $NewAcl
			} elseif ($IsNotBlocked) {
				$FileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList @("BUILTIN\Administrators", "FullControl", "Deny")
				$Acl.SetAccessRule($FileSystemAccessRule)
				Set-Acl -Path $File -AclObject $Acl
			}
		}
	}
	Done
}

if ($IsBlocked) {
	ShowMenu -Back -Subtitles "BlockProcesses Module" -Header "ADOBE PROCESSES ARE ALREADY BLOCKED!" -Description "Would you like to restore those processes?" -Options @(
		@{
			Name = "Restore Adobe processes"
			Code = {
				MainScript
			}
		}
	)
} elseif ($IsNotBlocked) { MainScript }