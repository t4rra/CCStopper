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