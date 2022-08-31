Import-Module $PSScriptRoot\Functions.ps1
Init -Title "Credit Card Prompt Block"

$Files = @("${Env:ProgramFiles(x86)}\Common Files\Adobe\Adobe Desktop Common\ADS\Adobe Desktop Service.exe", "$Env:ProgramFiles\Common Files\Adobe\Adobe Desktop Common\NGL\adobe_licensing_wf.exe", "$Env:ProgramFiles\Common Files\Adobe\Adobxe Desktop Common\NGL\adobe_licensing_wf_helper.exe")

# run checks for file
function CheckFile($FileChecked) {
	# check if file and corresponding firewall rule exist, if not return false
	if (Test-Path $FileChecked -PathType Leaf) {
		if (Get-NetFirewallRule -DisplayName $FirewallRuleName -ErrorAction SilentlyContinue) {
			write-host "File $FileChecked exists and firewall rule exists"
			pause
			return $True
		}
		else {
			write-host "File $FileChecked exists but firewall rule does not"
			pause
			return "file"
		}
	}
 else {
		write-host "nothing exists lol"
		pause
		return $False
	}	
}


function FirewallAction([switch]$Remove) {
	foreach ($File in $Files) {
		$FirewallRuleName = "CCStopper-InternetBlock_$($Files.IndexOf($File))"
		if (CheckFile $File -and $Remove) {
			# if file and firewall rule exist, and if remove flag is true, remove firewall rule
			Remove-NetFirewallRule -DisplayName $FirewallRuleName
			break
		}
		elseif (CheckFile $File) {
			ShowMenu -Back -Subtitles "InternetBlock Module" -Header "Firewall Rules Already Set!" -Description "Would you like to remove all existing rules?" -Options @(
				@{
					Name = "Remove Rules"
					Code = {
						FirewallAction -Remove
					}
				}
			)
		}
		elseif (CheckFile $File -eq "file") {
			write-host "we back in da firewall action function about to add the rule"
			pause
			# if file exists but no firewall rule, create firewall rule
			New-NetFirewallRule -DisplayName $FirewallRuleName -Direction Outbound -Program $File -Action Block
		}
		elseif (!(CheckFile $File)) {
			ShowMenu -Back -Subtitles "InternetBlock Module" -Header "Error! File not found!" -Description "Target files could not be found. If the trial prompts are still displayed, please open an issue on the Github repo."
		}
	}
	# end menus

}

FirewallAction

# ShowMenu -Back -Subtitles "InternetBlock Module" -Header $HeaderMSG

# ShowMenu -Back -Subtitles "InternetBlock Module" if ($IsBlocked) { -Header "Unblocked internet!" } elseif ($IsNotBlocked) { -Header "Blocked internet!" }