Import-Module $PSScriptRoot\Functions.ps1
Init -Title "Stop Processes"

# Stops Adobe Processes and Services, source: https://gist.github.com/carcheky/530fd85ffff6719486038542a8b5b997#gistcomment-3586740

# Stop adobe services
Get-Service -DisplayName Adobe* | Stop-Service

# Stop adobe processes
$Processes = @()
Get-Process * | Where-Object { $_.CompanyName -match "Adobe" -or $_.Path -match "Adobe" } | ForEach-Object {
	$Processes += , $_
	if ($_.mainWindowTitle.Length) {
		# Process has a window
		ShowMenu -Back -Subtitles "StopProcesses Module" -Header "THERE ARE ADOBE APPS OPEN!" -Description "Do you want to continue? Unsaved documents in Adobe apps will be lost" -Options @(
			@{
				Name = "Continue"
				Code = { continue }
			}
		)
	}
}

Foreach ($Process in $Processes) { Stop-Process $Process -Force | Out-Null }
ShowMenu -Back -Subtitles "StopProcesses Module" -Header "Stopping Adobe processes complete!"