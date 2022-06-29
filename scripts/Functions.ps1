function ReadKey {
	param (
		[int]$ChoiceNum
	)

	$Indent = 43 - $ChoiceNum
	for ($i = 0; $i -le $Indent; $i++) {
		Write-Host " " -NoNewLine
	}
	Write-Host "Select [" -NoNewLine

	for ($num = 1; $Num -le $ChoiceNum; $Num++){
		Write-Host "$Num," -NoNewLine
	}

	Write-Host "Q]: " -NoNewLine

	$KeyPress = [System.Console]::ReadKey()
	$global:Choice = $KeyPress.Key
}

function Set-ConsoleWindow([int]$Width, [int]$Height) {
	$WindowSize = $Host.UI.RawUI.WindowSize
	$WindowSize.Width = [Math]::Min($Width, $Host.UI.RawUI.BufferSize.Width)
	$WindowSize.Height = $Height

	try {
		$Host.UI.RawUI.WindowSize = $WindowSize
	}
	catch [System.Management.Automation.SetValueInvocationException] {
		$MaxValue = ($_.Exception.Message | Select-String "\d+").Matches[0].Value
		$WindowSize.Height = $MaxValue
		$Host.UI.RawUI.WindowSize = $WindowSize
	}
}