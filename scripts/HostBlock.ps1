Import-Module $PSScriptRoot\Functions.ps1
Init -Title "Hosts Block"

# Set-ConsoleWindow -Width 73 -Height 42
$CommentedLine = "`# CCStopper Adobe Block List"

$LocalAddress = "0.0.0.0"
$BlockedAddresses = @("ic.adobe.io", "52.6.155.20", "52.10.49.85", "23.22.30.141", "34.215.42.13", "52.84.156.37", "65.8.207.109", "3.220.11.113", "3.221.72.231", "3.216.32.253", "3.208.248.199", "3.219.243.226", "13.227.103.57", "34.192.151.90", "34.237.241.83", "44.240.189.42", "52.20.222.155", "52.208.86.132", "54.208.86.132", "63.140.38.120", "63.140.38.160", "63.140.38.169", "63.140.38.219", "wip.adobe.com", "adobeereg.com", "18.228.243.121", "18.230.164.221", "54.156.135.114", "54.221.228.134", "54.224.241.105", "100.24.211.130", "162.247.242.20", "wip1.adobe.com", "wip2.adobe.com", "wip3.adobe.com", "wip4.adobe.com", "3dns.adobe.com", "ereg.adobe.com", "199.232.114.137", "bam.nr-data.net", "practivate.adobe", "ood.opsource.net", "crl.verisign.net", "3dns-1.adobe.com", "3dns-2.adobe.com", "3dns-3.adobe.com", "3dns-4.adobe.com", "hl2rcv.adobe.com", "genuine.adobe.com", "www.adobeereg.com", "www.wip.adobe.com", "www.wip1.adobe.com", "www.wip2.adobe.com", "www.wip3.adobe.com", "www.wip4.adobe.com", "ereg.wip.adobe.com", "activate.adobe.com", "adobe-dns.adobe.com", "ereg.wip1.adobe.com", "ereg.wip2.adobe.com", "ereg.wip3.adobe.com", "ereg.wip4.adobe.com", "cc-api-data.adobe.io", "practivate.adobe.ntp", "practivate.adobe.ipp", "practivate.adobe.com", "adobe-dns-1.adobe.com", "adobe-dns-2.adobe.com", "adobe-dns-3.adobe.com", "adobe-dns-4.adobe.com", "lm.licenses.adobe.com", "hlrcv.stage.adobe.com", "prod.adobegenuine.com", "practivate.adobe.newoa", "activate.wip.adobe.com", "activate-sea.adobe.com", "uds.licenses.adobe.com", "k.sni.global.fastly.net", "activate-sjc0.adobe.com", "activate.wip1.adobe.com", "activate.wip2.adobe.com", "activate.wip3.adobe.com", "activate.wip4.adobe.com", "na1r.services.adobe.com", "lmlicenses.wip4.adobe.com", "na2m-pr.licenses.adobe.com", "wwis-dubc1-vip60.adobe.com", "workflow-ui-prod.licensingstack.com")
$HostsFile = "$Env:SystemRoot\System32\drivers\etc\hosts"
# $HostsFile = "C:\Users\Easun\Desktop\testhosts.txt"

# check if host file 1) exists, 2) is writable 3) has blocked addresses already

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
	$StringSearchCount = $null
	foreach ($Address in $BlockedAddresses) {
		$StringSearch = Select-String -Path $HostsFile -Pattern $("$LocalAddress $Address") -CaseSensitive -Quiet
		if ($StringSearch) {
			$StringSearchCount++
		}
	}
	if ($StringSearchCount) {
		ShowMenu -Back -Subtitles "HostBlock Module" -Header "Blocked addresses already in hosts file!" -Description "Found $StringSearchCount out of $($BlockedAddresses.Count) blocked addresses in hosts file. Would you like to remove them?" -Options @(
			@{
				Name = "Remove $StringSearchCount addresses from hosts file"
				Code = {
					$OriginalHosts = [System.IO.File]::ReadAllText($(Get-Item($HostsFile)).FullName)

					# $RemoveText = Get-Content $HostsFile | Where-Object { $_ -notmatch "$CommentedLine"}
					# Set-Content -Path $HostsFile -Value $RemoveText
					$Unwanted += "$CommentedLine"
					foreach ($Address in $BlockedAddresses) {
						$Unwanted += "`r`n$LocalAddress $Address"
					}
					$NewText = $OriginalHosts -split $Unwanted, 0, 'simplematch' -join ''
					[System.IO.File]::WriteAllText($HostsFile, $NewText)
					RemoveEndBlankLine
					ShowMenu -Back -Subtitles "HostBlock Module" -Header "Successfully removed blocked lines from hosts file!"
				}
			}
		)
	}
 else {
		Add-Content -Path $HostsFile -Value "`r`n$CommentedLine"
		RemoveEndBlankLine
		# Add blocked addresses to hosts file
		foreach ($Address in $BlockedAddresses) {
			[System.IO.File]::AppendAllText($HostsFile, "`r`n$LocalAddress $Address")
		}
		# RemoveEndBlankLine
		ShowMenu -Back -Subtitles "HostBlock Module" -Header "Successfully added blocked lines in hosts file!"
	}
}
else {
	ShowMenu -Back -Subtitles "HostBlock Module" -Header "Hosts file not found!" -Description "Hosts file could not be found.", "", "If your hosts file exists and you see this error, open an issue on Github and include the target hosts file path:", "$HostsFile"
}