Import-Module $PSScriptRoot\Functions.ps1
Import-Module $PSScriptRoot\data\Firewall.ps1

Init -Title "Firewall Block"

# run checks for file
foreach ($File in $Files) {
	$FirewallRuleName = "CCStopper-InternetBlock_$($Files.IndexOf($File))"
	if (Test-Path $File.Path) {
		# file exists
		Get-NetFirewallRule -DisplayName $FirewallRuleName -ErrorAction SilentlyContinue
		if ($?) {
			# Firewall rule exists
			$File.Check = $True
		}
		else {
			# Firewall rule does not exist; file exists
			$File.Check = "file"
		}
	}
 else {
		# File does not exist
		$File.Check = $False
	}
}

function FirewallAction([switch]$Remove) {
	$EndHeaderMSG = $Null
	foreach ($File in $Files) {
		$FirewallRuleName = "CCStopper-InternetBlock_$($Files.IndexOf($File))"
		switch ($File.Check) {
			$True {
				if ($Remove) {
					# If file and firewall rule exist, and if remove flag is true, remove firewall rule
					Remove-NetFirewallRule -DisplayName $FirewallRuleName
					$EndHeaderMSG = "Firewall rules removed!"
				} else {
					ShowMenu -Back -Subtitles "InternetBlock Module" -Header "Firewall Rules Already Set!" -Description "Would you like to remove all existing rules?" -Options @(
						@{
							Name = "Remove Rules"
							Code = { FirewallAction -Remove }
						}
					)
				}
			}
			"file" {
				# If file exists; Firewall rule does not exist, create firewall rule
				try {
					New-NetFirewallRule -DisplayName $FirewallRuleName -Direction Outbound -Program $File.Path -Action Block
				} catch {
					ShowMenu -Back -Subtitles "InternetBlock Module" -Header "Error! Creating firewall rule failed!" -Description "Antivirus programs are known to interfere with this patch. Please check if that is the case, and try again."
				}
				$EndHeaderMSG = "Firewall rules created!"
			}
			$False {
				ShowMenu -Back -Subtitles "InternetBlock Module" -Header "Error! File not found!" -Description "Target files could not be found. If the trial prompts are still displayed, please open an issue on the Github repo."
			}
		}
	}
	ShowMenu -Back -Subtitles "InternetBlock Module" -Header $EndHeaderMSG -Description "Operation has been completed successfully."
}

FirewallAction