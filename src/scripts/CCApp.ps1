Import-Module $PSScriptRoot\Functions.ps1
Init -Title "Patch CC App"
# thanks genp discord							
# check if backup exists
$AppsPanelBL = "${env:Programfiles(x86)}\Common Files\Adobe\Adobe Desktop Common\AppsPanel\AppsPanelBL.dll"
$AppsPanelBackup = "$AppsPanelBL.bak"

function StopCCApp {
	Stop-Process -Name "Adobe Desktop Service" -force
	Stop-Process -Name "Creative Cloud" -force
}

if (Test-Path $AppsPanelBackup) {
	# backup exists, ask if user wants to restore
	ShowMenu -Back -Subtitles "Patch CC App" -Header "Backup found!" -Description "Would you like to restore the backup?" -Options @(
		@{
			Name = "Restore backup"
			Code = {
				# restore backup
				StopCCApp
				Remove-Item $AppsPanelBL
				Rename-Item $AppsPanelBackup -NewName "AppsPanelBL.dll"
				ShowMenu -Back -Subtitles "Patch Desktop App" -Header "Successfully restored backup!" -Description "You may need to restart your system for changes to apply."
			}
		}
	)
}
else {
	StopCCApp
	# backup doesn't exist, create backup and patch app
	# create backup
	Copy-Item $AppsPanelBL -Destination $AppsPanelBackup


	$bytes = [System.IO.File]::ReadAllBytes($AppsPanelBL)
	$bytes[1116554] = 0xfe
	$bytes[1216383] = 0xfe
	$bytes[1987439] = 0xfe
	$bytes[2150557] = 0xfe
	$bytes[2151982] = 0xfe
	$bytes[2152497] = 0xfe
	$bytes[2153297] = 0xfe
	$bytes[2279801] = 0xc6
	$bytes[2279802] = 0x40
	$bytes[2279811] = 0xc6
	$bytes[2279812] = 0x40
	$bytes[2279821] = 0xc6
	$bytes[2279822] = 0x40
	[System.IO.File]::WriteAllBytes($AppsPanelBL, $bytes)
	ShowMenu -Back -Subtitles "Patch Desktop App" -Header "Successfully patched desktop app!" -Description "You may need to restart your system for changes to apply."

}
