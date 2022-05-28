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

$CLSID = (Get-ChildItem HKCU:\SOFTWARE\Classes\CLSID -Recurse | Where-Object {$_.PSChildName -Like '{0E270DAA-1BE6-48F2-AC49-*'}).Name.replace("HKEY_CURRENT_USER", "HKCU:")
Set-ItemProperty -Path $CLSID -Name "System.IsPinnedToNameSpaceTree" -Value 0