if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
	Start-Process -FilePath $((Get-Process -Id $PID).Path) -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`" `"$($MyInvocation.MyCommand.UnboundArguments)`""
	Exit
}
Set-Location $PSScriptRoot
Clear-Host

$Host.UI.RawUI.WindowTitle = "CCStopper - Acrobat Fix"
# Set-ConsoleWindow -Width 73 -Height 42

function EditReg {
	# Adds IsAMTEnforced with proper values, then deletes IsNGLEnfoced
	Set-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Adobe\Adobe Acrobat\DC\Activation" -Name IsAMTEnforced -Value 1
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Adobe\Adobe Acrobat\DC\Activation" -Name IsNGLEnforced
	RestartAsk
}

function RestartAsk {
	Do {
		# Thanks https://github.com/massgravel/Microsoft-Activation-Scripts for the UI
		Clear-Host
		Write-Output "`n"
		Write-Output "`n"
		Write-Output "                   _______________________________________________________________"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|                            CCSTOPPER                          `|"
		Write-Output "                  `|                       AcrobatPatch Module                     `|"
		Write-Output "                  `|      ___________________________________________________      `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|                   Acrobat patching complete!                  `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|      The system needs to restart for changes to apply.        `|"
		Write-Output "                  `|      ___________________________________________________      `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|      [1] Restart now.                                         `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|      [2] Skip (You will need to manually restart later)       `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|_______________________________________________________________`|"
		Write-Output "`n"
		ReadKey 2
		Switch ($Choice) {
			D2 { Exit }
			D1 { Restart-Computer }
			Default {
				$Invalid = $true
			}
		}
	} Until (!($Invalid))
}


# Check if IsNGLEnforced already replaced w/ IsAMTEnforced
$IsAMTEnforced = (Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Adobe\Adobe Acrobat\DC\Activation").IsAMTEnforced
if ($IsAMTEnforced -eq 1) {
	Clear-Host
	Write-Output "Acrobat has already been patched."
	Pause
	Exit
}
else {
	# Check if target path exists
	$IsNGLEnforced = (Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Adobe\Adobe Acrobat\DC\Activation").IsNGLEnforced
	if ($null -eq $IsNGLEnforced) {
		Clear-Host
		Write-Output "The target registry key cannot be found. Cannot proceed with Acrobat fix."
		Pause
		Exit
	}
 else {
		RegBackup -Msg "Acrobat Patch"
	}
}