Import-Module $PSScriptRoot\Functions.ps1
Init -Title $Version

function MainMenu {
	Init -Title $Version
	ShowMenu -VerCredit -Header "SAVE YOUR FILES!" -Options @(
		@{
			Name        = "Stop Processes"
			Description = "Stops all Adobe Processes"
			Code        = {
				.\StopProcesses.ps1
				MainMenu
			}
		},
		@{
			Name        = "Internet Patches"
			Description = "Credit card/hosts patches"
			Code        = { 
				ShowMenu -Back -VerCredit -Header "INTERNET PATCHES" -Description "Run modules again to remove patches." -Options @(
					@{
						Name        = "Firewall Trial"
						Description = "Patches credit card trial popup through Windows firewall."
						Code        = { .\FirewallBlock.ps1 }
					},
					@{
						Name        = "Add to Hosts"
						Description = "Blocks unnecessary Adobe servers in the hosts file."
						Code        = { .\HostBlock.ps1 }
					}
				)
			
			}
		},
		@{
			Name        = "System Patches"
			Description = "Genuine checker and hide CC folder in explorer"
			Code        = { 
				ShowMenu -Back -VerCredit -Header "SYSTEM PATCHES" -Description "Run modules again to remove patches." -Options @(
					@{
						Name        = "Genuine Checker"
						Description = "Replaces and locks the Genuine Checker folder."
						Code        = { .\RemoveAGS.ps1 }
					},
					@{
						Name        = "Hide CC Folder"
						Description = "Hides Creative Cloud folder in Windows Explorer."
						Code        = { .\HideCCFolder.ps1 }
					}
				)
			
			}
		},
		@{
			Name        = "Other"
			Description = "Check For Updates, Credits/Github Repo"
			Code        = { 
				ShowMenu -Back -Header "CREDITS" -Description "This project would be impossible without the people contributing to, testing, and supporting it.",
				"",
				"Creator/maintainer: @eaaasun",
				"",
				"Contributors:",
				"@ItsProfessional, @shdevnull, @ZEN1X",
				"",
				"Reporting bugs, supporting the project: You!" -Options @(
					@{
						Name = "Check/Apply Updates"
						Description = "Checks for and applies updates to CCStopper."
						Code = { .\Updater.ps1 }
					},
					@{
						Name = "Github Repo"
						Code = {
							Start-Process "https://github.com/eaaasun/CCStopper"
							MainMenu
						}
					}
				)			
			}
		}
	)
}

MainMenu