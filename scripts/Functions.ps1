function ReadKey {
	param (
		[int]$ChoiceNum
	)

	$Indent = 43 - $ChoiceNum
	for ($i = 0; $i -le $Indent; $i++) {
		write-host " " -NoNewLine
	}
	write-host "Select [" -NoNewLine

	for ($num = 1 ; $num -le $choiceNum ; $num++){
		write-host "$num," -NoNewLine
	}

	write-host "Q]: " -NoNewLine

	$KeyPress = [System.Console]::ReadKey()
	$global:Choice = $KeyPress.Key
}

function RegBackup {
	param (
		$Msg
	)
	Do {
		# Thanks https://github.com/massgravel/Microsoft-Activation-Scripts for the UI
		Clear-Host
		Write-Output "`n"
		Write-Output "`n"
		Write-Output "                   _______________________________________________________________"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|                            CCSTOPPER                          `|"
		Write-Output "                  `|                       DisableAutoStart Module                 `|"
		Write-Output "                  `|      ___________________________________________________      `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|                  THIS WILL EDIT THE REGISTRY!                 `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|      It is HIGHLY recommended to create a system restore      `|"
		Write-Output "                  `|      point in case something goes wrong.                      `|"
		Write-Output "                  `|      ___________________________________________________      `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|      [1] Make system restore point                            `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|      [2] Proceed without creating restore point               `|"
		Write-Output "                  `|      ___________________________________________________      `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|      [Q] Exit Module                                          `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|                                                               `|"
		Write-Output "                  `|_______________________________________________________________`|"
		Write-Output "`n"
		ReadKey 2
		Switch ($Choice) {
			Q { Exit }
			D2 { EditReg }
			D1 {
				Clear-Host
				Checkpoint-Computer -Description "Before CCStopper $Msg" -RestorePointType "MODIFY_SETTINGS"
				EditReg
			}
			Default {
				$Invalid = $true
	
			}
		}
	} Until (!($Invalid))
}