Import-Module $PSScriptRoot\CCStopper_AIO.ps1
$FolderName = "CCStopper_$Version"
New-Item -ItemType Directory -Path ".\$FolderName"
Copy-Item -Path ".\CCStopper.bat" -Destination ".\$FolderName\CCStopper.bat"
Copy-Item -Path ".\CCStopper_AIO.ps1" -Destination ".\$FolderName\CCStopper_AIO.ps1"
Compress-Archive -Path ".\$FolderName" -DestinationPath CCStopper.zip
Remove-Item -Path ".\$FolderName" -Recurse