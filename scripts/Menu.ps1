if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
	Start-Process -FilePath $((Get-Process -Id $PID).Path) -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`" `"$($MyInvocation.MyCommand.UnboundArguments)`""
	Exit
}
Set-Location $PSScriptRoot

$Host.UI.RawUI.WindowTitle = "CCStopper"
# Set-ConsoleWindow -Width 73 -Height 42
Import-Module .\Functions.ps1

function MainMenu {
	Do {
		# Thanks https://github.com/massgravel/Microsoft-Activation-Scripts for the UI
		Clear-Host
		Write-Output "`n"
		Write-Output "`n"
		Write-Output "           _______________________________________________________________________________"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|                                   CCSTOPPER                                   `|"
		Write-Output "          `|                                Made by eaaasun                                `|"
		Write-Output "          `|                                v1.2.0-pre.2_dev                               `|"
		Write-Output "          `|      ___________________________________________________________________      `|"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|                                SAVE YOUR FILES!                               `|"
		Write-Output "          `|      ___________________________________________________________________      `|"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|      [1] Stop Processes    `|  Stops all Adobe Processes.                      `|"
		Write-Output "          `|                            `|                                                  `|"
		Write-Output "          `|      [2] Utilities Menu    `|  Disable auto start, hide Creative Cloud         `|"
		Write-Output "          `|                            `|  folder, block unnecessary background            `|"
		Write-Output "          `|                            `|  processes and internet access (fixes            `|"
		Write-Output "          `|                            `|  credit card prompt).                            `|"
		Write-Output "          `|                            `|                                                  `|"
		Write-Output "          `|      [3] Patches Menu      `|  Patch: Genuine Checker, Trial Banner,           `|"
		Write-Output "          `|                            `|  Acrobat                                         `|"
		Write-Output "          `|                            `|                                                  `|"
		Write-Output "          `|      [4] Credit/Repo       `|  Credits, Github Repo                            `|"
		Write-Output "          `|      _________________________________________________________________        `|"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|      [Q] Exit                                                                 `|"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|_______________________________________________________________________________`|"
		Write-Output "`n"
		ReadKey 4
		Switch ($Choice) {
			Q { Exit }
			D1 {
				.\StopProcesses.ps1
				MainMenu
			}
			D2 {
				UtilityMenu
			}
			D3 {
				PatchesMenu
			}
			D4 {
				CreditMenu
			}
			Default {
				$Invalid = $true
				
			}
		}
	} Until (!($Invalid))
}

function UtilityMenu {
	Do {
		Clear-Host
		Write-Output "`n"
		Write-Output "`n"
		Write-Output "           _______________________________________________________________________________"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|                                   CCSTOPPER                                   `|"
		Write-Output "          `|      ___________________________________________________________________      `|"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|                                   UTILITIES                                   `|"
		Write-Output "          `|      ___________________________________________________________________      `|"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|      [1] Disable Autostart `|  Prevents Adobe services or processes from       `|"
		Write-Output "          `|                            `|  starting automatically.                         `|"
		Write-Output "          `|                            `|                                                  `|"
		Write-Output "          `|      [2] Hide CC Folder    `|  Hides Creative Cloud folder in Windows          `|"
		Write-Output "          `|                            `|  Explorer.                                       `|"
		Write-Output "          `|                            `|                                                  `|"
		Write-Output "          `|      [3] Block Processes   `|  Blocks unnecessary Adobe process files to       `|"
		Write-Output "          `|                            `|  prevent them from ever starting.                `|"
		Write-Output "          `|                            `|                                                  `|"
		Write-Output "          `|      [4] Internet Block    `|  Blocks Adobe servers and the credit card        `|"
		Write-Output "          `|                            `|  prompt from accessing the internet.             `|"
		Write-Output "          `|                            `|  Core functionality should be unaffected.        `|"
		Write-Output "          `|      _________________________________________________________________        `|"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|      [Q] Back                                                                 `|"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|_______________________________________________________________________________`|"
		Write-Output "`n"
		ReadKey 4
		Switch ($Choice) {
			Q { MainMenu }
			D1 {
				.\DisableAutoStart.ps1
				UtilityMenu
			}
			D2 {
				.\HideCCFolder.ps1
				UtilityMenu
			}
			D3 {
				.\BlockProcesses.ps1
				UtilityMenu
			}
			D4 {
				.\InternetBlock.ps1
				UtilityMenu
			}
			Default {
				$Invalid = $true
				
			}
		}
	} Until (!($Invalid))
}

