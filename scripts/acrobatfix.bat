@echo off

:: Check if target path exists
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Adobe\Adobe Acrobat\DC\Activation" /v IsNGLEnforced

if %ERRORLEVEL% EQU 1 (
echo The target registry key cannot be found, or it has been edited already. Cannot proceed with Acrobat fix. 
pause) else (
goto sysResPnt
)

exit

:sysResPnt
:: Asks for Administrator Permissions
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"
cls
color 70
echo.
echo                                      ---ESODA'S CREATIVE CLOUD STOPPER---
echo.
echo This will edit the registry to patch Acrobat. It is HIGHLY recommended to create a system restore point in case something goes wrong. 
:: Ask to create system restore point
set /p restorePntConfirm=Create system restore point? (y/n): 
:: Every other input other than "n" will create a system restore point
If /I "%restorePntConfirm%"=="n" (goto editReg) else (
	echo.
	echo Creating system restore point, please be patient.
	echo.
	Wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Before CCStopper Acrobat Fix Script", 100, 12
	goto editReg
	)
	pause
)



:editReg
:: goal: delete TestValue in Testkey, replace w/ TestValue1

reg add "HKLM\software\WOW6432Node\Adobe\Adobe Acrobat\DC\Activation" /v IsAMTEnforced /t REG_DWORD /d 1 /f /reg:64

reg delete "HKLM\software\WOW6432Node\Adobe\Adobe Acrobat\DC\Activation" /v IsNGLEnforced /f /reg:64

echo editreg success!
goto restartAsk
pause

:restartAsk
cls
echo.
echo                                      ---ESODA'S CREATIVE CLOUD STOPPER---
echo.
echo Acrobat patching is complete. The system needs to restart.
set /p restartConfirm=Restart? (y/n): 

If /I "%restartConfirm%"=="y" (
	:: Sets a restart to happen in 60 seconds
	cls
	shutdown /r /t 60

	
	) else (
	:: Reminds user to restart, then pauses the script
	cls
	echo.
	echo                                      ---ESODA'S CREATIVE CLOUD STOPPER---
	echo.
	echo You will need to manually restart for changes to take place.
	pause
)