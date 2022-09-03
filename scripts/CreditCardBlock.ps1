Import-Module $PSScriptRoot\Functions.ps1
Init -Title "Credit Card Prompt Block"

$Files = @(
	@{
		Path  = "${Env:ProgramFiles(x86)}\Common Files\Adobe\Adobe Desktop Common\ADS\Adobe Desktop Service.exe"
		Check = $False
	},
	@{ 
		Path  = "$Env:ProgramFiles\Common Files\Adobe\Adobe Desktop Common\NGL\adobe_licensing_wf.exe"
		Check = $False
	},
	@{
		Path  = "$Env:ProgramFiles\Common Files\Adobe\Adobe Desktop Common\NGL\adobe_licensing_wf_helper.exe"
		Check = $False
	})

# run checks for file
foreach ($File in $Files) {
	$FirewallRuleName = "CCStopper-InternetBlock_$($Files.IndexOf($File))"
	if (Test-Path $File.Path) {
		# file exists
		Get-NetFirewallRule -DisplayName $FirewallRuleName -ErrorAction SilentlyContinue
		if ($?) {
			# firewall rule exists
			$File.Check = $True
		}
		else {
			# firewall rule does not exist, but file does
			$File.Check = "file"
		}
	}
 else {
		# file does not exist
		$File.Check = $False
	}
}

function FirewallAction([switch]$Remove) {
	foreach ($File in $Files) {
		$FirewallRuleName = "CCStopper-InternetBlock_$($Files.IndexOf($File))"
		if ($File.Check -and $Remove) {
			# if file and firewall rule exist, and if remove flag is true, remove firewall rule
			Remove-NetFirewallRule -DisplayName $FirewallRuleName
			exit
		}
		elseif ($File.Check) {
			ShowMenu -Back -Subtitles "InternetBlock Module" -Header "Firewall Rules Already Set!" -Description "Would you like to remove all existing rules?" -Options @(
				@{
					Name = "Remove Rules"
					Code = {
						FirewallAction -Remove
					}
				}
			)
		}
		elseif (!($File.Check)) {
			ShowMenu -Back -Subtitles "InternetBlock Module" -Header "Error! File not found!" -Description "Target files could not be found. If the trial prompts are still displayed, please open an issue on the Github repo."
		}
		elseif ($File.Check -eq "file") {
			# if file exists but no firewall rule, create firewall rule
			New-NetFirewallRule -DisplayName $FirewallRuleName -Direction Outbound -Program $File.Path -Action Block
		}
	}
	# end menus
	write-host "the end"
	Pause
	exit
}

FirewallAction

# ShowMenu -Back -Subtitles "InternetBlock Module" -Header $HeaderMSG

# ShowMenu -Back -Subtitles "InternetBlock Module" if ($IsBlocked) { -Header "Unblocked internet!" } elseif ($IsNotBlocked) { -Header "Blocked internet!" }