function PatchesMenu {
	Do {
		Clear-Host
		Write-Output "`n"
		Write-Output "`n"
		Write-Output "           _______________________________________________________________________________"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|                                   CCSTOPPER                                   `|"
		Write-Output "          `|      ___________________________________________________________________      `|"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|                                    PATCHES                                    `|"
		Write-Output "          `|      ___________________________________________________________________      `|"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|      [1] Genuine Checker   `|  Deletes and locks the Genuine Checker           `|"
		Write-Output "          `|                            `|  folder.                                         `|"
		Write-Output "          `|                            `|                                                  `|"
		Write-Output "          `|      [2] Trial Banner      `|  Removes the trial banner found in apps.         `|"
		Write-Output "          `|                            `|                                                  `|"
		Write-Output "          `|      [3] Acrobat           `|  Edits registry to patch Acrobat. NOTE:          `|"
		Write-Output "          `|                            `|  stop Adobe Processes, patch genuine             `|"
		Write-Output "          `|                            `|  checker, and patch Acrobat with genP            `|"
		Write-Output "          `|                            `|  before running this patch.                      `|"
		Write-Output "          `|      _________________________________________________________________        `|"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|      [Q] Back                                                                 `|"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|_______________________________________________________________________________`|"
		Write-Output "`n"
		ReadKey 3
		Switch ($Choice) {
			Q { MainMenu }
			D1 {
				.\RemoveAGS.ps1
				PatchesMenu
			}
			D2 {
				.\HideTrialBanner.ps1
				PatchesMenu
			}
			D3 {
				.\AcrobatPatch.ps1
				PatchesMenu
			}
			Default {
				$Invalid = $true
				
			}
		}
	} Until (!($Invalid))
}

function CreditMenu {
	Do {
		Clear-Host
		Write-Output "`n"
		Write-Output "`n"
		Write-Output "           _______________________________________________________________________________"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|                                    CCSTOPPER                                  `|"
		Write-Output "          `|      ___________________________________________________________________      `|"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|                                     CREDITS                                   `|"
		Write-Output "          `|      ___________________________________________________________________      `|"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|      None of this could have been possible without the people                 `|"
		Write-Output "          `|      contributing to, testing, and supporting this script.                    `|"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|      @eaaasun              `|  Creator/maintainer                              `|"
		Write-Output "          `|                            `|                                                  `|"
		Write-Output "          `|      @ItsProfessional      `|  Contributor                                     `|"
		Write-Output "          `|      @shdevnull            `|                                                  `|"
		Write-Output "          `|      @ZEN1X                `|                                                  `|"
		Write-Output "          `|                            `|                                                  `|"
		Write-Output "          `|      GenP Discord/Reddit   `|  Patch information and development help.         `|"
		Write-Output "          `|                            `|                                                  `|"
		Write-Output "          `|      You!                  `|  Reporting bugs and supporting the               `|"
		Write-Output "          `|                            `|  project!                                        `|"
		Write-Output "          `|      _________________________________________________________________        `|"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|      [1] Github Repo                                                          `|"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|      [Q] Back                                                                 `|"
		Write-Output "          `|                                                                               `|"
		Write-Output "          `|_______________________________________________________________________________`|"
		Write-Output "`n"
		ReadKey 1
		Switch ($Choice) {
			Q { MainMenu }
			D1 {
				Start-Process "https://github.com/eaaasun/CCStopper"
				CreditMenu
			}
			Default {
				$Invalid = $true
				
			}
		}
	} Until (!($Invalid))
}

MainMenu