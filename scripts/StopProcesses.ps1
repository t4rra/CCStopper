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
	[System.Diagnostics.Process]::Start($NewProcess) | Out-Null
	Exit
}

# Stops Adobe Processes and Services, source: https://gist.github.com/carcheky/530fd85ffff6719486038542a8b5b997#gistcomment-3586740

# Stop adobe services
Get-Service -DisplayName Adobe* | Stop-Service

# Stop adobe processes
$Processes = @()
Get-Process * | Where-Object {$_.CompanyName -match "Adobe" -or $_.Path -match "Adobe"} | ForEach-Object {
	$Processes += ,$_
	if($_.mainWindowTitle.Length) {
		# Process has a window
		$ContinueStopProcess = Read-Host "There are Adobe apps open. Do you want to continue? (y/n)"
		if($ContinueStopProcess -ne "y") { Exit }
	}
}

Foreach($Process in $Processes) { Stop-Process $Process -Force | Out-Null }