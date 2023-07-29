$Version = "v1.2.3-hotfix.1"

function ReadKey([int]$ChoiceNum) {
	$Indent = 43 - $ChoiceNum
	$IndentText = ""
	0.."$Indent" | ForEach-Object { $IndentText += " " }

	$Nums = ""
	for ($Num = 1; $Num -le $ChoiceNum; $Num++) {
		$Nums += "$Num,"
	}
	$Nums += "Q"

	[Console]::Out.Write($IndentText + "Select [$Nums]: ")

	$KeyPress = [System.Console]::ReadKey()
	$global:Choice = $KeyPress.Key
}

function Init([string]$Title) {
	if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
		if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
			Start-Process -FilePath $((Get-Process -Id $PID).Path) -Verb Runas -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" `"$args $($PSBoundParameters.Values)`""
			Exit
		}
	}
	Set-Location $PSScriptRoot
	Clear-Host

	$WindowTitle = "CCStopper"
	if ($Title) { $WindowTitle += " - $Title" }
	$Host.UI.RawUI.WindowTitle = $WindowTitle
}

# The indent before the vertical borders
$IndentTextLength = 11
$IndentText = ""
1.."$IndentTextLength" | ForEach-Object { $IndentText += " " }

# The maximum length of text in a line
$TextLength = 67
$TextLine = ""
1.."$TextLength" | ForEach-Object { $TextLine += " " }

# The margin (amount of spaces) that are adjacent to the vertical borders
$MarginLength = 6
$MarginText = ""
1.."$MarginLength" | ForEach-Object { $MarginText += " " }

$OddMarginLength = 5
$OddMarginText = ""
1.."$OddMarginLength" | ForEach-Object { $OddMarginText += " " }

# The text and margin combined
$LineLength = $TextLength + ($MarginLength * 2)
$BlankLine = ""
1.."$LineLength" | ForEach-Object { $BlankLine += " " }

$VerticalBorder = ""
1.."$LineLength" | ForEach-Object { $VerticalBorder += "_" }

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

	if ($NoMargin) {
		$OriginalLength = $LineLength
		$Line = $BlankLine
	}
 else {
		$OriginalLength = $TextLength
		$Line = $TextLine
	}

	$FullContentsArray = $Contents.Split(' ')
	$ContentsArray = @()
	$Temp = @()
	foreach ($Word in $FullContentsArray) {
		$Temp += , $Word
		$Contents = [String]::Join(' ', $Temp)
		$Length = $Contents.Length

		if ($Length -gt $OriginalLength) { break }
		$ContentsArray = $Temp
	}

	$Contents = [String]::Join(' ', $ContentsArray)
	$Length = $Contents.Length

	$ExtraArray = $FullContentsArray | Select-Object -Skip $ContentsArray.Length
	if ($ExtraArray) {
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
		if ($Line.Length -gt $TextLength) {
			$Line = $Line.Substring(0, $Line.Length - 1)
		}

		$Line = $Line.Insert(0, $MarginText)
		$Line = $Line.Insert($Line.Length, $MarginText)
	}

	if (!($NoBorders)) { $BorderX = $Border } else { $BorderX = " " }
	$Result = $IndentText + $BorderX + $Line + $BorderX

	Write-Output "$Result"

	if (Test-Path variable:local:Extra) {
		if (!([String]::IsNullOrEmpty($NextExtra))) { $local:Extra = $NextExtra + $local:Extra }
		$PSBoundParameters["Contents"] = $local:Extra
		Write-MenuLine @PSBoundParameters
	}
}
function Write-BlankMenuLine { Write-MenuLine -Contents "" }
function Write-TopBorder { Write-MenuLine -Contents $VerticalBorder -NoMargin -NoBorders }
function Write-BottomBorder { Write-MenuLine -Contents $VerticalBorder -NoMargin }
function Write-TextBorder { Write-MenuLine -Contents $TextBorder }

function ShowMenu([switch]$Back, [switch]$VerCredit, [string[]]$Subtitles, [string]$Header, [string[]]$Description, [hashtable[]]$Options) {
	do {
		# Thanks https://github.com/massgravel/Microsoft-Activation-Scripts for the UI
		Clear-Host
		Write-Output "`n"
		Write-TopBorder
		Write-BlankMenuLine
		Write-BlankMenuLine
		Write-MenuLine -Contents "CCSTOPPER $Version" -Center
		if ($VerCredit) {
			if ($Subtitles) {
				$Subtitles += ""
			}
			$Subtitles += "Made by eaaasun"
			$VerCredit = $false
		}
		foreach ($Subtitle in $Subtitles) {
			Write-MenuLine -Contents $Subtitle -Center
		}
		Write-TextBorder
		Write-BlankMenuLine
		Write-MenuLine -Contents $($Header.ToUpper()) -Center
		if (!([String]::IsNullOrEmpty($Description))) {
			Write-BlankMenuLine
			foreach ($TxtBlock in $Description) {
				Write-MenuLine -Contents $TxtBlock
			}
		}

		if ($Options.Length -gt 0) {
			Write-TextBorder
			Write-BlankMenuLine
		}

		$NameLengths = @()
		foreach ($Option in $Options) {
			$Num = $Options.IndexOf($Option) + 1
			$NumText = "[$Num]"
			$Result = $NumText + " " + $Option.Name
			$NameLengths += , $Result.Length
		}
		$LargestNameLength = ($NameLengths | Measure-Object -Maximum).Maximum

		foreach ($Option in $Options) {
			$Num = $Options.IndexOf($Option) + 1
			$NumText = "[$Num]"
			$Result = $NumText + " " + $Option.Name
			if ($Option.ContainsKey("Description")) {
				0.."$($LargestNameLength-1)" | Where-Object { $_ -ge $Result.Length } | ForEach-Object { $Result += " " }

				$NextExtra = ""
				0.."$($Result.Length-1)" | ForEach-Object { $NextExtra += " " }

				$NextExtra += $Gap + $Border + " "
				$Result += $Gap + $Border + " "

				$Result += $Option.Description
			}

			$Parameters = @{ Contents = $Result }
			if (Test-Path variable:NextExtra) { $Parameters.Add("NextExtra", $NextExtra) }

			Write-MenuLine @Parameters
			if ($Option -ne $Options[-1]) { Write-MenuLine -Contents $NextExtra }
		}
		if ($null -eq $Invalid) { $Invalid = $true }

		Write-TextBorder
		Write-BlankMenuLine

		if ($Back) { $Exit = "Main Menu" } else { $Exit = "Exit" }
		Write-MenuLine -Contents "[Q] $Exit"
		Write-BlankMenuLine

		Write-BottomBorder
		Write-Output "`n"

		ReadKey $($Options.Length)
		if ($Choice -eq "Q") { 
			if ($Exit -eq "Main Menu") { 
				MainMenu
   }
			else {
				stop-process -Id $PID
			}
		}

		foreach ($Option in $Options) {
			$Invalid = $false
			$ScriptBlock = $Option.Code
			$Num = $Options.IndexOf($Option) + 1
			if ($Choice -eq "D$Num") { Invoke-Command -ScriptBlock $ScriptBlock } else { $Invalid = $true }
		}
	} until (!($Invalid))
}

function RegBackup([string]$Module) {
	ShowMenu -Back -Subtitle "$Module Module" -Header "THIS WILL EDIT THE REGISTRY!" -Description "It is HIGHLY recommended to create a system restore point in case something goes wrong." -Options @(
		@{
			Name = "Make system restore point"
			Code = {
				Clear-Host
				Checkpoint-Computer -Description "Before CCStopper $Module" -RestorePointType "MODIFY_SETTINGS"
				EditReg
			}
		},
		@{
			Name = "Proceed without creating restore point"
			Code = { EditReg }
		}
	)
}