if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
	Start-Process -FilePath $((Get-Process -Id $PID).Path) -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`" `"$($MyInvocation.MyCommand.UnboundArguments)`""
	Exit
}
Set-Location $PSScriptRoot
Clear-Host
# Stops Adobe Processes and Services, source: https://gist.github.com/carcheky/530fd85ffff6719486038542a8b5b997#gistcomment-3586740

# Stop adobe services
Get-Service -DisplayName Adobe* | Stop-Service

# Stop adobe processes
$Processes = @()
Get-Process * | Where-Object {$_.CompanyName -match "Adobe" -or $_.Path -match "Adobe"} | ForEach-Object {
	$Processes += ,$_
	if($_.mainWindowTitle.Length) {
		# Process has a window
		Do {
			# Thanks https://github.com/massgravel/Microsoft-Activation-Scripts for the UI
			Clear-Host
			Write-Output "`n"
			Write-Output "`n"
			Write-Output "                   _______________________________________________________________"
			Write-Output "                  `|                                                               `| "
			Write-Output "                  `|                                                               `|"
			Write-Output "                  `|                            CCSTOPPER                          `|"
			Write-Output "                  `|                       StopProcesses Module                    `|"
			Write-Output "                  `|      ___________________________________________________      `|"
			Write-Output "                  `|                                                               `|"
			Write-Output "                  `|                   THERE ARE ADOBE APPS OPEN!                  `|"
			Write-Output "                  `|    Do you want to continue? Unsaved documents that are open    |"
			Write-Output "                  `|                  in adobe apps will be lost.                  `|"
			Write-Output "                  `|      ___________________________________________________      `|"
			Write-Output "                  `|                                                               `|"
			Write-Output "                  `|      [1] Continue                                             `|"
			Write-Output "                  `|                                                               `|"
			Write-Output "                  `|      [Q] Exit Module                                          `|"
			Write-Output "                  `|                                                               `|"
			Write-Output "                  `|                                                               `|"
			Write-Output "                  `|_______________________________________________________________`|"
			Write-Output "`n"
			ReadKey
			Switch($Choice) {
				Q { Exit }
				1 { continue }
				Default {
					$Invalid = $true
				}
			}
		} Until (!($Invalid))
	}
}

Foreach($Process in $Processes) { Stop-Process $Process -Force | Out-Null }

Do {
	# Thanks https://github.com/massgravel/Microsoft-Activation-Scripts for the UI
	Clear-Host
	Write-Output "`n"
	Write-Output "`n"
	Write-Output "                   _______________________________________________________________"
	Write-Output "                  `|                                                               `| "
	Write-Output "                  `|                                                               `|"
	Write-Output "                  `|                            CCSTOPPER                          `|"
	Write-Output "                  `|                       StopProcesses Module                    `|"
	Write-Output "                  `|      ___________________________________________________      `|"
	Write-Output "                  `|                                                               `|"
	Write-Output "                  `|                Stopping adobe processes complete!             `|"
	Write-Output "                  `|      ___________________________________________________      `|"
	Write-Output "                  `|                                                               `|"
	Write-Output "                  `|      [Q] Exit Module                                          `|"
	Write-Output "                  `|                                                               `|"
	Write-Output "                  `|                                                               `|"
	Write-Output "                  `|_______________________________________________________________`|"
	Write-Output "`n"
	ReadKey
	Switch($Choice) {
		Q { Exit }
		Default {
			$Invalid = $true
		}
	}
} Until (!($Invalid))