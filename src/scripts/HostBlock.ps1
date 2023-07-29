Import-Module $PSScriptRoot\Functions.ps1
Init -Title "Hosts Block"

$StartCommentedLine = "`# START CCStopper Block List - DO NOT EDIT THIS LINE"
$EndCommentedLine = "`# END CCStopper Block List - DO NOT EDIT THIS LINE"

$LocalAddress = "0.0.0.0"
$HostsFile = "$Env:SystemRoot\System32\drivers\etc\hosts"
$RemoteURL = "https://raw.githubusercontent.com/eaaasun/CCStopper/data/Hosts.txt"

# check if hosts file is writable
try {
	$stream = [System.IO.File]::OpenWrite($HostsFile)
	$stream.Close()
	$ChangedPerms = $false
}
catch {
	icacls $HostsFile /grant "Administrators:(w)"
	$ChangedPerms = $true
}

# get hosts file and filter for blocked addresses from CCStopper there
$CurrentHostsList = [System.IO.File]::ReadAllText((Get-Item $HostsFile).FullName) | Select-String -Pattern "(?s)$StartCommentedLine(.*?)$EndCommentedLine" -AllMatches | ForEach-Object { $_.Matches.Value.Trim() }

try {
	$BlockedAddresses = (Invoke-WebRequest $RemoteURL -TimeoutSec 5 -UseBasicParsing -Headers @{"Cache-Control" = "no-cache" }).Content.Split("`n", [StringSplitOptions]::RemoveEmptyEntries) | Where-Object { $_ -ne '' } | ForEach-Object { $_.Trim() }
	$Offline = $false
}
catch {
	$UpdateAvaliable = $false
	$Offline = $true
}

if (!$Offline) {
	# create formatted list of addresses
	$NewHostsList = "$StartCommentedLine`r`n"
	foreach ($Address in $BlockedAddresses) {
		$NewHostsList += "$LocalAddress $Address`r`n"
	}
	$NewHostsList += "$EndCommentedLine"
	$NewHostsList = $NewHostsList.Trim()
	# compare current hosts list with new hosts list
	$UpdateAvaliable = (Compare-Object $CurrentHostsList $NewHostsList -SyncWindow 0)
}

function RemoveBlockList {
	# remove block list from hosts file
	$RemovedBlockListFile = [System.IO.File]::ReadAllText((Get-Item $HostsFile).FullName) -replace $CurrentHostsList, ""
	[System.IO.File]::WriteAllText((Get-Item $HostsFile).FullName, $RemovedBlockListFile)
}

function AddBlockList {
	# add block list to hosts file
	$NewBlockListFile = [System.IO.File]::ReadAllText((Get-Item $HostsFile).FullName) + "`r`n" + $NewHostsList
	[System.IO.File]::WriteAllText((Get-Item $HostsFile).FullName, $NewBlockListFile)
}

function OperationCompleted([string]$Operation) {
	if ($ChangedPerms) {
		icacls $HostsFile /remove "Administrators:(w)"
	}
	ShowMenu -Back -Subtitle "Hosts Block Module" -Header "$Operation"
}

if ($CurrentHostsList) {
	if ($UpdateAvaliable) {
		ShowMenu -Back -Subtitle "Hosts Block Module" -Header "Hosts block list out of sync!" -Description "The current blocked addresses are out of sync with the latest blocked addresses." -Options @(
			@{
				Name = "Sync Addresses"
				Code = {
					RemoveBlockList
					AddBlockList
					OperationCompleted -Operation "Hosts block list synced!"
				}
			}, 
			@{
				Name = "Remove Hosts Block"
				Code = {
					RemoveBlockList
					OperationCompleted -Operation "Hosts block list removed!"
				}
			}		
		)
	}
 else {
		ShowMenu -Back -Subtitle "Hosts Block Module" -Header "Hosts block list exists!" -Description "Would you like to remove it?" -Options @(
			@{
				Name = "Remove Hosts Block"
				Code = {
					RemoveBlockList
					OperationCompleted -Operation "Hosts block list removed!"
				}
			}
		)
	}
}
else {
	if ($Offline) {
		ShowMenu -Back -Subtitle "Hosts Block Module" -Header "Cannot connect to Github!" -Description "You may be offline or Github may be down."
	}
 else {
		AddBlockList
		OperationCompleted -Operation "Hosts block list added!"
	}
}