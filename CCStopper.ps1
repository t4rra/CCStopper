# Stops Adobe Processes and Services, source: https://gist.github.com/carcheky/530fd85ffff6719486038542a8b5b997#gistcomment-3586740
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
	if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
	 $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
	 Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
	 Exit
	}
   }
   
# Stop adobe services
Get-Service -DisplayName Adobe* | Stop-Service

# Stop adobe processes
$Processes = @()
Get-Process * | Where-Object { $_.CompanyName -match "Adobe" -or $_.Path -match "Adobe" } | ForEach-Object {
	$Processes += , $_
	if ($_.mainWindowTitle.Length) {

		write-output "There are Adobe apps open! Save your work, then continue."
		pause
	}
}

Foreach ($Process in $Processes) { Stop-Process $Process -Force }

write-output ""
write-output "Adobe processes stopped."
pause
exit