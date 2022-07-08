Import-Module $PSScriptRoot\Functions.ps1
Init -Title "Acrobat Patch"

function EditReg {
	# Adds IsAMTEnforced with proper values, then deletes IsNGLEnfoced
	Set-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Adobe\Adobe Acrobat\DC\Activation" -Name IsAMTEnforced -Value 1
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Adobe\Adobe Acrobat\DC\Activation" -Name IsNGLEnforced
	RestartAsk
}

function RestartAsk {
	ShowMenu -Back -Subtitles "AcrobatPatch Module" -Header "Acrobat patching complete!" -Description "The system needs to restart for changes to apply." -Options @(
		@{
			Name = "Restart now"
			Code = {
				Restart-Computer
			}
		}
	)
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