if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
	Start-Process -FilePath PowerShell -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`" `"$($MyInvocation.MyCommand.UnboundArguments)`""
	Exit
}
Set-Location $PSScriptRoot

function Set-ConsoleWindow([int]$Width, [int]$Height) {
	$WindowSize = $Host.UI.RawUI.WindowSize
	$WindowSize.Width = [Math]::Min($Width, $Host.UI.RawUI.BufferSize.Width)
	$WindowSize.Height = $Height

	try {
		$Host.UI.RawUI.WindowSize = $WindowSize
	} catch [System.Management.Automation.SetValueInvocationException] {
		$MaxValue = ($_.Exception.Message | Select-String "\d+").Matches[0].Value
		$WindowSize.Height = $MaxValue
		$Host.UI.RawUI.WindowSize = $WindowSize
	}
}

$Host.UI.RawUI.WindowTitle = "CCStopper - Disable Auto Start"
# Set-ConsoleWindow -Width 73 -Height 42

# Disable services auto-start
Get-Service -DisplayName Adobe* | Set-Service -StartupType Manual

# Disable processes auto-start
Get-Item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run" | Foreach-Object {
   $Path = $_.PSPath
   $_.Property | ForEach-Object {
      $Name = $_
      $File = Get-ItemProperty -LiteralPath $Path -Name $Name | Select -Expand $Name

      # If the value has arguments, strip them off
      if($File -match '"'){
         $File = $File.Substring($File.IndexOf('"')+1, $File.LastIndexOf('"')-1)
      }

      (Get-Item $File).VersionInfo | Where-Object {$_.CompanyName -match "Adobe" -or $File -match "Adobe"} | Foreach-Object {
         # Disable the processes the same way task manager does it
         Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run32" -Name $Name -Value ([byte[]](0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11))
      }
   }
}