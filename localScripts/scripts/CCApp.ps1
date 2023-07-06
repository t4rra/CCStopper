Import-Module $PSScriptRoot\Functions.ps1
Init -Title "Patch CC App"
# thanks genp discord							
# check if backup exists
$AppsPanelBL = "${env:Programfiles(x86)}\Common Files\Adobe\Adobe Desktop Common\AppsPanel\AppsPanelBL.dll"
$AppsPanelBackup = "$AppsPanelBL.bak"
# stop adobe desktop app process
$Processes = @()
Get-Process * | Where-Object { $_.CompanyName -match "Adobe" -or $_.Path -match "Adobe" } | ForEach-Object {
	$Processes += , $_
}
Foreach ($Process in $Processes) { Stop-Process $Process -Force | Out-Null }

Get-Service -DisplayName Adobe* | Stop-Service
if (Test-Path $AppsPanelBackup) {
	# backup exists, ask if user wants to restore
	ShowMenu -Back -Subtitles "Patch CC App" -Header "Backup found!" -Description "Would you like to restore the backup?" -Options @(
		@{
			Name = "Restore backup"
			Code = {
				# restore backup
				Remove-Item $AppsPanelBL
				Rename-Item $AppsPanelBackup -NewName "AppsPanelBL.dll"
				ShowMenu -Back -Subtitles "Patch Desktop App" -Header "Successfully restored backup!" -Description "You may need to restart your system for changes to apply."
			}
		}
	)
}
else {
	# backup doesn't exist, create backup and patch app
	# create backup
	Copy-Item $AppsPanelBL -Destination $AppsPanelBackup


	$bytes = [System.IO.File]::ReadAllBytes($AppsPanelBL)
	$bytes[1117100] = 0xfe
	$bytes[1216993] = 0xfe
	$bytes[1987809] = 0xfe
	$bytes[2149147] = 0xfe
	$bytes[2150572] = 0xfe
	$bytes[2151087] = 0xfe
	$bytes[2151887] = 0xfe
	$bytes[2278457] = 0xc6
	$bytes[2278458] = 0x40
	$bytes[2278467] = 0xc6
	$bytes[2278468] = 0x40
	$bytes[2278477] = 0xc6
	$bytes[2278478] = 0x40
	[System.IO.File]::WriteAllBytes($AppsPanelBL, $bytes)
	ShowMenu -Back -Subtitles "Patch Desktop App" -Header "Successfully patched desktop app!" -Description "You may need to restart your system for changes to apply."

}
