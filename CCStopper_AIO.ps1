# FUNCTIONS START
$Version = "v1.3.0-pre.1"

function ArrayFromText {
	param(
		[string]$Source,
		[switch]$IsLocal
	)

	# Read the content of the source, either local or remote
	$content = if ($IsLocal) { Get-Content $Source } else { (Invoke-WebRequest $Source -Headers @{"Cache-Control" = "no-cache" }).Content }

	# Split into an array and filter out empty lines and whitespace
	$content.Split("`n", [StringSplitOptions]::RemoveEmptyEntries) `
	| Where-Object { $_ -ne '' } `
	| ForEach-Object { $_.Trim() }
}

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

	$WindowTitle = "CCStopper_AIO"
	if ($Title) { $WindowTitle += " - $Title" }
	$Host.UI.RawUI.WindowTitle = $WindowTitle

	# reset color/font settings
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
		Write-MenuLine -Contents "CCSTOPPER" -Center
		if ($VerCredit) {
			if ($Subtitles) {
				$Subtitles += ""
			}
			$Subtitles += "Made by eaaasun"
			$Subtitles += $Version
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

		if ($Back) { $Exit = "Back" } else { $Exit = "Exit" }
		Write-MenuLine -Contents "[Q] $Exit"
		Write-BlankMenuLine

		Write-BottomBorder
		Write-Output "`n"

		ReadKey $($Options.Length)
		if ($Choice -eq "Q") { 
			if ($Exit -eq "Back") { 
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

# FUNCTIONS END
# ----------------------------------------
# MENU START
function MainMenu {
	Init -Title $Version
	ShowMenu -VerCredit -Header "SAVE YOUR FILES!" -Options @(
		@{
			Name        = "Stop Processes"
			Description = "Stops all Adobe Processes"
			Code        = {
				Init -Title "Stop Processes"

				# Stops Adobe Processes and Services, source: https://gist.github.com/carcheky/530fd85ffff6719486038542a8b5b997#gistcomment-3586740

				# Stop adobe services

				# Stop adobe processes
				$Processes = @()
				Get-Process * | Where-Object { $_.CompanyName -match "Adobe" -or $_.Path -match "Adobe" } | ForEach-Object {
					$Processes += , $_
					if ($_.mainWindowTitle.Length) {
						# Process has a window
						ShowMenu -Back -Subtitles "StopProcesses Module" -Header "THERE ARE ADOBE APPS OPEN!" -Description "Do you want to continue? Unsaved documents in Adobe apps will be lost" -Options @(
							@{
								Name = "Continue"
								Code = { continue }
							}
						)
					}
				}

				Get-Service -DisplayName Adobe* | Stop-Service
				Foreach ($Process in $Processes) { Stop-Process $Process -Force | Out-Null }
				ShowMenu -Back -Subtitles "StopProcesses Module" -Header "Stopping Adobe processes complete!"
			}
		},
		@{
			Name        = "Internet Patches"
			Description = "Firewall/hosts patches"
			Code        = { 
				ShowMenu -Back -VerCredit -Header "INTERNET PATCHES" -Description "Run modules again to remove patches." -Options @(
					@{
						Name        = "Firewall Blocks"
						Description = "Patches credit card trial popup through Windows firewall."
						Code        = {
							Init -Title "Firewall Block"

							$Files = @(
								@{
									Path  = "${Env:ProgramFiles(x86)}\Common Files\Adobe\Adobe Desktop Common\ADS\Adobe Desktop Service.exe"
									Check = $False
									Tag   = "desktop-service"
								},
								@{ 
									Path  = "$Env:ProgramFiles\Common Files\Adobe\Adobe Desktop Common\NGL\adobe_licensing_wf.exe"
									Check = $False
									Tag   = "licensing"
								},
								@{
									Path  = "$Env:ProgramFiles\Common Files\Adobe\Adobe Desktop Common\NGL\adobe_licensing_wf_helper.exe"
									Check = $False
									Tag   = "licensing-helper"
								}
							)

							# run checks for file
							foreach ($File in $Files) {
								# legacy check/remove
								$OldFirewallRuleName = "CCStopper-InternetBlock_$($Files.IndexOf($File))"
								Get-NetFirewallRule -DisplayName $OldFirewallRuleName -ErrorAction SilentlyContinue
								if ($?) {
									Remove-NetFirewallRule -DisplayName $OldFirewallRuleName
								}

								$FirewallRuleName = "CCStopper-InternetBlock_$($File.Tag)"
								if (Test-Path $File.Path) {
									# file exists
									Get-NetFirewallRule -DisplayName $FirewallRuleName -ErrorAction SilentlyContinue
									if ($?) {
										# Firewall rule exists
										$File.Check = $True
									}
									else {
										# Firewall rule does not exist; file exists
										$File.Check = "file"
									}
								}
								else {
									# File does not exist
									$File.Check = $False
								}
							}

							function FirewallAction([switch]$Remove) {
								$EndHeaderMSG = $Null
								foreach ($File in $Files) {
									$FirewallRuleName = "CCStopper-InternetBlock_$($File.Tag)"
									switch ($File.Check) {
										$True {
											if ($Remove) {
												# If file and firewall rule exist, and if remove flag is true, remove firewall rule
												Remove-NetFirewallRule -DisplayName $FirewallRuleName
												$EndHeaderMSG = "Firewall rules removed!"
											}
											else {
												ShowMenu -Back -Subtitles "FirewallBlock Module" -Header "Firewall Rules Already Set!" -Description "Would you like to remove all existing rules?" -Options @(
													@{
														Name = "Remove Rules"
														Code = { FirewallAction -Remove }
													}
												)
											}
										}
										"file" {
											# If file exists; Firewall rule does not exist, create firewall rule
											try {
												New-NetFirewallRule -DisplayName $FirewallRuleName -Direction Outbound -Program $File.Path -Action Block
											}
											catch {
												ShowMenu -Back -Subtitles "FirewallBlock Module" -Header "Error! Creating firewall rule failed!" -Description "Antivirus programs are known to interfere with this patch. Please check if that is the case, and try again."
											}
											$EndHeaderMSG = "Firewall rules created!"
										}
										$False {
											ShowMenu -Back -Subtitles "FirewallBlock Module" -Header "Error! File not found!" -Description "Files that need to be blocked in the firewall could not be found. If the trial prompts are still displayed, please check issue #67 first, then open an issue on the Github repo."
										}
									}
								}
								ShowMenu -Back -Subtitles "FirewallBlock Module" -Header $EndHeaderMSG -Description "Operation has been completed successfully."
							}

							FirewallAction
						}
					},
					@{
						Name        = "Add to Hosts"
						Description = "Blocks unnecessary Adobe servers in the hosts file."
						Code        = { 
							Init -Title "Hosts Block"

							$StartCommentedLine = "`# START CCStopper Block List - DO NOT EDIT THIS LINE"
							$EndCommentedLine = "`# END CCStopper Block List - DO NOT EDIT THIS LINE"
							
							$LocalAddress = "0.0.0.0"
							$HostsFile = "$Env:SystemRoot\System32\drivers\etc\hosts"
							
							# Local Hosts list will only be used once to create data.txt if it doesn't exist
							$LocalHostsList = @(
								"ic.adobe.io",
								"52.6.155.20",
								"52.10.49.85",
								"23.22.30.141",
								"34.215.42.13",
								"52.84.156.37",
								"65.8.207.109",
								"3.220.11.113",
								"3.221.72.231",
								"3.216.32.253",
								"3.208.248.199",
								"3.219.243.226",
								"13.227.103.57",
								"34.192.151.90",
								"34.237.241.83",
								"44.240.189.42",
								"52.20.222.155",
								"52.208.86.132",
								"54.208.86.132",
								"63.140.38.120",
								"63.140.38.160",
								"63.140.38.169",
								"63.140.38.219",
								"wip.adobe.com",
								"adobeereg.com",
								"18.228.243.121",
								"18.230.164.221",
								"54.156.135.114",
								"54.221.228.134",
								"54.224.241.105",
								"100.24.211.130",
								"162.247.242.20",
								"wip1.adobe.com",
								"wip2.adobe.com",
								"wip3.adobe.com",
								"wip4.adobe.com",
								"3dns.adobe.com",
								"ereg.adobe.com",
								"199.232.114.137",
								"bam.nr-data.net",
								"practivate.adobe",
								"ood.opsource.net",
								"crl.verisign.net",
								"3dns-1.adobe.com",
								"3dns-2.adobe.com",
								"3dns-3.adobe.com",
								"3dns-4.adobe.com",
								"hl2rcv.adobe.com",
								"genuine.adobe.com",
								"www.adobeereg.com",
								"www.wip.adobe.com",
								"www.wip1.adobe.com",
								"www.wip2.adobe.com",
								"www.wip3.adobe.com",
								"www.wip4.adobe.com",
								"ereg.wip.adobe.com",
								"activate.adobe.com",
								"adobe-dns.adobe.com",
								"ereg.wip1.adobe.com",
								"ereg.wip2.adobe.com",
								"ereg.wip3.adobe.com",
								"ereg.wip4.adobe.com",
								"cc-api-data.adobe.io",
								"practivate.adobe.ntp",
								"practivate.adobe.ipp",
								"practivate.adobe.com",
								"adobe-dns-1.adobe.com",
								"adobe-dns-2.adobe.com",
								"adobe-dns-3.adobe.com",
								"adobe-dns-4.adobe.com",
								"lm.licenses.adobe.com",
								"hlrcv.stage.adobe.com",
								"prod.adobegenuine.com",
								"practivate.adobe.newoa",
								"activate.wip.adobe.com",
								"activate-sea.adobe.com",
								"uds.licenses.adobe.com",
								"k.sni.global.fastly.net",
								"activate-sjc0.adobe.com",
								"activate.wip1.adobe.com",
								"activate.wip2.adobe.com",
								"activate.wip3.adobe.com",
								"activate.wip4.adobe.com",
								"na1r.services.adobe.com",
								"lmlicenses.wip4.adobe.com",
								"na2m-pr.licenses.adobe.com",
								"wwis-dubc1-vip60.adobe.com",
								"workflow-ui-prod.licensingstack.com",
								"5zgzzv92gn.adobe.io",
								"8ncdzpmmrg.adobe.io",
								"7m31guub0q.adobe.io",
								"jc95y2v12r.adobe.io",
								"ph0f2h2csf.adobe.io",
								"2ftem87osk.adobe.io"
							)
							
							# Check if github is reachable
							$GHConnected = Test-Connection -ComputerName github.com -Count 1 -Quiet
							# Check if avaliable update
							if ($GHConnected) {
								$remoteBlockedAddresses = ArrayFromText -Source "https://raw.githubusercontent.com/eaaasun/CCStopper/data/Hosts.txt"
							}
							
							# Check if /data/hosts is avaliable, if not make it
							if (!(Test-Path ".\data\Hosts.txt")) {
								New-Item -Path ".\data" -ItemType Directory
								New-Item -Path ".\data\Hosts.txt" -ItemType File
								if ($GHConnected) {
									$remoteBlockedAddresses | Out-File "$PSScriptRoot\data\Hosts.txt"
								}
								else {
									$LocalHostsList | Out-File "$PSScriptRoot\data\Hosts.txt"
								}
							}
							$BlockedAddresses = ArrayFromText -Source ".\data\Hosts.txt" -IsLocal
							$UpdateAvaliable = (Compare-Object $remoteBlockedAddresses $BlockedAddresses -SyncWindow 0) -and $GHConnected
							
							# legacy migration
							# # check if "# CCStopper Adobe Block List" line exists
							if (Select-String -Path $HostsFile -Pattern "`# CCStopper Adobe Block List") {
								# loop through each item in localhostslist and check if it exists in hosts file, delete the line if it does
								$OriginalHosts = [System.IO.File]::ReadAllText($(Get-Item($HostsFile)).FullName)
								$Unwanted += "`# CCStopper Adobe Block List"
								foreach ($Address in $BlockedAddresses) {
									# find match in hosts file, if so remove it if not skip
									if (Select-String -Path $HostsFile -Pattern "$LocalAddress $Address") {
										$Unwanted += "`r`n$LocalAddress $Address"
									}
								}
								$NewText = $OriginalHosts -split $Unwanted, 0, 'simplematch' -join ''
								[System.IO.File]::WriteAllText($HostsFile, $NewText)
							}
							
							
							
							
							function addToHosts {
								$BlockedAddresses = ArrayFromText -Source "$PSScriptRoot\data\Hosts.txt" -IsLocal
								[System.IO.File]::AppendAllText($HostsFile, "`r`n$StartCommentedLine")
								RemoveEndBlankLine
								# Add blocked addresses to hosts file
								foreach ($Address in $BlockedAddresses) {
									[System.IO.File]::AppendAllText($HostsFile, "`r`n$LocalAddress $Address")
								}
								[System.IO.File]::AppendAllText($HostsFile, "`r`n$EndCommentedLine")
							}
							
							function removeFromHosts {
								# Source: https://social.technet.microsoft.com/Forums/en-US/8a4393f1-9ca6-46d3-933c-07217fa12695/string-replace-error-in-powershell
								$OriginalHosts = [System.IO.File]::ReadAllText($(Get-Item($HostsFile)).FullName)
								# add all lines of text between start and end commented lines to $Unwanted
								$pattern = "(?s)$StartCommentedLine(.*?)$EndCommentedLine"
								$Unwanted = $OriginalHosts | Select-String -Pattern $pattern -AllMatches | ForEach-Object { $_.Matches.Value }
								$NewText = $OriginalHosts -split $Unwanted, 0, 'simplematch' -join ''
								[System.IO.File]::WriteAllText($HostsFile, $NewText)
								RemoveEndBlankLine
							}
							
							function updateHosts {
								removeFromHosts
								$remoteBlockedAddresses | Out-File "$PSScriptRoot\data\Hosts.txt"
								addToHosts
							}
							
							function RemoveEndBlankLine {
								# Source: https://www.reddit.com/r/PowerShell/comments/68sa4e/comment/dh0wyxp/?utm_source=share&utm_medium=web2x&context=3
								$Newtext = (Get-Content -Path $HostsFile -Raw) -replace "(?s)`r`n\s*$"
								[System.IO.File]::WriteAllText($HostsFile, $Newtext)	
							}
							
							if (Test-Path $HostsFile) {
								# Source: https://stackoverflow.com/a/22943669
								try {
									[IO.File]::OpenWrite($HostsFile).close()
								}
								catch {
									ShowMenu -Back -Subtitles "HostBlock Module" -Header "Cannot write to hosts file!" -Description "Would you like to grant permissions to write to the hosts file? This may impact the security of your system." -Options @(
										@{
											Name = "Grant write permissions for hosts file"
											Code = {
												icacls $HostsFile /grant "Everyone:(w)"
											}
										}
									)
								}
							
								$StringSearch = Select-String -Path $HostsFile -Pattern $("$StartCommentedLine") -CaseSensitive -Quiet
							
								if ($StringSearch) {
									# blocked addresses already in hosts file
									if ($UpdateAvaliable) {
										$HeaderMSG = "Update avaliable!"
										$DescMSG = "Would you like to update?"
									}
									else {
										$HeaderMSG = "Blocked addresses already in hosts file!"
										$DescMSG = "Would you like to remove them?"
									}
									ShowMenu -Back -Subtitles "HostBlock Module" -Header $HeaderMSG -Description $DescMSG -Options @(
										@{
											Name = "Remove addresses from hosts file"
											Code = {
												removeFromHosts
												ShowMenu -Back -Subtitles "HostBlock Module" -Header "Successfully removed blocked lines from hosts file!"
							
											}
										} 
										if ($UpdateAvaliable) {
											, @{
												Name = "Update blocklist and apply to hosts file"
												Code = {
													updateHosts 
													ShowMenu -Back -Subtitles "HostBlock Module" -Header "Successfully updated hosts file!"	
												}
											}
										}
									)
								}
								else {
									# blocked addresses not in hosts file
									if ($UpdateAvaliable) {
										ShowMenu -Back -Subtitles "HostBlock Module" -Header "Hosts update available!" -Description "Would you like to update?" -Options @(
											@{
												Name = "Ignore update and apply to hosts file"
												Code = {
													addToHosts 
													ShowMenu -Back -Subtitles "HostBlock Module" -Header "Successfully added blocked lines in hosts file!"	
												}
											},
											@{
												Name = "Update blocklist and apply to hosts file"
												Code = {
													updateHosts 
													ShowMenu -Back -Subtitles "HostBlock Module" -Header "Successfully updated/added blocked lines in hosts file!"	
												}
											}
							
										)
									}
									else {
										addToHosts
										ShowMenu -Back -Subtitles "HostBlock Module" -Header "Successfully added blocked lines in hosts file!"	
									}			
							 }
							
							}
							else {
								ShowMenu -Back -Subtitles "HostBlock Module" -Header "Hosts file not found!" -Description "Hosts file could not be found.", "", "If your hosts file exists and you see this error, open an issue on Github and include the target hosts file path:", "$HostsFile"
							}
						}
					}
				)
			
			}
		},
		@{
			Name        = "System Patches"
			Description = "Creative Cloud app, Genuine checker, CC Folder patches"
			Code        = { 
				ShowMenu -Back -VerCredit -Header "SYSTEM PATCHES" -Description "Run modules again to remove patches." -Options @(
					@{
						Name        = "Creative Cloud App"
						Description = "Replaces the 'start trial' button in the Creative Cloud app. WILL CLOSE ALL ADOBE PROCESSES."
						Code        = {
							Init -Title "Patch CC App"
							# thanks genp discord							
							# check if backup exists
							$AppsPanelBL = "${env:Programfiles(x86)}\Common Files\Adobe\Adobe Desktop Common\AppsPanel\AppsPanelBL.dll"
							$AppsPanelBackup = "$AppsPanelBL.bak"
							# stop adobe desktop app process
							$Processes = @()
							Get-Process * | Where-Object { $_.CompanyName -match "Adobe" -or $_.Path -match "Adobe" } | ForEach-Object {
								$Processes += , $_
							}
							Foreach ($Process in $Processes) { Stop-Process $Process -Force | Out-Null }

							Get-Service -DisplayName Adobe* | Stop-Service
							if (Test-Path $AppsPanelBackup) {
								# backup exists, ask if user wants to restore
								ShowMenu -Back -Subtitles "Patch CC App" -Header "Backup found!" -Description "Would you like to restore the backup?" -Options @(
									@{
										Name = "Restore backup"
										Code = {
											# restore backup
											Remove-Item $AppsPanelBL
											Rename-Item $AppsPanelBackup -NewName "AppsPanelBL.dll"
											ShowMenu -Back -Subtitles "Patch Desktop App" -Header "Successfully restored backup!" -Description "You may need to restart your system for changes to apply."
										}
									}
								)
							}
							else {
								# backup doesn't exist, create backup and patch app
								# create backup
								Copy-Item $AppsPanelBL -Destination $AppsPanelBackup


								$bytes = [System.IO.File]::ReadAllBytes($AppsPanelBL)
								$bytes[1092204] = 0xfe
								$bytes[1190497] = 0xfe
								$bytes[1953393] = 0xfe
								$bytes[2110587] = 0xfe
								$bytes[2112012] = 0xfe
								$bytes[2112527] = 0xfe
								$bytes[2113327] = 0xfe
								$bytes[2234425] = 0xc6
								$bytes[2234426] = 0x40
								$bytes[2234435] = 0xc6
								$bytes[2234436] = 0x40
								$bytes[2234445] = 0xc6
								$bytes[2234446] = 0x40
								$bytes[2391429] = 0xc6
								$bytes[2391430] = 0x40
								$bytes[2391439] = 0xc6
								$bytes[2391440] = 0x40
								$bytes[2391449] = 0xc6
								$bytes[2391450] = 0x40
								[System.IO.File]::WriteAllBytes($AppsPanelBL, $bytes)
								ShowMenu -Back -Subtitles "Patch Desktop App" -Header "Successfully patched desktop app!" -Description "You may need to restart your system for changes to apply."
						
							}
						}
					},
					@{
						Name        = "Genuine Checker"
						Description = "Replaces and locks the Genuine Checker folder."
						Code        = {
							Init -Title "Remove AGS"

							$BlockItems = @(
								@{
									Path  = "${Env:ProgramFiles(x86)}\Adobe\Adobe Creative Cloud\Utils\AdobeGenuineValidator.exe"
									Check = $False
								},
								@{
									Path  = "${Env:ProgramFiles(x86)}\Common Files\Adobe\AdobeGCClient"
									Check = $False
								}
							)


							# check if modified files/folders exist, if so, present option to restore them (if yes, unlock and remove .bak from name), if not, lock and rename w/ .bak at end

							function ReplaceItem($Item) {
								takeown /f $Item
								$ItemBak = $Item + ".bak"
								$DirCheck = (Get-Item -Path $Item) -is [System.IO.DirectoryInfo]

								# rename existing folder/file to .bak
								Rename-Item $Item $ItemBak
								# create new folder/file
								if ($DirCheck) {
									New-Item -Path $Item -ItemType "Directory"
								}
								else {
									New-Item -Path $Item -ItemType "File"
								}
								# at this point, $Item is a new file/folder (with nothing!), and $ItemBak is the old file/folder (with everything!)
								# lock new file/folder

								$Acl = Get-Acl -Path $Item
								Set-Acl -Path $Item -AclObject $Acl # Reorder ACL to canonical order to prevent errors
								$FileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList @("BUILTIN\Administrators", "FullControl", "Deny")
								$Acl.SetAccessRule($FileSystemAccessRule)
								Set-Acl -Path $Item -AclObject $Acl
							}

							function RestoreItem($Item) {
								$Acl = Get-Acl -Path $Item
								Set-Acl -Path $Item -AclObject $Acl # Reorder ACL to canonical order to prevent errors
								$Acl.Access | ForEach-Object { $acl.RemoveAccessRule($_) }
								Set-Acl -Path $Item -AclObject $Acl
								Remove-Item $Item
								$ItemBak = $Item + ".bak"
								Rename-Item $ItemBak $Item
							}

							# what happens if no file is found: continue until all files are scanned, then proceed w/ the ones that exist

							foreach ($BlockItem in $BlockItems) {
								if (Test-Path -Path $BlockItem.Path) {
									$BlockItemBak = $BlockItem.Path + ".bak"
									if (Test-Path -Path $BlockItemBak) {
										$BlockItem.Check = "backupped"
									}
									else {
										$BlockItem.Check = $True
										ReplaceItem($BlockItem.Path)
									}
								}
								else {
									$BlockItem.Check = $False
								}
							}

							switch ($BlockItem.Check) {
								"backupped" {
									ShowMenu -Back -Subtitles "RemoveAGS Module" -Header "Already applied patch!" -Description "Would you like to restore original files?" -Options @(
										@{
											Name = "Restore original files"
											Code = {
												foreach ($BlockItem in $BlockItems) {
													RestoreItem($BlockItem.Path) | Out-Null
												}
											}
										}
									)
								}
								$False {
									ShowMenu -Back -Subtitles "RemoveAGS Module" -Header "Genuine Checker not found!" -Description "Genuine Checker files could not be found. This may not be a problem. If the files aren't there, they won't work."
								}
							}

							# Disable AGSSerivce from starting up and stop it
							Foreach ($Service in @("AGSService", "AGMService")) {
								Get-Service -DisplayName $Service | Set-Service -StartupType Disabled
								Get-Service -DisplayName $Service | Stop-Service
								Stop-Process -Name $Service -Force | Out-Null
							}

							ShowMenu -Back -Subtitles "RemoveAGS Module" -Header "Removing AGS complete!"
						}
					},
					@{
						Name        = "Hide CC Folder"
						Description = "Hides Creative Cloud folder in Windows Explorer."
						Code        = {
							Init -Title "Hide CC Folder"

							# Set-ConsoleWindow -Width 73 -Height 42

							# import library to restore open explorer windows
							$Sig = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
							Add-Type -MemberDefinition $Sig -name NativeMethods -namespace Win32

							function Get-Subkey([String]$Key, [String]$SubkeyPattern) {
								return (Get-ChildItem $Key -Recurse | Where-Object { $_.PSChildName -Like "$SubkeyPattern" }).Name
							}

							function RestartAsk {
								if ($Data -eq 0) {
									$RestartMSG = "Restored Creative Cloud Folder!"
								}
								else {
									$RestartMSG = "Hidden Creative CLoud Folder!"
								}
								ShowMenu -Subtitles "HideCCFolder Module" -Header $RestartMSG -Description "Windows Explorer needs to restart for changes to apply. Things will flash; please don't worry." -Options @(
									@{
										Name = "Restart Now"
										Code = {
											# Save open folders
											$OpenFolders = @()
											$Shell = New-Object -ComObject Shell.Application
											$Shell.Windows() | ForEach-Object { $OpenFolders += $_.LocationURL }

											# Restart Windows Explorer
											Stop-Process -Name "explorer" -Force

											# Wait for explorer to be restarted
											while ((Get-Process -Name "explorer" -ErrorAction SilentlyContinue).Count -eq 0) { Start-Sleep -Milliseconds 100 }

											# Restore file explorer windows
											$OpenFolders | ForEach-Object { Invoke-Item $([Uri]::UnescapeDataString(([System.Uri]$($_)).AbsolutePath)) } | Out-Null

											# Show the windows
											$Handle = (Get-Process "explorer").MainWindowHandle
											$Handle | ForEach-Object {
												[Win32.NativeMethods]::SetForegroundWindow($_)
												[Win32.NativeMethods]::ShowWindowAsync($_, 4)
											}
											MainMenu
										}
									}
								)
							}

							function SetFolder([String]$Value) {
								# Shows CCF in file explorer
								Set-ItemProperty -Path Registry::$CLSID -Name System.IsPinnedToNameSpaceTree -Value $Value
							}

							$CLSID = (Get-Subkey -Key "HKCU:\SOFTWARE\Classes\CLSID" -SubkeyPattern "{0E270DAA-1BE6-48F2-AC49-*")
							$Data = (Get-ItemProperty -Path Registry::$CLSID)."System.IsPinnedToNameSpaceTree"

							if ($Data -eq 0) {
								# folder hidden already
								ShowMenu -Back -Subtitles "HideCCFolder Module" -Header "Creative Cloud folder is already hidden!" -Description "Would you like to restore the folder's visibility?" -Options @(
									@{
										Name = "Restore Creative Cloud Files folder"
										Code = {
											RegBackup -Module "HideCCFolder"
											SetFolder 1
											RestartAsk
										}
									}
								)
							}
							else {
								RegBackup -Module "HideCCFolder"
								SetFolder 0
								RestartAsk
							}
						}
					}
				)
			
			}
		},
		@{
			Name        = "Other"
			Description = "Credits/Github Repo"
			Code        = { 
				ShowMenu -Back -Header "CREDITS" -Description "This project would be impossible without the people contributing to, testing, and supporting it.",
				"",
				"Creator/maintainer: @eaaasun",
				"",
				"Contributors:",
				"@ItsProfessional, @shdevnull, @ZEN1X",
				"",
				"Reporting bugs, supporting the project: You!" -Options @(
					@{
						Name = "Github Repo"
						Code = {
							Start-Process "https://github.com/eaaasun/CCStopper"
							MainMenu
						}
					}
				)			
			}
		}
	)
}

$modeCommand = "mode con: cols=102 lines=36"

# Execute the mode.com command
cmd.exe /c $modeCommand | Out-Null

# Import the PSReadline module if not already imported
if (-not (Get-Module -Name PSReadline -ErrorAction SilentlyContinue)) {
	Import-Module PSReadline
}

MainMenu