Import-Module $PSScriptRoot\Functions.ps1
Init -Title "Credit Card Prompt Block"

$Files = @("${Env:ProgramFiles(x86)}\Common Files\Adobe\Adobe Desktop Common\ADS\Adobe Desktop Service.exe", "$Env:ProgramFiles\Common Files\Adobe\Adobe Desktop Common\NGL\adobe_licensing_wf.exe", "$Env:ProgramFiles\Common Files\Adobe\Adobe Desktop Common\NGL\adobe_licensing_wf_helper.exe")

$Exists = $False

function FirewallAction([switch]$Remove) {
	foreach ($File in $Files) {
		$FirewallRuleName = "CCStopper-InternetBlock_$($Files.IndexOf($File))"
		# check if file exists
		if (Test-Path -Path $File) {
			# check if firewall rule doesn't exist
			if (!(Get-NetFirewallRule -DisplayName $FirewallRuleName)) {
				# firewall rule does not exist, create it
				New-NetFirewallRule -DisplayName $FirewallRuleName -Direction Outbound -Program $File -Action Block
			}
			else {
				$Exists = $True
				# firewall rule exists, remove it if $Remove is true
				if ($Remove) {
					Remove-NetFirewallRule -DisplayName $FirewallRuleName
				}
				else {
					write-host "firewall rule for $File exists"
					write-host $Exists
				}
			}
		}
		else {
			write-host "file does not exist"
		}
	}
	if ($Exists) {
		ShowMenu -Subtitles "InetnetBlock Module" -Header "Firewall rules already exist!" -Description "Would you like to remove them?" -Options @(
			@(
				Name = "Remove Firewall Rules"
				Code = {
					FirewallAction -Remove
				}
			)
		)
	}
	else {
		ShowMenu -Subtitles "InetnetBlock Module" -Header "Firewall rules created!" -Description "Restart Adobe processes if nothing changes."
	}	
}

FirewallAction

# ShowMenu -Back -Subtitles "InternetBlock Module" -Header $HeaderMSG

# ShowMenu -Back -Subtitles "InternetBlock Module" if ($IsBlocked) { -Header "Unblocked internet!" } elseif ($IsNotBlocked) { -Header "Blocked internet!" }