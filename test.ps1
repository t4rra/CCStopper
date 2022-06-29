function ReadKey {
	param (
		[int]$ChoiceNum
	)

	$Indent = 40 - $ChoiceNum
	for ($i = 0; $i -le $Indent; $i++) {
		write-host " " -NoNewLine
	}
	write-host "Select [" -NoNewLine

	for ($num = 1 ; $num -le $choiceNum ; $num++) {
		write-host "$num, " -NoNewLine
	}

	write-host "Q]: " -NoNewLine

	$KeyPress = [System.Console]::ReadKey()
	$global:KeyChar = $KeyPress.Key
}

Do {
	$Invalid = $false
	ReadKey 5
	clear-host
	Switch ($KeyChar) {
		Q {
			write-host "You pressed Q"
		}
		D1 {
			write-host "You pressed 1"
		}

		D2 {
			write-host "You pressed 2"
		}

		Default {
			$Invalid = $true
		}
	}
} Until (!($Invalid))