@echo off

:: Check if target path exists
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Adobe\Adobe Acrobat\DC\Activation" /v IsNGLEnforced

if %ERRORLEVEL% EQU 1 (
echo The target registry key cannot be found, or it has been edited already. Cannot proceed with Acrobat fix.
) else (
goto sysResPnt
)

exit

:sysResPnt
:: Asks for Administrator Permissions
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"
cd ..
Set "Path=%Path%;%CD%;%CD%\Plugins;"

cls
echo.
echo                                      ---ESODA'S CREATIVE CLOUD STOPPER---
echo.
echo. This will edit the registry to patch Acrobat.
echo. It is HIGHLY recommended to create a system restore point in case something goes wrong. 
:: Ask to create system restore point
call Button 1 6 F9 "Create Restore Point" 28 6 F4 "Skip" X _Var_Box _Var_Hover
GetInput /M %_Var_Box% /H %_Var_Hover% 

:: Every other input other than "n" will create a system restore point
If /I "%Errorlevel%"=="2" (goto editReg) else (
	cls
	echo.
	echo Creating system restore point, please be patient.
	echo.
	Wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Before CCStopper Acrobat Fix Script", 100, 12
	goto editReg
	)
	pause
)



:editReg
:: Adds IsAMTEnforced w/ proper values, then deletes IsNGLEnfoced

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
echo. Acrobat patching is complete. The system needs to restart for changes to apply.
call Button 1 6 F9 "Restart" 14 6 FC "Skip" X _Var_Box _Var_Hover
GetInput /M %_Var_Box% /H %_Var_Hover% 

If /I "%Errorlevel%"=="1" (
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