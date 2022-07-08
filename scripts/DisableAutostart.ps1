Import-Module $PSScriptRoot\Functions.ps1
Init -Title "Disable Autostart"

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
	ShowMenu -Subtitles "DisableAutostart Module" if ($AutostartDisabled) { -Header "Enabling Autostart Complete!" } else { -Header "Disabling Autostart Complete!" }
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
		}
		Finally {
			$Kernel32::LocalFree($ParsedArgsPtr) | Out-Null
		}
		$PassedArgs2 = @()
		# -lt to skip the last item, which is a NULL ptr
		for ($I = 0; $I -lt $ParsedArgCount; $I += 1) {
			$PassedArgs2 += $ParsedArgs[$i]
		}
		$File = $PassedArgs2[0]
		if (!(Test-Path -Path $File)) {
			$File = $CommandLine
		}

		(Get-Item $File).VersionInfo | Where-Object { $_.CompanyName -match "Adobe" -or $File -match "Adobe" } | ForEach-Object {
			$Programs += $Name
		}
	}
}

function EnableAutostart {
	# Enable services auto-start
	Get-Service -DisplayName Adobe* | Set-Service -StartupType Automatic

	# Enable the processes the same way task manager does it
	foreach ($Program in $Programs) {
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run32" -Name $Program -Value ([byte[]](0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00))
	}
}

function DisableAutostart {
	# Disable services auto-start
	Get-Service -DisplayName Adobe* | Set-Service -StartupType Manual

	# Disable the processes the same way task manager does it
	foreach ($Program in $Programs) {
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run32" -Name $Program -Value ([byte[]](0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00))
	}
}

function EditReg {
	# Adds IsAMTEnforced with proper values, then deletes IsNGLEnfoced
	if ($AutostartDisabled -eq $true) {
		EnableAutostart
	}
 else {
		DisableAutostart
	}
	RestartAsk
}

foreach ($Program in $Programs) {
	$ByteArray = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run32").$Program
	$Data = ([System.BitConverter]::ToString([byte[]]$ByteArray)).Split('-')
}
#([byte[]](0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00))

# Check if autostart is already disabled
$AutostartDisabled = $false

if ($Data[0] -eq "03") {
	$AutostartDisabled = $true
	ShowMenu -Back -Subtitles "DisableAutostart Module" -Header "AUTOSTART IS ALREADY DISABLED!" -Description "Would you like to enable autostart?" -Options @(
		@{
			Name = "Enable autostart"
			Code = {
				RegBackup -Msg "Disable Autostart"
			}
		}
	)
}
else {
	RegBackup -Msg "Disable Autostart"
}