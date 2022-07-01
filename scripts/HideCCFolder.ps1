if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
	Start-Process -FilePath PowerShell -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`" `"$($MyInvocation.MyCommand.UnboundArguments)`""
	Exit
}
Set-Location $PSScriptRoot
Clear-Host

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

$Sig = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
Add-Type -MemberDefinition $Sig -name NativeMethods -namespace Win32

$Host.UI.RawUI.WindowTitle = "CCStopper - Hide Creative Cloud Folder"
# Set-ConsoleWindow -Width 73 -Height 42


function Get-Subkey([String]$Key, [String]$SubkeyPattern) {
	return (Get-ChildItem $Key -Recurse | Where-Object {$_.PSChildName -Like "$SubkeyPattern"}).Name
}

function RestartAsk {
	Do {
		# Thanks https://github.com/massgravel/Microsoft-Activation-Scripts for the UI
		Clear-Host
		Write-Output "`n"
		Write-Output "`n"
		Write-Output "                   _______________________________________________________________"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|                            CCSTOPPER                          `|"
		Write-Output "                  `|                       HideCCFolder Module                     `|"
		Write-Output "                  `|      ___________________________________________________      `|"
		Write-Output "                  `|                                                               `|"
		if($FolderHidden) {
		Write-Output "                  `|               Restoring CCF in explorer complete!             `|"
		} else {
		Write-Output "                  `|                 Hiding CCF in explorer complete!              `|"
		}
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|      Windows Explorer needs to restart for changes to         `|"
		Write-Output "                  `|      apply. Things will flash; please do not worry.           `|"
		Write-Output "                  `|      ___________________________________________________      `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|      [1] Restart now                                          `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|      [2] Skip (Restart from task manager later)               `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|_______________________________________________________________`|"
		Write-Output "`n"
		ReadKey 2
		Switch($Choice) {
			D2 { Exit }
			D1 {
				Clear-Host

				# Save open folders
				$OpenFolders = @()
				$Shell = New-Object -ComObject Shell.Application
				$Shell.Windows() | ForEach-Object { $OpenFolders += $_.LocationURL }

				# Restart windows explorer
				Stop-Process -Name "explorer" -Force

				# Wait for explorer to be restarted
				while((Get-Process -Name "explorer" -ErrorAction SilentlyContinue).Count -eq 0) { Start-Sleep -Milliseconds 100 }

				# Restore file explorer windows
				$OpenFolders | ForEach-Object { Invoke-Item $([Uri]::UnescapeDataString(([System.Uri]$($_)).AbsolutePath)) } | Out-Null

				# Show the windows
				$Handle = (Get-Process "explorer").MainWindowHandle
				$Handle | ForEach-Object {
					[Win32.NativeMethods]::SetForegroundWindow($_)
					[Win32.NativeMethods]::ShowWindowAsync($_, 4)
				}

				Exit
			}
			Default {
				$Invalid = $true
	
			}
		}
	} Until (!($Invalid))
}

function ShowFolder {
	# Shows CCF in file explorer
	Set-ItemProperty -Path Registry::$CLSID -Name System.IsPinnedToNameSpaceTree -Value 1
}
function HideFolder {
	# Hides CCF in file explorer
	Set-ItemProperty -Path Registry::$CLSID -Name System.IsPinnedToNameSpaceTree -Value 0
}

function EditReg {
	if($folderHidden -eq $true) {
		ShowFolder
	} else {
		HideFolder
	}
	RestartAsk
}

$CLSID = (Get-Subkey -Key "HKCU:\SOFTWARE\Classes\CLSID" -SubkeyPattern "{0E270DAA-1BE6-48F2-AC49-*")
$Data = (Get-ItemProperty -Path Registry::$CLSID)."System.IsPinnedToNameSpaceTree"

# Check if System.IsPinnedToNameSpaceTree is already disabled
$FolderHidden = $false

if($Data -eq 0) {
	$FolderHidden = $true
	Do {
		# Thanks https://github.com/massgravel/Microsoft-Activation-Scripts for the UI
		Clear-Host
		Write-Output "`n"
		Write-Output "`n"
		Write-Output "                   _______________________________________________________________"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|                            CCSTOPPER                          `|"
		Write-Output "                  `|                        HideCCFolder Module                    `|"
		Write-Output "                  `|      ___________________________________________________      `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|          CREATIVE CLOUD FILES FOLDER ALREADY HIDDEN!          `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|      Would you like to restore the folder's visibility?       `|"
		Write-Output "                  `|      ___________________________________________________      `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|      [1] Restore Creative Cloud Files folder                  `|"
		Write-Output "                  `|      ___________________________________________________      `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|      [Q] Exit Module                                          `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|_______________________________________________________________`|"
		Write-Output "`n"
		ReadKey 1
		Switch($Choice) {
			Q { Exit }
			D1 { RegBackup "Hide CC Folder" }
			Default {
				$Invalid = $true
	
			}
		}
	} Until (!($Invalid))
} else {
	RegBackup "Hide CC Folder"
}