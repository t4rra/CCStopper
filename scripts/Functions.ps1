function ReadKey([int]$ChoiceNum) {
	$Indent = 43 - $ChoiceNum
	for ($i = 0; $i -le $Indent; $i++) {
		Write-Host " " -NoNewLine
	}
	Write-Host "Select [" -NoNewLine

	for ($num = 1; $Num -le $ChoiceNum; $Num++) {
		Write-Host "$Num," -NoNewLine
	}

	Write-Host "Q]: " -NoNewLine

	$KeyPress = [System.Console]::ReadKey()
	$global:Choice = $KeyPress.Key
}

function Pause {
	cmd /c pause
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

$IndentTextLength = 11
$IndentText = ""
1.."$IndentTextLength" | ForEach-Object { $IndentText += " " }

$TextLength = 67
$TextLine = ""
1.."$TextLength" | ForEach-Object { $TextLine += " " }

$MarginLength = 6
$MarginText = ""
1.."$MarginLength" | ForEach-Object { $MarginText += " " }

$OddMarginLength = 5
$OddMarginText = ""
1.."$OddMarginLength" | ForEach-Object { $OddMarginText += " " }

$LineLength = $TextLength + ($MarginLength * 2)
$BlankLine = ""
1.."$LineLength" | ForEach-Object { $BlankLine += " " }

$TopBorder = ""
1.."$($LineLength)" | ForEach-Object { $TopBorder += "_" }

$BottomBorder = ""
1.."$LineLength" | ForEach-Object { $BottomBorder += "_" }

$TextBorder = ""
1.."$TextLength" | ForEach-Object { $TextBorder += "_" }

$TextCenter = [Math]::Floor(($TextLength / 2) - 1)

function Write-MenuLine([string]$Contents, [switch]$Center, [switch]$Margin = $true, [switch]$UseTextLine = $true) {
	Remove-Variable Extra -ErrorAction SilentlyContinue
	$Length = $Contents.Length

	if($Margin) { $OriginalLength = $TextLength } else { $OriginalLength = $LineLength }
	if ($Length -gt $OriginalLength) {
		$ExtraAmount = $Length - $TextLength
		$local:Extra = $Contents.Substring($Length - $ExtraAmount)
		$Contents = $Contents.Substring(0, $Length - $ExtraAmount)
		$Length = $Contents.Length
	}

	$Line = $TextLine
	if (!($UseTextLine)) { $Line = $BlankLine }

	if ($Center) {
		$Offset = [Math]::Floor($Length / 2)
		$OffsettedLength = $TextCenter - $Offset

		$Line = $Line.Remove($TextCenter, $Offset)
		$Line = $Line.Remove($OffsettedLength + 1, $Offset)
		$Line = $Line.Insert($OffsettedLength + 1, $Contents)
	}
 else {
		$Line = $Line.Remove(0, $Length)
		$Line = $Line.Insert(0, $Contents)
	}

	if($Line.Length -gt $TextLength -and $Line.Length -lt $LineLength) {
		$Line = $Line.Substring(0, $Line.Length-1)
	}

	if ($Margin) {
		$Line = $Line.Insert(0, $MarginText)
		$Line = $Line.Insert($Line.Length, $MarginText)
	}

	Write-Output "$IndentText`|$Line`|"

	if (Test-Path variable:local:Extra) {
		$PSBoundParameters["Contents"] = "$local:Extra"
		Write-MenuLine @PSBoundParameters
	}
}

function Write-BlankMenuLine { Write-MenuLine -Contents "" }
function Write-TopBorder { Write-Output " $IndentText$TopBorder" }
function Write-BottomBorder { Write-MenuLine -Contents $BottomBorder -Margin:$false -UseTextLine:$false }
function Write-TextBorder { Write-MenuLine -Contents $TextBorder }

function ShowMenu([switch]$Back, [string[]]$Subtitle, [string]$Header, [string]$Description, [string[]]$Options) {
	# Thanks https://github.com/massgravel/Microsoft-Activation-Scripts for the UI
	Clear-Host
	Write-Output "`n"
	Write-Output "`n"
	Write-TopBorder
	Write-BlankMenuLine
	Write-BlankMenuLine
	Write-MenuLine -Contents "CCSTOPPER" -Center
	foreach ($Subtitle in $Subtitle) {
		Write-MenuLine -Contents $Subtitle -Center
	}
	# Write-MenuLine -Contents "$Module Module"
	Write-TextBorder
	Write-BlankMenuLine
	Write-MenuLine -Contents $($Header.ToUpper()) -Center
	Write-BlankMenuLine
	Write-MenuLine -Contents $Description
	Write-TextBorder
	Write-BlankMenuLine

	foreach ($Option in $Options) {
		$Num = $Options.IndexOf($Option) + 1
		Write-MenuLine -Contents "[$Num] $Option"
		if ($Option -ne $Options[-1]) { Write-BlankMenuLine }
	}

	Write-TextBorder
	Write-BlankMenuLine
	if ($Back) { Write-MenuLine -Contents "[Q] Back" } else { Write-MenuLine -Contents "[Q] Exit" }
	Write-BlankMenuLine

	Write-BottomBorder
	Write-Output "`n"
}

function RegBackup {
	param (
		$Msg
	)
	Do {
		ShowMenu -Back -Subtitle "$Msg Module" -Header "THIS WILL EDIT THE REGISTRY" -Description "It is HIGHLY recommended to create a system restore point in case something goes wrong." -Options "Make system restore point", "Proceed without creating restore point"
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