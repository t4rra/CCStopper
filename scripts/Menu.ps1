if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
	Start-Process -FilePath PowerShell -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`" `"$($MyInvocation.MyCommand.UnboundArguments)`""
	Exit
}
Set-Location $PSScriptRoot

function Set-ConsoleWindow([int]$Width, [int]$Height) {
	$WindowSize = $Host.UI.RawUI.WindowSize
	$WindowSize.Width = [Math]::Min($Width, $Host.UI.RawUI.BufferSize.Width)
	$WindowSize.Height = $Height

	try {
		$Host.UI.RawUI.WindowSize = $WindowSize
	} catch [System.Management.Automation.SetValueInvocationException] {
		$MaxValue = ($_.Exception.Message | Select-String "\d+").Matches[0].Value
		$WindowSize.Height = $MaxValue
		$Host.UI.RawUI.WindowSize = $WindowSize
	}
}

$Host.UI.RawUI.WindowTitle = "CCStopper"
# Set-ConsoleWindow -Width 73 -Height 42

function MainMenu {
	# Thanks https://github.com/massgravel/Microsoft-Activation-Scripts for the UI
	Clear-Host
	Write-Host "`n"
	Write-Host "`n"
	Write-Host "           _______________________________________________________________________________"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|                                   CCSTOPPER                                   `|"
	Write-Host "          `|                                Made by eaaasun                                `|"
	Write-Host "          `|                                 v1.2.0-pre.1                                  `|"
	Write-Host "          `|      ___________________________________________________________________      `|"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|                                SAVE YOUR FILES!                               `|"
	Write-Host "          `|      ___________________________________________________________________      `|"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|      [1] Stop Processes    `|  Stops all Adobe Processes.                      `|"
	Write-Host "          `|                            `|                                                  `|"
	Write-Host "          `|      [2] Utilities Menu    `|  Disable auto start, hide Creative Cloud         `|"
	Write-Host "          `|                            `|  folder, block unnecessary background            `|"
	Write-Host "          `|                            `|  processes and internet access (fixes            `|"
	Write-Host "          `|                            `|  credit card prompt).                            `|"
	Write-Host "          `|                            `|                                                  `|"
	Write-Host "          `|      [3] Patches Menu      `|  Patch: Genuine Checker, Trial Banner,           `|"
	Write-Host "          `|                            `|  Acrobat                                         `|"
	Write-Host "          `|                            `|                                                  `|"
	Write-Host "          `|      [4] Credit/Repo       `|  Credits, Github Repo                            `|"
	Write-Host "          `|      _________________________________________________________________        `|"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|      [Q] Exit                                                                 `|"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|_______________________________________________________________________________`|"
	Write-Host "`n"
	$Choice = Read-Host ">                                      Select [1,2,3,4,Q]"
	Clear-Host
	Switch($Choice) {
		Q { Exit }
		1 {
			.\StopProcesses.ps1
			MainMenu
		}
		2 { UtilityMenu }
		3 { PatchesMenu }
		4 { CreditMenu }
	}
}

function UtilityMenu {
	Clear-Host
	Write-Host "`n"
	Write-Host "`n"
	Write-Host "           _______________________________________________________________________________"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|                                   CCSTOPPER                                   `|"
	Write-Host "          `|      ___________________________________________________________________      `|"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|                                   UTILITIES                                   `|"
	Write-Host "          `|      ___________________________________________________________________      `|"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|      [1] Disable Autostart `|  Prevents Adobe services or processes from       `|"
	Write-Host "          `|                            `|  starting automatically.                         `|"
	Write-Host "          `|                            `|                                                  `|"
	Write-Host "          `|      [2] Hide CC Folder    `|  Hides Creative Cloud folder in Windows          `|"
	Write-Host "          `|                            `|  Explorer.                                       `|"
	Write-Host "          `|                            `|                                                  `|"
	Write-Host "          `|      [3] Block Processes   `|  Blocks unnecessary Adobe process files to       `|"
	Write-Host "          `|                            `|  prevent them from ever starting.                `|"
	Write-Host "          `|                            `|                                                  `|"
	Write-Host "          `|      [4] Internet Block    `|  Blocks Adobe servers and the credit card        `|"
	Write-Host "          `|                            `|  prompt from accessing the internet.             `|"
	Write-Host "          `|                            `|  Core functionality should be unaffected.        `|"
	Write-Host "          `|      _________________________________________________________________        `|"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|      [Q] Back                                                                 `|"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|_______________________________________________________________________________`|"
	Write-Host "`n"
	$Choice = Read-Host ">                                      Select [1,2,3,4,Q]"
	Clear-Host
	Switch($Choice) {
		Q { MainMenu }
		1 {
			.\DisableAutoStart.ps1
			UtilityMenu
		}
		2 {
			.\HideCCFolder.ps1
			UtilityMenu
		}
		3 {
			.\BlockProcesses.ps1
			UtilityMenu
		}
		4 {
			cmd /k .\InternetBlock.bat
			UtilityMenu
		}
	}
}

