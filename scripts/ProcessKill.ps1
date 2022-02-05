$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()

$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)

$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator

if ($myWindowsPrincipal.IsInRole($adminRole))

   {

   $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"

   clear-host

   }

else

   {

   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";

   $newProcess.Arguments = $myInvocation.MyCommand.Definition;

   $newProcess.Verb = "runas";

   [System.Diagnostics.Process]::Start($newProcess);

   exit

   }

# Stops Adobe Processess, source: https://gist.github.com/carcheky/530fd85ffff6719486038542a8b5b997#gistcomment-3586740
Get-Process * | Where-Object {$_.CompanyName -match "Adobe" -or $_.Path -match "Adobe"} | Stop-Process -Force >$null

# Stops stragglers
taskkill /IM AdobeUpdateService.exe /F >$null
taskkill /IM AdobeExtensionsService.exe /F >$null
taskkill /IM "Adobe CEF Helper.exe" /F >$null
taskkill /IM AdobeIPCBroker.exe /F >$null
