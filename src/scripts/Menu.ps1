Import-Module $PSScriptRoot\Functions.ps1
Init -Title $Version

function MainMenu {
	Init -Title $Version
	ShowMenu -VerCredit -Header "Main Menu" -Description "Run modules again to revert their changes. Please report bugs in the GitHub repo." -Options @(
		@{
			Name        = "Stop Processes"
			Description = "Stops all Adobe Processes"
			Code        = {
				.\StopProcesses.ps1
				MainMenu
			}
		},
		@{
			Name        = "Add to Hosts"
			Description = "Blocks unnecessary Adobe servers in the hosts file"
			Code        = { 
				.\HostBlock.ps1			
			}
		},
		@{
			Name        = "System Patches"
			Description = "CC App Buttons/Genuine Checker/CC Folder"
			Code        = { 
				ShowMenu -Back -VerCredit -Header "SYSTEM PATCHES" -Description "Run modules again to revert their changes. Please report bugs in the GitHub repo." -Options @(
					@{
						Name        = "Creative Cloud App"
						Description = "Fixes 'start trial' button in the CC app. Restart your system if changes don't apply."
						Code        = { .\CCApp.ps1 }
					},
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
			Description = "Credits/Github Repo"
			Code        = { 
				ShowMenu -Back -VerCredit -Header "CREDITS" -Description "Big thanks to all the contributors and users!",
				"",
				"Creator: @eaaasun",
				"",
				"Contributors:",
				"@ItsProfessional, @shdevnull, @ZEN1X",
				"",
				"Reporting bugs, supporting the project: You!" -Options @(
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