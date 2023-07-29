Import-Module $PSScriptRoot\Functions.ps1
Init -Title "Hide CC Folder"

# Set-ConsoleWindow -Width 73 -Height 42

# import library to restore open explorer windows
$Sig = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
Add-Type -MemberDefinition $Sig -name NativeMethods -namespace Win32

function Get-Subkey([String]$Key, [String]$SubkeyPattern) {
	return (Get-ChildItem $Key -Recurse | Where-Object { $_.PSChildName -Like "$SubkeyPattern" }).Name
}

function RestartAsk {
	if ($Data -eq 0) {
		$RestartMSG = "Restored Creative Cloud Folder!"
	} else {
		$RestartMSG = "Hidden Creative CLoud Folder!"
	}
	ShowMenu -Subtitles "HideCCFolder Module" -Header $RestartMSG -Description "Windows Explorer needs to restart for changes to apply. Things will flash; please don't worry." -Options @(
		@{
			Name = "Restart Now"
			Code = {
				# Save open folders
				$OpenFolders = @()
				$Shell = New-Object -ComObject Shell.Application
				$Shell.Windows() | ForEach-Object { $OpenFolders += $_.LocationURL }

				# Restart Windows Explorer
				Stop-Process -Name "explorer" -Force

				# Wait for explorer to be restarted
				while ((Get-Process -Name "explorer" -ErrorAction SilentlyContinue).Count -eq 0) { Start-Sleep -Milliseconds 100 }

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
	)
}

function SetFolder([String]$Value) {
	# Shows CCF in file explorer
	Set-ItemProperty -Path Registry::$CLSID -Name System.IsPinnedToNameSpaceTree -Value $Value
}

$CLSID = (Get-Subkey -Key "HKCU:\SOFTWARE\Classes\CLSID" -SubkeyPattern "{0E270DAA-1BE6-48F2-AC49-*")
$Data = (Get-ItemProperty -Path Registry::$CLSID)."System.IsPinnedToNameSpaceTree"

if ($Data -eq 0) {
	# folder hidden already
	ShowMenu -Back -Subtitles "HideCCFolder Module" -Header "Creative Cloud folder is already hidden!" -Description "Would you like to restore the folder's visibility?" -Options @(
		@{
			Name = "Restore Creative Cloud Files folder"
			Code = {
				RegBackup -Module "HideCCFolder"
				SetFolder 1
				RestartAsk
			}
		}
	)
}
else {
	RegBackup -Module "HideCCFolder"
	SetFolder 0
	RestartAsk
}