function PatchesMenu {
	Clear-Host
	Write-Host "`n"
	Write-Host "`n"
	Write-Host "           _______________________________________________________________________________"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|                                   CCSTOPPER                                   `|"
	Write-Host "          `|      ___________________________________________________________________      `|"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|                                    PATCHES                                    `|"
	Write-Host "          `|      ___________________________________________________________________      `|"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|      [1] Genuine Checker   `|  Deletes and locks the Genuine Checker           `|"
	Write-Host "          `|                            `|  folder.                                         `|"
	Write-Host "          `|                            `|                                                  `|"
	Write-Host "          `|      [2] Trial Banner      `|  Removes the trial banner found in apps.         `|"
	Write-Host "          `|                            `|                                                  `|"
	Write-Host "          `|      [3] Acrobat           `|  Edits registry to patch Acrobat. NOTE:          `|"
	Write-Host "          `|                            `|  stop Adobe Processes, patch genuine             `|"
	Write-Host "          `|                            `|  checker, and patch Acrobat with genP            `|"
	Write-Host "          `|                            `|  before running this patch.                      `|"
	Write-Host "          `|      _________________________________________________________________        `|"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|      [Q] Back                                                                 `|"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|_______________________________________________________________________________`|"
	Write-Host "`n"
	$Choice = Read-Host ">                                      Select [1,2,3,Q]"
	Clear-Host
	Switch($Choice) {
		Q { MainMenu }
		1 {
			.\RemoveAGS.ps1
			UtilityMenu
		}
		2 {
			.\HideTrialBanner.ps1
			UtilityMenu
		}
		3 {
			.\AcrobatFix.ps1
			UtilityMenu
		}
		4 {
			.\InternetBlock.ps1
			UtilityMenu
		}
	}
}

function CreditMenu {
	Clear-Host
	Write-Host "`n"
	Write-Host "`n"
	Write-Host "           _______________________________________________________________________________"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|                                    CCSTOPPER                                  `|"
	Write-Host "          `|      ___________________________________________________________________      `|"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|                                     CREDITS                                   `|"
	Write-Host "          `|      ___________________________________________________________________      `|"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|      None of this could have been possible without the people                 `|"
	Write-Host "          `|      contributing to, testing, and supporting this script.                    `|"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|      @eaaasun              `|  Creator/maintainer                              `|"
	Write-Host "          `|                            `|                                                  `|"
	Write-Host "          `|      @ItsProfessional      `|  Contributor                                     `|"
	Write-Host "          `|      @shdevnull            `|                                                  `|"
	Write-Host "          `|      @ZEN1X                `|                                                  `|"
	Write-Host "          `|                            `|                                                  `|"
	Write-Host "          `|      GenP Discord/Reddit   `|  Patch information and development help.         `|"
	Write-Host "          `|                            `|                                                  `|"
	Write-Host "          `|      You!                  `|  Reporting bugs and supporting the               `|"
	Write-Host "          `|                            `|  project!                                        `|"
	Write-Host "          `|      _________________________________________________________________        `|"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|      [1] Github Repo                                                          `|"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|      [Q] Back                                                                 `|"
	Write-Host "          `|                                                                               `|"
	Write-Host "          `|_______________________________________________________________________________`|"
	Write-Host "`n"
	$Choice = Read-Host ">                                      Select [1,Q]"
	Clear-Host
	Switch($Choice) {
		Q { MainMenu }
		1 {
			Start-Process "https://github.com/eaaasun/CCStopper"
			CreditMenu
		}
	}
}

MainMenu