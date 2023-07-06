Import-Module $PSScriptRoot\Functions.ps1
Init -Title "Hosts Block"

$StartCommentedLine = "`# START CCStopper Block List - DO NOT EDIT THIS LINE"
$EndCommentedLine = "`# END CCStopper Block List - DO NOT EDIT THIS LINE"

$LocalAddress = "0.0.0.0"
$HostsFile = "$Env:SystemRoot\System32\drivers\etc\hosts"

# Local Hosts list will only be used once to create data.txt if it doesn't exist
$LocalHostsList = @(
	"ic.adobe.io",
	"52.6.155.20",
	"52.10.49.85",
	"23.22.30.141",
	"34.215.42.13",
	"52.84.156.37",
	"65.8.207.109",
	"3.220.11.113",
	"3.221.72.231",
	"3.216.32.253",
	"3.208.248.199",
	"3.219.243.226",
	"13.227.103.57",
	"34.192.151.90",
	"34.237.241.83",
	"44.240.189.42",
	"52.20.222.155",
	"52.208.86.132",
	"54.208.86.132",
	"63.140.38.120",
	"63.140.38.160",
	"63.140.38.169",
	"63.140.38.219",
	"wip.adobe.com",
	"adobeereg.com",
	"18.228.243.121",
	"18.230.164.221",
	"54.156.135.114",
	"54.221.228.134",
	"54.224.241.105",
	"100.24.211.130",
	"162.247.242.20",
	"wip1.adobe.com",
	"wip2.adobe.com",
	"wip3.adobe.com",
	"wip4.adobe.com",
	"3dns.adobe.com",
	"ereg.adobe.com",
	"199.232.114.137",
	"bam.nr-data.net",
	"practivate.adobe",
	"ood.opsource.net",
	"crl.verisign.net",
	"3dns-1.adobe.com",
	"3dns-2.adobe.com",
	"3dns-3.adobe.com",
	"3dns-4.adobe.com",
	"hl2rcv.adobe.com",
	"genuine.adobe.com",
	"www.adobeereg.com",
	"www.wip.adobe.com",
	"www.wip1.adobe.com",
	"www.wip2.adobe.com",
	"www.wip3.adobe.com",
	"www.wip4.adobe.com",
	"ereg.wip.adobe.com",
	"activate.adobe.com",
	"adobe-dns.adobe.com",
	"ereg.wip1.adobe.com",
	"ereg.wip2.adobe.com",
	"ereg.wip3.adobe.com",
	"ereg.wip4.adobe.com",
	"cc-api-data.adobe.io",
	"practivate.adobe.ntp",
	"practivate.adobe.ipp",
	"practivate.adobe.com",
	"adobe-dns-1.adobe.com",
	"adobe-dns-2.adobe.com",
	"adobe-dns-3.adobe.com",
	"adobe-dns-4.adobe.com",
	"lm.licenses.adobe.com",
	"hlrcv.stage.adobe.com",
	"prod.adobegenuine.com",
	"practivate.adobe.newoa",
	"activate.wip.adobe.com",
	"activate-sea.adobe.com",
	"uds.licenses.adobe.com",
	"k.sni.global.fastly.net",
	"activate-sjc0.adobe.com",
	"activate.wip1.adobe.com",
	"activate.wip2.adobe.com",
	"activate.wip3.adobe.com",
	"activate.wip4.adobe.com",
	"na1r.services.adobe.com",
	"lmlicenses.wip4.adobe.com",
	"na2m-pr.licenses.adobe.com",
	"wwis-dubc1-vip60.adobe.com",
	"workflow-ui-prod.licensingstack.com",
	"5zgzzv92gn.adobe.io",
	"8ncdzpmmrg.adobe.io",
	"7m31guub0q.adobe.io",
	"jc95y2v12r.adobe.io",
	"ph0f2h2csf.adobe.io",
	"2ftem87osk.adobe.io"
)

