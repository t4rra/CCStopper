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

$Sig = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
Add-Type -MemberDefinition $Sig -name NativeMethods -namespace Win32

$Host.UI.RawUI.WindowTitle = "CCStopper - Hide Creative Cloud Folder"
# Set-ConsoleWindow -Width 73 -Height 42

function Get-Subkey([String]$Key, [String]$SubkeyPattern) {
	return (Get-ChildItem $Key -Recurse | Where-Object {$_.PSChildName -Like "$SubkeyPattern"}).Name
}

function RestartAsk {
	Clear-Host
	# Thanks https://github.com/massgravel/Microsoft-Activation-Scripts for the UI
	Write-Host "`n"
	Write-Host "`n"
	Write-Host "                   _______________________________________________________________"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                            CCSTOPPER                          `|"
	Write-Host "                  `|                       HideCCFolder Module                     `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	if($FolderHidden) {
		Write-Host "                  `|               Restoring CCF in explorer complete              `|"
	} else {
		Write-Host "                  `|                 Hiding CCF in explorer complete!              `|"
	}
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      Windows Explorer needs to restart for changes to         `|"
	Write-Host "                  `|      apply. Things will flash; please do not worry.           `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      [1] Restart now                                          `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      [2] Skip (Restart from task manager later)               `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|_______________________________________________________________`|"
	Write-Host "`n"
	$Choice = Read-Host ">                                            Select [1,2]: "
	Clear-Host
	Switch($Choice) {
		2 { Exit }
		1 {
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
	}
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

function MainScript {
	Clear-Host
	# Thanks https://github.com/massgravel/Microsoft-Activation-Scripts for the UI
	Write-Host "`n"
	Write-Host "`n"
	Write-Host "                   _______________________________________________________________"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                            CCSTOPPER                          `|"
	Write-Host "                  `|                        HideCCFiles Module                     `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                  THIS WILL EDIT THE REGISTRY!                 `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      It is HIGHLY recommended to create a system restore      `|"
	Write-Host "                  `|      point in case something goes wrong.                      `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      [1] Make system restore point                            `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      [2] Proceed without creating restore point               `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      [Q] Exit Module                                          `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|_______________________________________________________________`|"
	Write-Host "`n"
	$Choice = Read-Host ">                                            Select [1,2,Q]"
	Clear-Host
	Switch($Choice) {
		Q { Exit }
		2 { EditReg }
		1 {
			Checkpoint-Computer -Description "Before CCStopper Hide CC Folder Script" -RestorePointType "MODIFY_SETTINGS"
			EditReg
		}
	}
}	

$CLSID = (Get-Subkey -Key "HKCU:\SOFTWARE\Classes\CLSID" -SubkeyPattern "{0E270DAA-1BE6-48F2-AC49-*")
$Data = (Get-ItemProperty -Path Registry::$CLSID)."System.IsPinnedToNameSpaceTree"

# Check if System.IsPinnedToNameSpaceTree is already disabled
$FolderHidden = $false

if($Data -eq 0) {
	$FolderHidden = $true
	Clear-Host
	Write-Host "`n"
	Write-Host "`n"
	Write-Host "                   _______________________________________________________________"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                            CCSTOPPER                          `|"
	Write-Host "                  `|                        HideCCFolder Module                    `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|          CREATIVE CLOUD FILES FOLDER ALREADY HIDDEN!          `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      Would you like to restore the folder's visibility?       `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      [1] Restore Creative Cloud Files folder                  `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      [Q] Exit Module                                          `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|_______________________________________________________________`|"
	Write-Host "`n"
	$Choice = Read-Host ">                                            Select [1,Q]: "
	Clear-Host
	Switch($Choice) {
		Q { Exit }
		1 { MainScript }
	}
} else {
	MainScript
}