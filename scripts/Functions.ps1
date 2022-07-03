function ReadKey([int]$ChoiceNum) {
	$Indent = 43 - $ChoiceNum
	$IndentText = ""
	0.."$Indent" | ForEach-Object { $IndentText +=  " " }

	$Nums = ""
	1.."$ChoiceNum" | ForEach-Object { $Nums +=  "$_," }
	$Nums += "Q"

	[Console]::Out.Write($IndentText + "Select [$Nums]: ")

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

$GapLength = 5
$Gap = ""
1.."$GapLength" | ForEach-Object { $Gap += " " }

$TextCenter = [Math]::Floor(($TextLength / 2) - 1)

$Border = "`|"

function Write-MenuLine([string]$Contents, [switch]$Center, [switch]$NoMargin, [switch]$NoBorders, [string]$NextExtra) {
	Remove-Variable Extra -ErrorAction SilentlyContinue
	$Length = $Contents.Length

	if($NoMargin) {
		$OriginalLength = $LineLength
		$Line = $BlankLine
	} else {
		$OriginalLength = $TextLength
		$Line = $TextLine
	}

	$FullContentsArray = $Contents.Split(' ')
	$ContentsArray = @()
	$Temp = @()
	foreach ($Word in $FullContentsArray) {
		$Temp += ,$Word
		$Contents = [String]::Join(' ', $Temp)
		$Length = $Contents.Length

		if ($Length -gt $OriginalLength) { break }
		$ContentsArray = $Temp
	}

	$Contents = [String]::Join(' ', $ContentsArray)
	$Length = $Contents.Length

	$ExtraArray = $FullContentsArray | Where-Object { $ContentsArray -notcontains $_ }
	if($ExtraArray) {
		$local:Extra = [String]::Join(' ', $ExtraArray)
	}

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


	if (!($NoMargin)) {
		if($Line.Length -gt $TextLength) {
			$Line = $Line.Substring(0, $Line.Length-1)
		}

		$Line = $Line.Insert(0, $MarginText)
		$Line = $Line.Insert($Line.Length, $MarginText)
	}

	if(!($NoBorders)) { $BorderX = $Border } else { $BorderX = " " }
	$Result = $IndentText + $BorderX + $Line + $BorderX

	Write-Output "$Result"

	if (Test-Path variable:local:Extra) {
		if (!([String]::IsNullOrEmpty($NextExtra))) { $local:Extra = $NextExtra + $local:Extra }
		$PSBoundParameters["Contents"] = $local:Extra
		Write-MenuLine @PSBoundParameters
	}
}

function Write-BlankMenuLine { Write-MenuLine -Contents "" }
function Write-TopBorder { Write-MenuLine -Contents $TopBorder -NoMargin -NoBorders }
function Write-BottomBorder { Write-MenuLine -Contents $BottomBorder -NoMargin }
function Write-TextBorder { Write-MenuLine -Contents $TextBorder }

function ShowMenu([switch]$Back, [string[]]$Subtitle, [string]$Header, [string]$Description, $Options) {
	Do {
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
		Write-TextBorder
		Write-BlankMenuLine
		Write-MenuLine -Contents $($Header.ToUpper()) -Center
		Write-BlankMenuLine
		Write-MenuLine -Contents $Description
		Write-TextBorder
		Write-BlankMenuLine

		$NameLengths = @()
		foreach ($Option in $Options) {
			$Name = $Option[0][0]
			$Num = $Options.IndexOf($Option) + 1
			$NumText = "[$Num]"
			$Result = $NumText + " " + $Name
			$NameLengths += ,$Result.Length
		}
		$LargestNameLength = ($NameLengths | Measure-Object -Maximum).Maximum

		foreach ($Option in $Options) {
			$Name = $Option[0][0]
			$Description = $Option[0][1]
			$Num = $Options.IndexOf($Option) + 1
			$NumText = "[$Num]"
			$Result = $NumText + " " + $Name
			if(!([String]::IsNullOrEmpty($Description))) {
				0.."$($LargestNameLength-1)" | Where-Object { $_ -ge $Result.Length } | ForEach-Object { $Result += " " }

				$NextExtra = ""
				0.."$($Result.Length-1)" | ForEach-Object { $NextExtra += " " }

				$NextExtra += $Gap + $Border + " "
				$Result += $Gap + $Border + " "

				$Result += $Description
			}

			$Parameters = @{ Contents = $Result }
			if(Test-Path variable:NextExtra) { $Parameters.Add("NextExtra", $NextExtra) }

			Write-MenuLine @Parameters
			if ($Option -ne $Options[-1]) { Write-BlankMenuLine }
		}
		if($null -eq $Invalid) { $Invalid = $true }

		Write-TextBorder
		Write-BlankMenuLine

		if ($Back) { $Exit = "Back" } else { $Exit = "Exit" }
		Write-MenuLine -Contents "[Q] $Exit"
		Write-BlankMenuLine

		Write-BottomBorder
		Write-Output "`n"

		ReadKey $($Options.Length)
		if($Choice -eq "Q") { Exit }

		foreach ($Option in $Options) {
			$Invalid = $false
			$ScriptBlock = $Option[1]
			$Num = $Options.IndexOf($Option) + 1
			if($Choice -eq "D$Num") { Invoke-Command -ScriptBlock $ScriptBlock }
		}
	} Until (!($Invalid))
}

function RegBackup([string]$Msg) {
	ShowMenu -Back -Subtitle "$Msg Module" -Header "THIS WILL EDIT THE REGISTRY!" -Description "It is HIGHLY recommended to create a system restore point in case something goes wrong." -Options @(
		@(@("Make system restore point"), {
			Clear-Host
			Checkpoint-Computer -Description "Before CCStopper $Msg" -RestorePointType "MODIFY_SETTINGS"
			EditReg
		}),
		@(@("Proceed without creating restore point"), { EditReg })
	)
}