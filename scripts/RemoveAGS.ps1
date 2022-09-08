Import-Module $PSScriptRoot\Functions.ps1
Init -Title "Remove AGS"

$AGCCFolder = "${Env:ProgramFiles(x86)}\Common Files\Adobe\AdobeGCClient"
$AGVApp = "${Env:ProgramFiles(x86)}\Adobe\Adobe Creative Cloud\Utils\AdobeGenuineValidator.exe" 

$BlockItems = $AGVApp, $AGCCFolder

# Disable AGSSerivce from starting up and stop it
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

ShowMenu -Back -Subtitles "RemoveAGS Module" -Header "Removing AGS complete!"