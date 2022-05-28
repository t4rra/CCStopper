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

# Stops Adobe Processess, source: https://gist.github.com/carcheky/530fd85ffff6719486038542a8b5b997#gistcomment-3586740
Get-Process * | Where-Object {$_.CompanyName -match "Adobe" -or $_.Path -match "Adobe"} | Stop-Process -Force | Out-Null

# Stops stragglers
Stop-Process AdobeUpdateService | Out-Null
Stop-Process AdobeExtensionsService | Out-Null
Stop-Process "Adobe CEF Helper" | Out-Null
Stop-Process AdobeIPCBroker | Out-Null