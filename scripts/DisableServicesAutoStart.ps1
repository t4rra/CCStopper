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

Get-Service -DisplayName Adobe* | Set-Service -StartupType Manual