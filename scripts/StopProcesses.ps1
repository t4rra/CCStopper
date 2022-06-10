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

Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;

public class ProcessWindowFinder
{
	private delegate bool WindowDelegate(IntPtr hWnd, int lParam);

	[DllImport("user32.dll", SetLastError=true)]
	private static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint processId);

	[DllImport("user32.dll")]
	private static extern bool EnumDesktopWindows(IntPtr hDesktop, WindowDelegate lpfn, IntPtr lParam);

	public static bool FindByPID(uint pid)
	{
		bool found = false;
		ProcessWindowFinder.WindowDelegate filter = delegate(IntPtr hWnd, int lParam)
		{
			if(!found)
			{
				// test whether this window belongs to the target process 
				// if we haven't already found a windows belonging to it
				uint _pid;
				GetWindowThreadProcessId(hWnd, out _pid);
				if(pid == _pid)
					found = true;
			}

			return true;
		};
		EnumDesktopWindows(IntPtr.Zero, filter, IntPtr.Zero);

		return found;
	}
}
'@

# Stops Adobe Processes and Services, source: https://gist.github.com/carcheky/530fd85ffff6719486038542a8b5b997#gistcomment-3586740
Get-Service -DisplayName Adobe* | Stop-Service

$processes = @()
$adobeAppRunning = $false

Get-Process * | Where-Object {$_.CompanyName -match "Adobe" -or $_.Path -match "Adobe"} | Foreach-Object {
	$processes += ,$_

	if([ProcessWindowFinder]::FindByPID($_.Id)) {
		# process has a window
		$adobeAppRunning = $true
		write-host $adobeAppRunning
		write-host $_.
	}
}

if($adobeAppRunning) {
	$continueStopProcess = Read-Host "There are Adobe apps open. Do you want to continue? (y/n)"
	if($continueStopProcess -eq "y") {
		Foreach($process in $processes) {
			if(!($process.HasExited)) {
				$process | Stop-Process -Force | Out-Null
			}
		}
	} else {
		exit
	}
}