# Check if github is reachable
$GHConnected = Test-Connection -ComputerName github.com -Count 1 -Quiet
# Check if avaliable update
if ($GHConnected) {
	$remoteBlockedAddresses = ArrayFromText -Source "https://raw.githubusercontent.com/eaaasun/CCStopper/data/Hosts.txt"
}

# Check if /data/hosts is avaliable, if not make it
if (!(Test-Path ".\data\Hosts.txt")) {
	New-Item -Path ".\data" -ItemType Directory
	New-Item -Path ".\data\Hosts.txt" -ItemType File
	if ($GHConnected) {
		$remoteBlockedAddresses | Out-File "$PSScriptRoot\data\Hosts.txt"
	}
	else {
		$LocalHostsList | Out-File "$PSScriptRoot\data\Hosts.txt"
	}
}
$BlockedAddresses = ArrayFromText -Source ".\data\Hosts.txt" -IsLocal
$UpdateAvaliable = (Compare-Object $remoteBlockedAddresses $BlockedAddresses -SyncWindow 0) -and $GHConnected

# legacy migration
# # check if "# CCStopper Adobe Block List" line exists
if (Select-String -Path $HostsFile -Pattern "`# CCStopper Adobe Block List") {
	# loop through each item in localhostslist and check if it exists in hosts file, delete the line if it does
	$OriginalHosts = [System.IO.File]::ReadAllText($(Get-Item($HostsFile)).FullName)
	$Unwanted += "`# CCStopper Adobe Block List"
	foreach ($Address in $BlockedAddresses) {
		# find match in hosts file, if so remove it if not skip
		if (Select-String -Path $HostsFile -Pattern "$LocalAddress $Address") {
			$Unwanted += "`r`n$LocalAddress $Address"
		}
	}
	$NewText = $OriginalHosts -split $Unwanted, 0, 'simplematch' -join ''
	[System.IO.File]::WriteAllText($HostsFile, $NewText)
}




function addToHosts {
	$BlockedAddresses = ArrayFromText -Source "$PSScriptRoot\data\Hosts.txt" -IsLocal
	[System.IO.File]::AppendAllText($HostsFile, "`r`n$StartCommentedLine")
	RemoveEndBlankLine
	# Add blocked addresses to hosts file
	foreach ($Address in $BlockedAddresses) {
		[System.IO.File]::AppendAllText($HostsFile, "`r`n$LocalAddress $Address")
	}
	[System.IO.File]::AppendAllText($HostsFile, "`r`n$EndCommentedLine")
}

function removeFromHosts {
	# Source: https://social.technet.microsoft.com/Forums/en-US/8a4393f1-9ca6-46d3-933c-07217fa12695/string-replace-error-in-powershell
	$OriginalHosts = [System.IO.File]::ReadAllText($(Get-Item($HostsFile)).FullName)
	# add all lines of text between start and end commented lines to $Unwanted
	$pattern = "(?s)$StartCommentedLine(.*?)$EndCommentedLine"
	$Unwanted = $OriginalHosts | Select-String -Pattern $pattern -AllMatches | ForEach-Object { $_.Matches.Value }
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

	$StringSearch = Select-String -Path $HostsFile -Pattern $("$StartCommentedLine") -CaseSensitive -Quiet

	if ($StringSearch) {
		# blocked addresses already in hosts file
		if ($UpdateAvaliable) {
			$HeaderMSG = "Update avaliable!"
			$DescMSG = "Would you like to update?"
		}
		else {
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
					Name = "Ignore update and apply to hosts file"
					Code = {
						addToHosts 
						ShowMenu -Back -Subtitles "HostBlock Module" -Header "Successfully added blocked lines in hosts file!"	
					}
				},
				@{
					Name = "Update blocklist and apply to hosts file"
					Code = {
						updateHosts 
						ShowMenu -Back -Subtitles "HostBlock Module" -Header "Successfully updated/added blocked lines in hosts file!"	
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
