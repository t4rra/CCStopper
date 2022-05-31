$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator

if($myWindowsPrincipal.IsInRole($adminRole)) {
$Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
   Clear-Host
} else {
   $NewProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell";
   $NewProcess.Arguments = $myInvocation.MyCommand.Definition;
   $NewProcess.Verb = "runas";
   [System.Diagnostics.Process]::Start($newProcess);

   exit
}

# Disable services auto start
Get-Service -DisplayName Adobe* | Set-Service -StartupType Manual

# Disable processes auto start
Get-Item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run" | Foreach-Object {
   $Path = $_.PSPath
   $_.Property | Foreach-Object {
      $Name = $_
      $File = Get-ItemProperty -LiteralPath $Path -Name $Name | Select -Expand $Name

      # If the value has arguments, strip them off
      if($File -match '"'){
         $File = $File.Substring($File.IndexOf('"')+1, $File.LastIndexOf('"')-1)
      }

      (Get-Item $File).VersionInfo | Where-Object {$_.CompanyName -match "Adobe" -or $File -match "Adobe"} | Foreach-Object {
         # Disable the processes the same way task manager does it
         Write-Host "Disabling $Name"
         Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run32" -Name $Name -Value ([byte[]](0x03,0x00,0x00,0x00,0xba,0x4f,0x3d,0x69,0x59,0x6f,0xd8,0x01))
      }
   }
}