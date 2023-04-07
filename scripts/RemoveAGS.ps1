Import-Module $PSScriptRoot\Functions.ps1
Init -Title "Remove AGS"

$BlockItems = @(
	@{
		Path  = "${Env:ProgramFiles(x86)}\Adobe\Adobe Creative Cloud\Utils\AdobeGenuineValidator.exe"
		Check = $False
	},
	@{
		Path  = "${Env:ProgramFiles(x86)}\Common Files\Adobe\AdobeGCClient"
		Check = $False
	}
)


# check if modified files/folders exist, if so, present option to restore them (if yes, unlock and remove .bak from name), if not, lock and rename w/ .bak at end

function ReplaceItem($Item) {
	takeown /f $Item
	$ItemBak = $Item + ".bak"
	$DirCheck = (Get-Item -Path $Item) -is [System.IO.DirectoryInfo]

	# rename existing folder/file to .bak
	Rename-Item $Item $ItemBak
	# create new folder/file
	if ($DirCheck) {
		New-Item -Path $Item -ItemType "Directory"
	}
 else {
		New-Item -Path $Item -ItemType "File"
	}
	# at this point, $Item is a new file/folder (with nothing!), and $ItemBak is the old file/folder (with everything!)
	# lock new file/folder

	$Acl = Get-Acl -Path $Item
	Set-Acl -Path $Item -AclObject $Acl # Reorder ACL to canonical order to prevent errors
	$FileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList @("BUILTIN\Administrators", "FullControl", "Deny")
	$Acl.SetAccessRule($FileSystemAccessRule)
	Set-Acl -Path $Item -AclObject $Acl
}

function RestoreItem($Item) {
	$Acl = Get-Acl -Path $Item
	Set-Acl -Path $Item -AclObject $Acl # Reorder ACL to canonical order to prevent errors
	$Acl.Access | ForEach-Object{$acl.RemoveAccessRule($_)}
	Set-Acl -Path $Item -AclObject $Acl
	Remove-Item $Item
	$ItemBak = $Item + ".bak"
	Rename-Item $ItemBak $Item
}

# what happens if no file is found: continue until all files are scanned, then proceed w/ the ones that exist

foreach ($BlockItem in $BlockItems) {
	if (Test-Path -Path $BlockItem.Path) {
		$BlockItemBak = $BlockItem.Path + ".bak"
		if (Test-Path -Path $BlockItemBak) {
			$BlockItem.Check = "backupped"
		}
		else {
			$BlockItem.Check = $True
			ReplaceItem($BlockItem.Path)
		}
	} else {
		$BlockItem.Check = $False
	}
}

switch ($BlockItem.Check){
	"backupped" {
		ShowMenu -Back -Subtitles "RemoveAGS Module" -Header "Already applied patch!" -Description "Would you like to restore original files?" -Options @(
			@{
				Name = "Restore original files"
				Code = {
					foreach($BlockItem in $BlockItems){
						RestoreItem($BlockItem.Path) | Out-Null
					}
				}
			}
		)
	}
	$False {
		ShowMenu -Back -Subtitles "RemoveAGS Module" -Header "Genuine Checker not found!" -Description "Genuine Checker files could not be found. This may not be a problem. If the files aren't there, they won't work."
	}
}

# Disable AGSSerivce from starting up and stop it
Foreach ($Service in @("AGSService", "AGMService")) {
	Get-Service -DisplayName $Service | Set-Service -StartupType Disabled
	Get-Service -DisplayName $Service | Stop-Service
	Stop-Process -Name $Service -Force | Out-Null
}

ShowMenu -Back -Subtitles "RemoveAGS Module" -Header "Removing AGS complete!"