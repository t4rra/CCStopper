if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
	Start-Process -FilePath PowerShell -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`" `"$($MyInvocation.MyCommand.UnboundArguments)`""
	Exit
}
Set-Location $PSScriptRoot

function Set-ConsoleWindow([int]$Width, [int]$Height) {
	$WindowSize = $Host.UI.RawUI.WindowSize
	$WindowSize.Width = [Math]::Min($Width, $Host.UI.RawUI.BufferSize.Width)
	$WindowSize.Height = $Height

	try {
		$Host.UI.RawUI.WindowSize = $WindowSize
	} catch [System.Management.Automation.SetValueInvocationException] {
		$MaxValue = ($_.Exception.Message | Select-String "\d+").Matches[0].Value
		$WindowSize.Height = $MaxValue
		$Host.UI.RawUI.WindowSize = $WindowSize
	}
}

$Host.UI.RawUI.WindowTitle = "CCStopper - Block Adobe Processes"
# Set-ConsoleWindow -Width 73 -Height 42

$CommentedLine = "`# BLOCK ADOBE"

$LocalAddress = "127.0.0.1"
$BlockedAddresses = @("ic.adobe.io", "52.6.155.20", "52.10.49.85", "23.22.30.141", "34.215.42.13", "52.84.156.37", "65.8.207.109", "3.220.11.113", "3.221.72.231", "3.216.32.253", "3.208.248.199", "3.219.243.226", "13.227.103.57", "34.192.151.90", "34.237.241.83", "44.240.189.42", "52.20.222.155", "52.208.86.132", "54.208.86.132", "63.140.38.120", "63.140.38.160", "63.140.38.169", "63.140.38.219", "wip.adobe.com", "adobeereg.com", "18.228.243.121", "18.230.164.221", "54.156.135.114", "54.221.228.134", "54.224.241.105", "100.24.211.130", "162.247.242.20", "wip1.adobe.com", "wip2.adobe.com", "wip3.adobe.com", "wip4.adobe.com", "3dns.adobe.com", "ereg.adobe.com", "199.232.114.137", "bam.nr-data.net", "practivate.adobe", "ood.opsource.net", "crl.verisign.net", "3dns-1.adobe.com", "3dns-2.adobe.com", "3dns-3.adobe.com", "3dns-4.adobe.com", "hl2rcv.adobe.com", "genuine.adobe.com", "www.adobeereg.com", "www.wip.adobe.com", "www.wip1.adobe.com", "www.wip2.adobe.com", "www.wip3.adobe.com", "www.wip4.adobe.com", "ereg.wip.adobe.com", "ereg.wip.adobe.com", "activate.adobe.com", "adobe-dns.adobe.com", "ereg.wip1.adobe.com", "ereg.wip2.adobe.com", "ereg.wip3.adobe.com", "ereg.wip4.adobe.com", "ereg.wip1.adobe.com", "ereg.wip2.adobe.com", "ereg.wip3.adobe.com", "ereg.wip4.adobe.com", "cc-api-data.adobe.io", "practivate.adobe.ntp", "practivate.adobe.ipp", "practivate.adobe.com", "adobe-dns-1.adobe.com", "adobe-dns-2.adobe.com", "adobe-dns-3.adobe.com", "adobe-dns-4.adobe.com", "lm.licenses.adobe.com", "hlrcv.stage.adobe.com", "prod.adobegenuine.com", "practivate.adobe.newoa", "activate.wip.adobe.com", "activate-sea.adobe.com", "uds.licenses.adobe.com", "k.sni.global.fastly.net", "activate-sjc0.adobe.com", "activate.wip1.adobe.com", "activate.wip2.adobe.com", "activate.wip3.adobe.com", "activate.wip4.adobe.com", "na1r.services.adobe.com", "lmlicenses.wip4.adobe.com", "na2m-pr.licenses.adobe.com", "wwis-dubc1-vip60.adobe.com", "workflow-ui-prod.licensingstack.com")
$HostFile = "$Env:SystemRoot\System32\drivers\etc\hosts"

