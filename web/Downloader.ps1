param (
    [switch]$install,
    [switch]$shortcut
)

function DownloadFiles($items, $basePath = "") {
    foreach ($item in $items) {
        if ($item.type -eq "file") {
            $downloadUrl = $item.download_url
            $outputDirectory = "$folderPath\$basePath"
            $outputFile = Join-Path -Path $outputDirectory -ChildPath $item.name
            New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
            Invoke-WebRequest -Uri $downloadUrl -OutFile $outputFile -UseBasicParsing
        }
        elseif ($item.type -eq "dir") {
            $subFolderPath = if ($basePath) { "$basePath\$($item.name)" } else { $item.name }
            $subItemsUrl = $item.url
            $subItems = Invoke-RestMethod -Uri $subItemsUrl
            DownloadFiles $subItems $subFolderPath
        }
    }
}

function CreateShortcut($targetPath, $arguement, $shortcutPath, $iconPath) {
    $LogoURL = "https://raw.githubusercontent.com/eaaasun/CCStopper/main/web/icon.ico"
    if (!(Test-Path -Path $folderPath)) {
        New-Item -ItemType Directory -Path $folderPath -Force | Out-Null
    }
    Invoke-WebRequest -Uri $LogoURL -OutFile "$folderPath\icon.ico" -UseBasicParsing
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($shortcutPath)
    if ($arguement) {
        $Shortcut.Arguments = $arguement
    }
    $Shortcut.TargetPath = $targetPath
    $Shortcut.IconLocation = $iconPath
    $Shortcut.Save()
}

$apiUrl = "https://api.github.com/repos/eaaasun/CCStopper/contents/src"

if ($install) {
    $folderPath = "$env:ProgramFiles\CCStopper"
    # check if $folderPath exists
    if (Test-Path -Path "$folderPath\CCStopper.bat") {
        Write-Host "CCStopper is already installed! Would you like to uninstall it?"
        $response = Read-Host "Y/N"
        if ($response -eq "Y") {
            Write-Host "Uninstalling CCStopper..."
            Remove-Item -Path $folderPath -Recurse -Force
            if (Test-Path -Path "$env:USERPROFILE\Desktop\CCStopper.lnk") {
                Remove-Item -Path "$env:USERPROFILE\Desktop\CCStopper.lnk" -Force
            }
            Write-Host "Uninstalled CCStopper! Goodbye!"
            pause
            exit
        }
        else {
            exit
        }
    }
    $items = Invoke-RestMethod -Uri $apiUrl
    DownloadFiles $items
    Write-Host "Installed CCStopper at $folderPath!"
    CreateShortcut -targetPath "$folderPath\CCStopper.bat" -shortcutPath "$env:USERPROFILE\Desktop\CCStopper.lnk" -iconPath "$folderPath\icon.ico"
    Write-Host "Created shortcut on desktop!"
    Write-Host "Finished! Uninstall CCStopper by running this script again!"
    pause
    exit
}
elseif ($shortcut) {
    $folderPath = "$env:ProgramFiles\CCStopper"
    # check if shortcut exists
    CreateShortcut -targetPath "powershell.exe" -arguement "-command ""irm https://ccstopper.netlify.app/run | iex""" -shortcutPath "$env:USERPROFILE\Desktop\CCStopper (Online).lnk" -iconPath "$folderPath\icon.ico"
    Write-Host "Created shortcut on desktop!"
    pause 
    exit
}