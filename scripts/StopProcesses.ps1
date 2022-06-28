if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
	Start-Process -FilePath PowerShell -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`" `"$($MyInvocation.MyCommand.UnboundArguments)`""
	Exit
}
Set-Location $PSScriptRoot
Clear-Host

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

Clear-Host
Write-Host "`n"
Write-Host "`n"
Write-Host "                   _______________________________________________________________"
Write-Host "                  `|                                                               `| "
Write-Host "                  `|                                                               `|"
Write-Host "                  `|                            CCSTOPPER                          `|"
Write-Host "                  `|                       StopProcesses Module                    `|"
Write-Host "                  `|      ___________________________________________________      `|"
Write-Host "                  `|                                                               `|"
Write-Host "                  `|                Stopping adobe processes complete.             `|"
Write-Host "                  `|      ___________________________________________________      `|"
Write-Host "                  `|                                                               `|"
Write-Host "                  `|      [Q] Exit Module                                          `|"
Write-Host "                  `|                                                               `|"
Write-Host "                  `|                                                               `|"
Write-Host "                  `|_______________________________________________________________`|"
Write-Host "`n"          
Do {
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