Import-Module $PSScriptRoot\Functions.ps1
Init -Title "Internet Block"

# Set-ConsoleWindow -Width 73 -Height 42

$CommentedLine = "`# BLOCK ADOBE"

$LocalAddress = "127.0.0.1"
$BlockedAddresses = @("ic.adobe.io", "52.6.155.20", "52.10.49.85", "23.22.30.141", "34.215.42.13", "52.84.156.37", "65.8.207.109", "3.220.11.113", "3.221.72.231", "3.216.32.253", "3.208.248.199", "3.219.243.226", "13.227.103.57", "34.192.151.90", "34.237.241.83", "44.240.189.42", "52.20.222.155", "52.208.86.132", "54.208.86.132", "63.140.38.120", "63.140.38.160", "63.140.38.169", "63.140.38.219", "wip.adobe.com", "adobeereg.com", "18.228.243.121", "18.230.164.221", "54.156.135.114", "54.221.228.134", "54.224.241.105", "100.24.211.130", "162.247.242.20", "wip1.adobe.com", "wip2.adobe.com", "wip3.adobe.com", "wip4.adobe.com", "3dns.adobe.com", "ereg.adobe.com", "199.232.114.137", "bam.nr-data.net", "practivate.adobe", "ood.opsource.net", "crl.verisign.net", "3dns-1.adobe.com", "3dns-2.adobe.com", "3dns-3.adobe.com", "3dns-4.adobe.com", "hl2rcv.adobe.com", "genuine.adobe.com", "www.adobeereg.com", "www.wip.adobe.com", "www.wip1.adobe.com", "www.wip2.adobe.com", "www.wip3.adobe.com", "www.wip4.adobe.com", "ereg.wip.adobe.com", "activate.adobe.com", "adobe-dns.adobe.com", "ereg.wip1.adobe.com", "ereg.wip2.adobe.com", "ereg.wip3.adobe.com", "ereg.wip4.adobe.com", "cc-api-data.adobe.io", "practivate.adobe.ntp", "practivate.adobe.ipp", "practivate.adobe.com", "adobe-dns-1.adobe.com", "adobe-dns-2.adobe.com", "adobe-dns-3.adobe.com", "adobe-dns-4.adobe.com", "lm.licenses.adobe.com", "hlrcv.stage.adobe.com", "prod.adobegenuine.com", "practivate.adobe.newoa", "activate.wip.adobe.com", "activate-sea.adobe.com", "uds.licenses.adobe.com", "k.sni.global.fastly.net", "activate-sjc0.adobe.com", "activate.wip1.adobe.com", "activate.wip2.adobe.com", "activate.wip3.adobe.com", "activate.wip4.adobe.com", "na1r.services.adobe.com", "lmlicenses.wip4.adobe.com", "na2m-pr.licenses.adobe.com", "wwis-dubc1-vip60.adobe.com", "workflow-ui-prod.licensingstack.com")
$HostFile = "$Env:SystemRoot\System32\drivers\etc\hosts"

# if(!((Get-ItemProperty $HostFile).IsReadOnly)) {
# 	Write-Output "Cannot write in host file because it is read-only."
# 	Pause
# 	Exit
# }

function WritingFailure {
	Write-Output "ERROR: Something went wrong and the script could not write in your hosts file."
	Pause
	Exit
}

# Add newline at the end of file if does not already exist
try {
	$Content = [IO.File]::ReadAllText($HostFile)
	if ($Content -NotMatch '(?<=\r\n)\z') {
		Add-Content -Value ([Environment]::NewLine) -Path $HostFile
	}
}
catch { WritingFailure }

if ($StartCounter) {
	$StartCounter = $false
}

$NumberOfLinesAfterCommentedLine = 0

foreach ($Line in (Get-Content -Path $HostFile)) {
	if ($StartCounter) {
		$NumberOfLinesAfterCommentedLine += 1
	}

	if ($Line -eq $CommentedLine) {
		$StartCounter = $true
		$NumberOfLinesAfterCommentedLine = 0
	}
}

if ($NumberOfLinesAfterCommentedLine -le $BlockedAddresses.Length) {
	$CommentedEntry = $true
}

foreach ($BlockedAddress in $BlockedAddresses) {
	$Found = Select-String -Path $HostFile -Pattern $('^' + "$LocalAddress $BlockedAddress" + '$') -CaseSensitive -Quiet
	if ($Found) {
		try {
			Write-Output "Removing from the hosts file: $LocalAddress $BlockedAddress"
			Set-Content -Value ((Select-String -Path $HostFile -Pattern $('^' + "$LocalAddress $BlockedAddress" + '$') -NotMatch -CaseSensitive).Line) -Path $HostFile
		}
		catch { WritingFailure }
	}
 else {
		Write-Output "Adding to the hosts file: $LocalAddress $BlockedAddress"
		if (!$CommentedEntry) {
			$CommentedEntry = $true
			try {
				Add-Content -Value $CommentedLine -Path $HostFile
				Add-Content -Value ([Environment]::NewLine) -Path $HostFile
			}
			catch { WritingFailure }
		}

		try {
			Add-Content -Value "$LocalAddress $BlockedAddress" -Path $HostFile
		}
		catch { WritingFailure }
	}
}

$Files = @("${Env:ProgramFiles(x86)}\Common Files\Adobe\Adobe Desktop Common\ADS\Adobe Desktop Service.exe", "$Env:ProgramFiles\Common Files\Adobe\Adobe Desktop Common\NGL\adobe_licensing_wf.exe", "$Env:ProgramFiles\Common Files\Adobe\Adobe Desktop Common\NGL\adobe_licensing_wf_helper.exe")

$IsNotBlocked = $false
$IsBlocked = $false

# Check if files are already blocked
foreach ($File in $Files) {
	$Exists = Test-Path -Path $File -PathType Leaf
	if ($Exists) {
		(Get-Acl $File).Access | ForEach-Object {
			if (Get-NetFirewallRule -DisplayName "CCStopper-InternetBlock" -ErrorAction SilentlyContinue) {
				$IsBlocked = $true
			}
			else {
				$IsNotBlocked = $true
			}
		}
	}
}

foreach ($File in $Files) {
	if ((Test-Path -Path $File -PathType Leaf)) {
		if ($IsBlocked) {
			Remove-NetFirewallRule -DisplayName "CCStopper-InternetBlock"
		}
		elseif ($IsNotBlocked) {
			New-NetFirewallRule -DisplayName "CCStopper-InternetBlock" -Direction Outbound -Program $File -Action Block
		}
	}
}

ShowMenu -Back -Subtitles "InternetBlock Module" if ($IsBlocked) { -Header "Unblocked internet!" } elseif ($IsNotBlocked) { -Header "Blocked internet!" }