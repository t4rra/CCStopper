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
						Name        = "Credit Card Trial"
						Description = "Patches credit card trial popup through Windows firewall."
						Code        = { .\CreditCardBlock.ps1 }
					},
					@{
						Name        = "Add to Hosts"
						Description = "Blocks unnessesary Adobe servers in the hosts file."
						Code        = { .\HostBlock.ps1 }
					}
				)
			
			}
		},
		@{
			Name        = "System Patches"
			Description = ""
			Code        = { 
				ShowMenu -Back -VerCredit -Header "SYSTEM PATCHES" -Description "Run modules again to remove patches." -Options @(
					@{
						Name        = "Genuine Checker"
						Description = "Deletes and locks the Genuine Checker folder."
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
			Name        = "Credit/Repo"
			Description = "Credits, Github Repo"
			Code        = { 
				ShowMenu -Back -Header "CREDITS" -Description "This project would be impossible without the people contributing to, testing, and supporting it.",
				"",
				"Creator/maintainer:",
				"@eaaasun",
				"",
				"Contributors:",
				"@ItsProfessional, @shdevnull, @ZEN1X",
				"",
				"Reporting bugs, supporting the project:",
				"You!" -Options @(
					@{
						Name = "Github Repo"
						Code = {
							Start-Process "https://github.com/eaaasun/CCStopper"
							Pause
						}
					}
				)			
			}
		}
	)
}

MainMenu