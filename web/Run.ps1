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

$apiUrl = "https://api.github.com/repos/eaaasun/CCStopper/contents/src"

$folderPath = "$env:TEMP\CCStopper"
$response = Invoke-RestMethod -Uri $apiUrl
DownloadFiles $response
# start CCStopper.bat 
Write-Host "Starting CCStopper..."
Start-Process -FilePath "$folderPath\CCStopper.bat" -Wait
Write-Host "Cleaning up..."
# delete temp folder
Remove-Item -Path $folderPath -Recurse -Force
Write-Host "Cleaned up! Goodbye!"