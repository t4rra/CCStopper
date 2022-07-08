Import-Module .\Functions.ps1
Init -Title $Version
# Set-ConsoleWindow -Width 73 -Height 42

function MainMenu {
	ShowMenu -VerCredit -Header "SAVE YOUR FILES!" -Options @(
		@{
			Name = "Stop Processes"
			Description = "Stops all Adobe Processes"
			Code = {
				.\StopProcesses.ps1
				MainMenu
			}
		},
		@{
			Name = "Utilities Menu"
			Description = "Disable autostart, hide Creative Cloud folder, block unnessessary background processes and internet access (fixes credit card prompt)."
			Code = {
				UtilityMenu
			}
		},
		@{
			Name = "Patches Menu"
			Description = "Patch: Genuine Checker, Trial Banner, Acrobat"
			Code = {
				PatchesMenu
			}
		},
		@{
			Name = "Credit/Repo"
			Description = "Credits, Github Repo"
			Code = {
				CreditMenu
			}
		}
	)
}

function UtilityMenu {
	ShowMenu -Back -Header "UTILITIES" -Options @(
		@{
			Name = "Internet Block"
			Description = "Blocks Adobe apps from accessing the internet and credit card prompt. All functionality should be unaffected."
			Code = {
				.\InternetBlock.ps1
			}
		},
		@{
			Name = "Hide CC Folder"
			Description = "Hide Creative Cloud folder in Windows Explorer."
			Code = {
				.\HideCCFolder.ps1
			}
		},
		@{
			Name = "Disable Autostart"
			Description = "Prevent Adobe serivces/processes from starting on boot."
			Code = {
				.\DisableAutostart.ps1
			}
		},
		@{
			Name = "Block Processes"
			Description = "Block unnecessary Adobe process files from launching."
			Code = {
			}
		}
	)
}

function PatchesMenu {
	ShowMenu -Back -Header "PATCHES" -Options @(
		@{
			Name = "Genuine Checker"
			Description = "Deletes and locks the Genuine Checker folder."
			Code = {
				.\RemoveAGS.ps1
			}
		},
	@{
			Name = "Trial Banner"
			Description = "Removes the trial banner found in apps."
			Code = {
				.\HideTrialBanner.ps1
			}
		},
		@{
			Name = "Acrobat"
			Description = "Edits registry to patch Acrobat. NOTE: stop Adobe Processes, patch genuine checker, and patch Acrobat with genP before running this patch."
			Code = {
				.\AcrobatPatch.ps1
			}
		}
	)
}

function CreditMenu {
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
				pause
			}
		}
	)
	# Do {
	# 	Clear-Host
	# 	Write-Output "`n"
	# 	Write-Output "`n"
	# 	Write-Output "           _______________________________________________________________________________"
	# 	Write-Output "          `|                                                                               `|"
	# 	Write-Output "          `|                                                                               `|"
	# 	Write-Output "          `|                                    CCSTOPPER                                  `|"
	# 	Write-Output "          `|      ___________________________________________________________________      `|"
	# 	Write-Output "          `|                                                                               `|"
	# 	Write-Output "          `|                                     CREDITS                                   `|"
	# 	Write-Output "          `|      ___________________________________________________________________      `|"
	# 	Write-Output "          `|                                                                               `|"
	# 	Write-Output "          `|      None of this could have been possible without the people                 `|"
	# 	Write-Output "          `|      contributing to, testing, and supporting this script.                    `|"
	# 	Write-Output "          `|                                                                               `|"
	# 	Write-Output "          `|      @eaaasun              `|  Creator/maintainer                              `|"
	# 	Write-Output "          `|                            `|                                                  `|"
	# 	Write-Output "          `|      @ItsProfessional      `|  Contributor                                     `|"
	# 	Write-Output "          `|      @shdevnull            `|                                                  `|"
	# 	Write-Output "          `|      @ZEN1X                `|                                                  `|"
	# 	Write-Output "          `|                            `|                                                  `|"
	# 	Write-Output "          `|      GenP Discord/Reddit   `|  Patch information and development help.         `|"
	# 	Write-Output "          `|                            `|                                                  `|"
	# 	Write-Output "          `|      You!                  `|  Reporting bugs and supporting the               `|"
	# 	Write-Output "          `|                            `|  project!                                        `|"
	# 	Write-Output "          `|      _________________________________________________________________        `|"
	# 	Write-Output "          `|                                                                               `|"
	# 	Write-Output "          `|      [1] Github Repo                                                          `|"
	# 	Write-Output "          `|                                                                               `|"
	# 	Write-Output "          `|      [Q] Back                                                                 `|"
	# 	Write-Output "          `|                                                                               `|"
	# 	Write-Output "          `|_______________________________________________________________________________`|"
	# 	Write-Output "`n"
	# 	ReadKey 1
	# 	Switch ($Choice) {
	# 		Q { MainMenu }
	# 		D1 {
	# 			Start-Process "https://github.com/eaaasun/CCStopper"
	# 			CreditMenu
	# 		}
	# 		Default {
	# 			$Invalid = $true
	# 		}
	# 	}
	# } Until (!($Invalid))
}

MainMenu