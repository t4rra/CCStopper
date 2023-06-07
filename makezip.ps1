Import-Module $PSScriptRoot\scripts\Functions.ps1
$FolderName = "CCStopper_$Version"
New-Item -ItemType Directory -Path ".\$FolderName"
Copy-Item -Path ".\CCStopper.bat" -Destination ".\$FolderName\CCStopper.bat"
Copy-Item -Path ".\scripts" -Destination ".\$FolderName\scripts" -Recurse
Compress-Archive -Path ".\$FolderName" -DestinationPath CCStopper.zip
Remove-Item -Path ".\$FolderName" -Recurse