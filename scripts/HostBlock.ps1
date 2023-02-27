Import-Module $PSScriptRoot\Functions.ps1
Init -Title "Hosts Block"

# Set-ConsoleWindow -Width 73 -Height 42
$CommentedLine = "`# CCStopper Adobe Block List"

$LocalAddress = "0.0.0.0"
$HostsFile = "$Env:SystemRoot\System32\drivers\etc\hosts"
$BlockedAddresses = ArrayFromText -Source ".\data\Hosts.txt" -IsLocal

# Check if github is reachable
$GHConnected = Test-Connection -ComputerName github.com -Count 1 -Quiet
# Check if avaliable update
if ($GHConnected) {
	$remoteBlockedAddresses = ArrayFromText -Source "https://raw.githubusercontent.com/eaaasun/CCStopper/data/Hosts.txt"
}
$UpdateAvaliable = (Compare-Object $remoteBlockedAddresses $BlockedAddresses -SyncWindow 0) -and $GHConnected


function addToHosts {
	$BlockedAddresses = ArrayFromText -Source "$PSScriptRoot\data\Hosts.txt" -IsLocal
	Add-Content -Path $HostsFile -Value "`r`n$CommentedLine"
	RemoveEndBlankLine
	# Add blocked addresses to hosts file
	foreach ($Address in $BlockedAddresses) {
		[System.IO.File]::AppendAllText($HostsFile, "`r`n$LocalAddress $Address")
	}
}

function removeFromHosts {
	# Source: https://social.technet.microsoft.com/Forums/en-US/8a4393f1-9ca6-46d3-933c-07217fa12695/string-replace-error-in-powershell
	$OriginalHosts = [System.IO.File]::ReadAllText($(Get-Item($HostsFile)).FullName)
	$Unwanted += "$CommentedLine"
	foreach ($Address in $BlockedAddresses) {
		$Unwanted += "`r`n$LocalAddress $Address"
	}
	$NewText = $OriginalHosts -split $Unwanted, 0, 'simplematch' -join ''
	[System.IO.File]::WriteAllText($HostsFile, $NewText)
	RemoveEndBlankLine
}

function updateHosts {
	removeFromHosts
	$remoteBlockedAddresses | Out-File "$PSScriptRoot\data\Hosts.txt"
	addToHosts
}

function RemoveEndBlankLine {
	# Source: https://www.reddit.com/r/PowerShell/comments/68sa4e/comment/dh0wyxp/?utm_source=share&utm_medium=web2x&context=3
	$Newtext = (Get-Content -Path $HostsFile -Raw) -replace "(?s)`r`n\s*$"
	[System.IO.File]::WriteAllText($HostsFile, $Newtext)	
}

if (Test-Path $HostsFile) {
	# Source: https://stackoverflow.com/a/22943669
	try {
		[IO.File]::OpenWrite($HostsFile).close()
	}
	catch {
		ShowMenu -Back -Subtitles "HostBlock Module" -Header "Cannot write to hosts file!" -Description "Would you like to grant permissions to write to the hosts file? This may impact the security of your system." -Options @(
			@{
				Name = "Grant write permissions for hosts file"
				Code = {
					icacls $HostsFile /grant "Everyone:(w)"
				}
			}
		)
	}

	#check if blocked addresses are already in hosts file
	foreach ($Address in $BlockedAddresses) {
		$StringSearch = Select-String -Path $HostsFile -Pattern $("$LocalAddress $Address") -CaseSensitive -Quiet
	}
	if ($StringSearch) {
		# blocked addresses already in hosts file
		if ($UpdateAvaliable) {
			$HeaderMSG = "Update avaliable!"
			$DescMSG = "Would you like to update?"
		} else {
			$HeaderMSG = "Blocked addresses already in hosts file!"
			$DescMSG = "Would you like to remove them?"
		}
		ShowMenu -Back -Subtitles "HostBlock Module" -Header $HeaderMSG -Description $DescMSG -Options @(
			@{
				Name = "Remove addresses from hosts file"
				Code = {
					removeFromHosts
					ShowMenu -Back -Subtitles "HostBlock Module" -Header "Successfully removed blocked lines from hosts file!"

				}
			} 
			if ($UpdateAvaliable) {
				, @{
					Name = "Update blocklist and apply to hosts file"
					Code = {
						updateHosts 
						ShowMenu -Back -Subtitles "HostBlock Module" -Header "Successfully updated hosts file!"	
					}
				}
			}
		)
	}
 else {
		# blocked addresses not in hosts file
		if ($UpdateAvaliable) {
			ShowMenu -Back -Subtitles "HostBlock Module" -Header "Hosts update available!" -Description "Would you like to update?" -Options @(
				@{
					Name = "Update blocklist and apply to hosts file"
					Code = {
						updateHosts 
						ShowMenu -Back -Subtitles "HostBlock Module" -Header "Successfully updated/added blocked lines in hosts file!"	
					}
				},
				@{
					Name = "Ignore update and apply to hosts file"
					Code = {
						addToHosts 
						ShowMenu -Back -Subtitles "HostBlock Module" -Header "Successfully added blocked lines in hosts file!"	
					}
				}

			)
		}
		else {
			addToHosts
			ShowMenu -Back -Subtitles "HostBlock Module" -Header "Successfully added blocked lines in hosts file!"	
		}
	}
}
else {
	ShowMenu -Back -Subtitles "HostBlock Module" -Header "Hosts file not found!" -Description "Hosts file could not be found.", "", "If your hosts file exists and you see this error, open an issue on Github and include the target hosts file path:", "$HostsFile"
}