# if(!((Get-ItemProperty $HostFile).IsReadOnly)) {
	# Write-Host Cannot write in host file because it is read-only.
	# Pause
    # Exit
# }

function WritingFailure {
	Write-Host ERROR: Something went wrong and the script could not write in your hosts file.
	Pause
	Exit
}

try {
	$Content = [IO.File]::ReadAllText($HostFile)
	if($Content -NotMatch '(?<=\r\n)\z') {
		Add-Content -Value ([Environment]::NewLine) -Path $HostFile
	} 
} catch { WritingFailure }

if(Test-Path variable:StartCounter) {
    StartCounter = ""
}

$NumberOfLinesAfterCommentedLine=0

ForEach ($Line in (Get-Content -Path $HostFile)) {
	if(Test-Path variable:StartCounter) {
		$NumberOfLinesAfterCommentedLine += 1
	}

    if($Line -eq $CommentedLine) {
		$StartCounter = 1
		$NumberOfLinesAfterCommentedLine = 0
	}
}
if($NumberOfLinesAfterCommentedLine -le $BlockedAddresses.Length) {
	$CommentedEntry = 1
}
ForEach($BlockedAddress in $BlockedAddresses) {
    Write-Host Adding to the hosts file: $LocalAddress $BlockedAddress
	$Found = Select-String -Path $HostFile -Pattern $('^' + "$LocalAddress $BlockedAddress" + '$') -CaseSensitive -Quiet
    if($Found) {
		try {
			Set-Content -Value ((Select-String -Path $HostFile -Pattern $('^' + "$LocalAddress $BlockedAddress" + '$') -NotMatch -CaseSensitive).Line) -Path "$HostFile.tmp"
		} catch { WritingFailure }
		try {
			Move-Item -Path "$HostFile.tmp" -Destination $HostFile -Force
		} catch { WritingFailure }
	}
	if(!(Test-Path variable:CommentedEntry)) {
		$CommentedEntry = 1
		try {
			Add-Content -Value $CommentedLine -Path "$HostFile"
			Add-Content -Value ([Environment]::NewLine) -Path $HostFile
		} catch { WritingFailure }
	}

	try {
		Add-Content -Value "$LocalAddress $BlockedAddress" -Path $HostFile
	} catch { WritingFailure }
}
	
if(Get-NetFirewallRule -DisplayName "CCStopper-CreditCardBlock" -ErrorAction SilentlyContinue) {
    Write-Host Firewall rule exists!
} else {
	New-NetFirewallRule -DisplayName "CCStopper-CreditCardBlock" -Direction Outbound -Program "${Env:ProgramFiles(x86)}\Common Files\Adobe\Adobe Desktop Common\ADS\Adobe Desktop Service.exe" -Action Block
}

Clear-Host
Write-Host "`n"
Write-Host "`n"
Write-Host "                   _______________________________________________________________"
Write-Host "                  `|                                                               `| "
Write-Host "                  `|                                                               `|"
Write-Host "                  `|                            CCSTOPPER                          `|"
Write-Host "                  `|                       InternetBlock Module                    `|"
Write-Host "                  `|      ___________________________________________________      `|"
Write-Host "                  `|                                                               `|"
Write-Host "                  `|                       Patching completed.                     `|"
Write-Host "                  `|      ___________________________________________________      `|"
Write-Host "                  `|                                                               `|"
Write-Host "                  `|      [Q] Exit Module                                          `|"
Write-Host "                  `|                                                               `|"
Write-Host "                  `|                                                               `|"
Write-Host "                  `|_______________________________________________________________`|"
Write-Host "`n"          
$Choice = Read-Host ">                                            Select [Q]"
Clear-Host
Switch($Choice) {
	Q { Exit }
}