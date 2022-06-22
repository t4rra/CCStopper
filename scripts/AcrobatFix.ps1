if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
	Start-Process -FilePath PowerShell -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`" `"$($MyInvocation.MyCommand.UnboundArguments)`""
	Exit
}

function Set-ConsoleWindow([int]$Width, [int]$Height) {
	$WindowSize = $Host.UI.RawUI.WindowSize
	$WindowSize.Width = [Math]::Min($Width, $Host.UI.RawUI.BufferSize.Width)
	$WindowSize.Height = $Height

	try {
		$Host.UI.RawUI.WindowSize = $WindowSize
	} catch [System.Management.Automation.SetValueInvocationException] {
		$Maxvalue = ($_.Exception.Message | Select-String "\d+").Matches[0].Value
		$WindowSize.Height = $Maxvalue
		$Host.UI.RawUI.WindowSize = $WindowSize
	}
}

$Host.UI.RawUI.WindowTitle = "CCStopper - Acrobat Fix"
# Set-ConsoleWindow -Width 73 -Height 42

function MainScript {
	Clear-Host
	# Thanks https://github.com/massgravel/Microsoft-Activation-Scripts for the UI
	Write-Host "`n"
	Write-Host "`n"
	Write-Host "                   _______________________________________________________________"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                            CCSTOPPER                          `|"
	Write-Host "                  `|                        AcrobatFix Module                      `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                  THIS WILL EDIT THE REGISTRY!                 `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      It is HIGHLY recommended to create a system restore      `|"
	Write-Host "                  `|      point in case something goes wrong.                      `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      [1] Make system restore point                            `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      [2] Proceed without creating restore point               `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      [Q] Exit Module                                          `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|_______________________________________________________________`|"
	Write-Host "`n"
	$Choice = Read-Host ">                                            Select [1,2,Q]"
	Clear-Host
	Switch($Choice) {
		Q { Exit }
		2 { EditReg }
		1 {
			Checkpoint-Computer -Description "Before CCStopper Acrobat Fix Script" -RestorePointType "MODIFY_SETTINGS"
			EditReg
		}
	}
}

function EditReg {
	# Adds IsAMTEnforced with proper values, then deletes IsNGLEnfoced
	Set-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Adobe\Adobe Acrobat\DC\Activation" -Name IsAMTEnforced -Value 1
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Adobe\Adobe Acrobat\DC\Activation" -Name IsNGLEnforced
	RestartAsk
}

function RestartAsk {
	Clear-Host
	# Thanks https://github.com/massgravel/Microsoft-Activation-Scripts for the UI
	Write-Host "`n"
	Write-Host "`n"
	Write-Host "                   _______________________________________________________________"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                            CCSTOPPER                          `|"
	Write-Host "                  `|                        AcrobatFix Module                      `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                   Acrobat patching complete!                  `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      The system needs to restart for changes to apply.        `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      [1] Restart now.                                         `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      [2] Skip (You will need to manually restart later)       `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|_______________________________________________________________`|"
	Write-Host "`n"
	$Choice = Read-Host ">                                            Select [1,2]: "
	Clear-Host
	Switch($Choice) {
		2 { Exit }
		1 { Restart-Computer }
	}
}


# Check if IsNGLEnforced already replaced w/ IsAMTEnforced
$IsAMTEnforced = (Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Adobe\Adobe Acrobat\DC\Activation").IsAMTEnforced
if($IsAMTEnforced -eq 1) {
	Clear-Host
	Write-Host Acrobat has already been patched.
	Pause
	Exit
} else {
	# Check if target path exists
	$IsNGLEnforced = (Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Adobe\Adobe Acrobat\DC\Activation").IsNGLEnforced
	if($null -eq $IsNGLEnforced) {
		Clear-Host
		Write-Host The target registry key cannot be found. Cannot proceed with Acrobat fix.
		Pause
		Exit
	} else {
		MainScript
	}
}