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
		Write-Output "                  `|                     DisableAutoStart Module                   `|"
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

$IndentCount = 18
$Indent = ""
1.."$IndentCount" | ForEach-Object { $Indent += " " }

$LineLength = 67
$Margin = 6
$MarginLength = $LineLength - ($Margin * 2)

$BlankLine = ""
1.."$LineLength" | ForEach-Object { $BlankLine += " " }

$MarginText = ""
1.."$Margin" | ForEach-Object { $MarginText += " " }


$LineCenter = ($LineLength / 2) - 1

function Write-MenuLine([String]$Contents, [Switch]$Center = $true) {
	Remove-Variable Extra -ErrorAction SilentlyContinue
	$Length = $Contents.Length
	if($Length -ge $MarginLength) {
		$ExtraAmount = $Length - $MarginLength
		$local:Extra = $Contents.Substring($Length - $ExtraAmount)
		$Contents = $Contents.Substring(0, $Length - $ExtraAmount)
		$Length = $Contents.Length
	}

	$Line = $Contents
	if($Center) {
		$Offset = $Length / 2
		$OffsettedLength = $LineCenter - $Offset

		$Line = $BlankLine
		$Line = $Line.Remove($LineCenter, $Offset)
		$Line = $Line.Remove($OffsettedLength+1, $Offset)
		$Line = $Line.Insert($OffsettedLength+1, $Contents)
	}

	$NoStartMargin = !($Line.StartsWith(($MarginText)))
	$NoEndMargin = !($Line.EndsWith(($MarginText)))

	if($NoStartMargin -or $NoEndMargin) { $Line.Trim() }
	if($NoStartMargin) { $Line.Insert(0, $MarginText) }
	if($NoEndMargin) { $Line.Insert($Length-1, $MarginText) }

	Write-Output "$Indent`|$Line`|"

	if(Test-Path variable:local:Extra) {
		if($Center) {
			Write-MenuLine -Contents $local:Extra
		} else {
			Write-MenuLine -Contents $local:Extra -Center:$false
		}
	}
}

function Write-BlankMenuLine {
	Write-MenuLine -Contents $BlankLine
}

function Write-VerticalBorder {
	Write-MenuLine -Contents "_______________________________________________________________"
}

function ShowMenu($Module, $Header, $Description) {
	# Thanks https://github.com/massgravel/Microsoft-Activation-Scripts for the UI
	Clear-Host
	Write-Output "`n"
	Write-Output "`n"
	Write-VerticalBorder
	Write-BlankMenuLine
	Write-BlankMenuLine
	Write-MenuLine -Contents "CCSTOPPER"
	Write-MenuLine -Contents "$Module Module"
	Write-VerticalBorder
	Write-BlankMenuLine
	Write-MenuLine -Contents $($Header.ToUpper())
	Write-BlankMenuLine
	Write-Output $Description
	Write-VerticalBorder
	Write-BlankMenuLine

	Write-MenuLine -Contents "[1] Restart now." -Center:$false
	Write-BlankMenuLine
	Write-MenuLine -Contents "[2] Skip (You will need to manually restart later)" -Center:$false

	Write-BlankMenuLine
	Write-BlankMenuLine
	Write-VerticalBorder
	Write-Output "`n"
}