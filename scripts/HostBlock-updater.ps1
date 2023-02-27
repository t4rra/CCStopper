Import-Module $PSScriptRoot\Functions.ps1

$remoteBlockedAddresses = ArrayFromText -Source "https://raw.githubusercontent.com/eaaasun/CCStopper/data/Hosts.txt"
$BlockedAddresses = ArrayFromText -Source "$PSScriptRoot\data\Hosts.txt" -IsLocal

# Compare the two arrays
$comparisonResult = Compare-Object $remoteBlockedAddresses $BlockedAddresses -IncludeEqual

# Check if the arrays are the same
if (!(Compare-Object $remoteBlockedAddresses $BlockedAddresses -SyncWindow 0)) {
	ShowMenu -Subtitles "HostBlock Module" -Header "No update available!"
	# write-host $remoteBlockedAddresses
	# Write-Host "---------------------"
	# write-host $BlockedAddresses
}
else {
	ShowMenu -Back -Subtitles "HostBlock Module" -Header "Update available!" -Description "Would you like to update the hosts file?" -Options @(
		@{
			Name = "Update hosts file"
			Code = {
				$remoteBlockedAddresses | Out-File "$PSScriptRoot\data\Hosts.txt"
				ShowMenu -Subtitles "HostBlock Module" -Header "Successfully updated hosts file!"
			}
		}
	)
}