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
			Name        = "Utilities Menu"
			Description = "Disable autostart, hide Creative Cloud folder, block unnessessary background processes and internet access (fixes credit card prompt)."
			Code        = { UtilityMenu }
		},
		@{
			Name        = "Patches Menu"
			Description = "Patch: Genuine Checker, Trial Banner, Acrobat"
			Code        = { PatchesMenu }
		},
		@{
			Name        = "Credit/Repo"
			Description = "Credits, Github Repo"
			Code        = { CreditMenu }
		}
	)
}

function UtilityMenu {
	ShowMenu -Back -Header "UTILITIES" -Options @(
		@{
			Name        = "Host Block"
			Description = "Blocks unnessesary Adobe apps from accessing the internet."
			Code        = { .\HostBlock.ps1 }
		},
		@{
			Name        = "Hide CC Folder"
			Description = "Hide Creative Cloud folder in Windows Explorer."
			Code        = { .\HideCCFolder.ps1 }
		},
		@{
			Name        = "Disable Autostart"
			Description = "Prevent Adobe serivces/processes from starting on boot."
			Code        = { .\DisableAutostart.ps1 }
		},
		@{
			Name        = "Block Processes"
			Description = "Block unnecessary Adobe process files from launching."
			Code        = { .\BlockProcesses.ps1 }
		}
	)
}

function PatchesMenu {
	ShowMenu -Back -Header "PATCHES" -Options @(
		@{
			Name        = "Genuine Checker"
			Description = "Deletes and locks the Genuine Checker folder."
			Code        = { .\RemoveAGS.ps1 }
		},
		@{
			Name        = "Credit Card Trial Block"
			Description = "Patches credit card trial popup."
			Code        = { .\CreditCardBlock.ps1 }
		},
		@{
			Name        = "Trial Banner"
			Description = "Removes the trial banner found in apps."
			Code        = { .\HideTrialBanner.ps1 }
		},
		@{
			Name        = "Acrobat"
			Description = "Edits registry to patch Acrobat. NOTE: stop Adobe Processes, patch genuine checker, and patch Acrobat with genP before running this patch."
			Code        = { .\AcrobatPatch.ps1 }
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
				Pause
			}
		}
	)
}

MainMenu