Import-Module .\Functions.ps1
Init -Title $Version

$Sig = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
Add-Type -MemberDefinition $Sig -name NativeMethods -namespace Win32

# Set-ConsoleWindow -Width 73 -Height 42

function Get-Subkey([String]$Key, [String]$SubkeyPattern) {
	return (Get-ChildItem $Key -Recurse | Where-Object { $_.PSChildName -Like "$SubkeyPattern" }).Name
}

function RestartAsk {
	ShowMenu -Subtitles "HideCCFolder Module" if ($FolderHidden) { -Header "Restored CCF!" } else { -Header "Hidden CCF!" } -Description "Windows Explorer needs to restart for changes to apply. Things will flash; please don't worry." -Options @(
		@{
			Name = "Restart Now"
			Code = {
					Clear-Host
				# Save open folders
				$OpenFolders = @()
				$Shell = New-Object -ComObject Shell.Application
				$Shell.Windows() | ForEach-Object { $OpenFolders += $_.LocationURL }
				# Restart windows explorer
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

function ShowFolder {
	# Shows CCF in file explorer
	Set-ItemProperty -Path Registry::$CLSID -Name System.IsPinnedToNameSpaceTree -Value 1
}
function HideFolder {
	# Hides CCF in file explorer
	Set-ItemProperty -Path Registry::$CLSID -Name System.IsPinnedToNameSpaceTree -Value 0
}

function EditReg {
	if ($folderHidden -eq $true) {
		ShowFolder
	}
 else {
		HideFolder
	}
	RestartAsk
}

$CLSID = (Get-Subkey -Key "HKCU:\SOFTWARE\Classes\CLSID" -SubkeyPattern "{0E270DAA-1BE6-48F2-AC49-*")
$Data = (Get-ItemProperty -Path Registry::$CLSID)."System.IsPinnedToNameSpaceTree"

# Check if System.IsPinnedToNameSpaceTree is already disabled
$FolderHidden = $false

if ($Data -eq 0) {
	$FolderHidden = $true
	ShowMenu -Back -Subtitles "HideCCFolder Module" -Header "CREATIVE CLOUD FOLDER IS ALREADY HIDDEN!" -Description "Would you like to restore the folder's visibility?" -Options @(
		@{
			Name = "Restore Creative Cloud Files folder"
			Code = {
				RegBackup "Hide CC Folder"
			}
		}
	)
}