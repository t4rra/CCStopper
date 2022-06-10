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

# Stops Adobe Processes and Services, source: https://gist.github.com/carcheky/530fd85ffff6719486038542a8b5b997#gistcomment-3586740

# Stop adobe services
Get-Service -DisplayName Adobe* | Stop-Service

# Stop adobe processes
$Processes = @()
$AdobeAppRunning = $False

Get-Process * | Where-Object {$_.CompanyName -match "Adobe" -or $_.Path -match "Adobe"} | Foreach-Object {
	$Processes += ,$_
	$Shell  = New-Object -ComObject Wscript.Shell
	if($Shell.AppActivate($_.ProcessName) -eq "True") {
		# Process has a window
		$AdobeAppRunning = $True
	}
}

if($AdobeAppRunning -eq $True) {
	$ContinueStopProcess = Read-Host "There are Adobe apps open. Do you want to continue? (y/n)"
	if($ContinueStopProcess -eq "y") {
		Foreach($Process in $Processes) {
			if(!($Process.HasExited)) {
				$Process | Stop-Process -Force | Out-Null
			}
		}
	} else {
		Exit
	}
}