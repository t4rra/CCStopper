Import-Module $PSScriptRoot\Functions.ps1
Init -Title $Version

function MainMenu {
	Init -Title $Version
	ShowMenu -VerCredit -Header "THIS IS A PRERELEASE!" -Description "Things may be broken! Please report any bugs in the Github repo." -Options @(
		@{
			Name        = "Stop Processes"
			Description = "Stops all Adobe Processes"
			Code        = {
				.\StopProcesses.ps1
				MainMenu
			}
		},
		@{
			Name        = "Hosts Patch"
			Description = "Blocks unnecessary Adobe servers in the hosts file"
			Code        = { 
				.\HostBlock.ps1			
			}
		},
		@{
			Name        = "System Patches"
			Description = "Genuine checker and hide CC folder in explorer"
			Code        = { 
				ShowMenu -Back -VerCredit -Header "SYSTEM PATCHES" -Description "Run modules again to remove patches." -Options @(
					@{
						Name        = "Creative Cloud App"
						Description = "Replaces the 'start trial' button in the Creative Cloud app. WILL CLOSE ALL ADOBE PROCESSES."
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
				ShowMenu -Back -VerCredit -Header "CREDITS" -Description "This project would be impossible without the people contributing to, testing, and supporting it.",
				"",
				"Creator/maintainer: @eaaasun",
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