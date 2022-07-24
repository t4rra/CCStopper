Import-Module $PSScriptRoot\Functions.ps1
Init -Title "Acrobat Patch"

function Patch {
	# Adds IsAMTEnforced with proper values, then deletes IsNGLEnfoced
	Set-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Adobe\Adobe Acrobat\DC\Activation" -Name IsAMTEnforced -Value 1
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Adobe\Adobe Acrobat\DC\Activation" -Name IsNGLEnforced
}

function Revert {
	# Adds IsNGLEnfoced with proper values, then deletes IsAMTEnforced
	Set-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Adobe\Adobe Acrobat\DC\Activation" -Name IsNGLEnforced -Value 1
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Adobe\Adobe Acrobat\DC\Activation" -Name IsAMTEnforced
}

function EditReg {
	if ($Patched -eq $true) { Patch } else { Revert }
	RestartAsk
}

function RestartAsk {
	ShowMenu -Back -Subtitles "AcrobatPatch Module" -Header "Acrobat patching complete!" -Description "The system needs to restart for changes to apply." -Options @(
		@{
			Name = "Restart now"
			Code = { Restart-Computer }
		}
	)
}

# Check if IsNGLEnforced already replaced w/ IsAMTEnforced
$IsAMTEnforced = (Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Adobe\Adobe Acrobat\DC\Activation").IsAMTEnforced
if ($IsAMTEnforced -eq 1) {
	$Patched = $true
	ShowMenu -Back -Subtitles "AcrobatPatch Module" -Header "ACROBAT IS ALREADY PATCHED!" -Description "Would you like to revert the patch?" -Options @(
		@{
			Name = "Revert AcrobatPatch"
			Code = { RegBackup -Msg "AcrobatPatch" }
		}
	)
} else {
	RegBackup -Msg "AcrobatPatch"
}