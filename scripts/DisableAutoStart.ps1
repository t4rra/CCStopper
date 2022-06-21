$MyWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$MyWindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($MyWindowsID)
$AdminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

if($MyWindowsPrincipal.IsInRole($AdminRole)) {
	$Host.UI.RawUI.WindowTitle = $MyInvocation.MyCommand.Definition + "(Elevated)"
	Clear-Host
} else {
	$NewProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell"
	$NewProcess.Arguments = $MyInvocation.MyCommand.Definition
	$NewProcess.Verb = "runas"
	[System.Diagnostics.Process]::Start($NewProcess)
	Exit
}

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