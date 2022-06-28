if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
	Start-Process -FilePath PowerShell -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`" `"$($MyInvocation.MyCommand.UnboundArguments)`""
	Exit
}
Set-Location $PSScriptRoot
Clear-Host

function Set-ConsoleWindow([int]$Width, [int]$Height) {
	$WindowSize = $Host.UI.RawUI.WindowSize
	$WindowSize.Width = [Math]::Min($Width, $Host.UI.RawUI.BufferSize.Width)
	$WindowSize.Height = $Height

	try {
		$Host.UI.RawUI.WindowSize = $WindowSize
	} catch [System.Management.Automation.SetValueInvocationException] {
		$MaxValue = ($_.Exception.Message | Select-String "\d+").Matches[0].Value
		$WindowSize.Height = $MaxValue
		$Host.UI.RawUI.WindowSize = $WindowSize
	}
}

$Host.UI.RawUI.WindowTitle = "CCStopper - Disable Auto Start"
# Set-ConsoleWindow -Width 73 -Height 42

$Kernel32Definition = @'
	[DllImport("kernel32")]
	public static extern IntPtr GetCommandLineW();
	[DllImport("kernel32")]
	public static extern IntPtr LocalFree(IntPtr hMem);
'@
$Kernel32 = Add-Type -MemberDefinition $Kernel32Definition -Name 'Kernel32' -Namespace 'Win32' -PassThru

$Shell32Definition = @'
	[DllImport("shell32.dll", SetLastError = true)]
	public static extern IntPtr CommandLineToArgvW(
		[MarshalAs(UnmanagedType.LPWStr)] string lpCmdLine,
		out int pNumArgs);
'@
$Shell32 = Add-Type -MemberDefinition $Shell32Definition -Name 'Shell32' -Namespace 'Win32' -PassThru

function RestartAsk {
	Clear-Host
	# Thanks https://github.com/massgravel/Microsoft-Activation-Scripts for the UI
	Write-Host "`n"
	Write-Host "`n"
	Write-Host "                   _______________________________________________________________"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                            CCSTOPPER                          `|"
	Write-Host "                  `|                       DisableAutoStart Module                 `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	if($AutostartDisabled) {
		Write-Host "                  `|                 Enabling Autostart Complete                   `|"
	} else {
		Write-Host "                  `|                Disabling Autostart Complete                   `|"
	}
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      [Q] Exit Module                                          `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|_______________________________________________________________`|"
	Write-Host "`n"
	Do {
		$Invalid = $false
		$Choice = Read-Host ">                                            Select [Q]"
		Switch($Choice) {
			Q { Exit }
			Default {
				$Invalid = $true
				[Console]::Beep(500,100)
			}
		}
	} Until (!($Invalid))
}

$Programs = @()
Get-Item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run" | ForEach-Object {
   $Path = $_.PSPath
   $_.Property | ForEach-Object {
		$Name = $_
		$CommandLine = Get-ItemProperty -LiteralPath $Path -Name $Name | Select-Object -Expand $Name

		# If the value has arguments, strip them off
		# if($File -match '"') { $File = $File.Substring($File.IndexOf('"')+1, $File.LastIndexOf('"')-1) }
		$ParsedArgCount = 0
		$ParsedArgsPtr = $Shell32::CommandLineToArgvW($CommandLine, [ref]$ParsedArgCount)
		Try {
			$ParsedArgs = @();
			0..$ParsedArgCount | ForEach-Object {
				$ParsedArgs += [System.Runtime.InteropServices.Marshal]::PtrToStringUni([System.Runtime.InteropServices.Marshal]::ReadIntPtr($ParsedArgsPtr, $_ * [IntPtr]::Size))
			}
		} Finally {
			$Kernel32::LocalFree($ParsedArgsPtr) | Out-Null
		}
		$PassedArgs2 = @()
		# -lt to skip the last item, which is a NULL ptr
		for ($I = 0; $I -lt $ParsedArgCount; $I += 1) {
			$PassedArgs2 += $ParsedArgs[$i]
		}
		$File = $PassedArgs2[0]
		if(!(Test-Path -Path $File)) {
			$File = $CommandLine
		}

		(Get-Item $File).VersionInfo | Where-Object {$_.CompanyName -match "Adobe" -or $File -match "Adobe"} | ForEach-Object {
			$Programs += $Name
		}
	}
}

function EnableAutostart {
	# Enable services auto-start
	Get-Service -DisplayName Adobe* | Set-Service -StartupType Automatic
	
	# Enable the processes the same way task manager does it
	foreach ($Program in $Programs) {
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run32" -Name $Program -Value ([byte[]](0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00))
	}
}

function DisableAutoStart {
	# Disable services auto-start
	Get-Service -DisplayName Adobe* | Set-Service -StartupType Manual

	# Disable the processes the same way task manager does it
	foreach ($Program in $Programs) {
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run32" -Name $Program -Value ([byte[]](0x03,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00))
	}
}

function EditReg {
	# Adds IsAMTEnforced with proper values, then deletes IsNGLEnfoced
	if($AutostartDisabled -eq $true) {
		EnableAutostart
	} else {
		DisableAutostart
	}
	RestartAsk
}

function MainScript {
	Clear-Host
	# Thanks https://github.com/massgravel/Microsoft-Activation-Scripts for the UI
	Write-Host "`n"
	Write-Host "`n"
	Write-Host "                   _______________________________________________________________"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                            CCSTOPPER                          `|"
	Write-Host "                  `|                       DisableAutoStart Module                 `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                  THIS WILL EDIT THE REGISTRY!                 `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      It is HIGHLY recommended to create a system restore      `|"
	Write-Host "                  `|      point in case something goes wrong.                      `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      [1] Make system restore point                            `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      [2] Proceed without creating restore point               `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      [Q] Exit Module                                          `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|_______________________________________________________________`|"
	Write-Host "`n"
	Do {
		$Invalid = $false
		$Choice = Read-Host ">                                            Select [1,2,Q]"
		Switch($Choice) {
			Q { Exit }
			2 { EditReg }
			1 {
				Clear-Host
				Checkpoint-Computer -Description "Before CCStopper Disable Auto Start Script" -RestorePointType "MODIFY_SETTINGS"
				EditReg
			}
			Default {
				$Invalid = $true
				[Console]::Beep(500,100)
			}
		}
	} Until (!($Invalid))
}	

foreach ($Program in $Programs) {
	$ByteArray = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run32").$Program
	$Data = ([System.BitConverter]::ToString([byte[]]$ByteArray)).Split('-')
}
#([byte[]](0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00))

# Check if autostart is already disabled
$AutostartDisabled = $false

if($Data[0] -eq "03") {
	$AutostartDisabled = $true
	Clear-Host
	Write-Host "`n"
	Write-Host "`n"
	Write-Host "                   _______________________________________________________________"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                            CCSTOPPER                          `|"
	Write-Host "                  `|                       DisableAutoStart Module                 `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                  AUTO START ALREADY DISABLED!                 `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                Would you like enable auto start?              `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      [1] Enable Auto start                                    `|"
	Write-Host "                  `|      ___________________________________________________      `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|      [Q] Exit Module                                          `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|                                                               `|"
	Write-Host "                  `|_______________________________________________________________`|"
	Write-Host "`n"
	Do {
		$Invalid = $false
		$Choice = Read-Host ">                                            Select [1,Q]: "
		Switch($Choice) {
			Q { Exit }
			1 { MainScript }
			Default {
				$Invalid = $true
				[Console]::Beep(500,100)
			}
		}
	} Until (!($Invalid))
} else {
	MainScript
}