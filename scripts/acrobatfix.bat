@echo off

:: TODO: Check if acrobat exists before anything else, display message if it does not exist. Maybe by checking if the registry value exists? (That way it could detect if the target value exists or not)


:: Asks for Administrator Permissions
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"

color 70
echo.
echo                                      ---ESODA'S CREATIVE CLOUD STOPPER---
echo.
echo This will edit the registry. It is HIGHLY recommended to create a system restore point in case something goes wrong. 
:: Ask to create system restore point
set /p restorePntConfirm=Create system restore point? (y/n): 
:: Every other option other than "n" will create a system restore point
If /I "%restorePntConfirm%"=="n" (goto editReg) else (goto makeRestorePnt)

echo after restore point confirmation

:makeRestorePnt
echo.
echo Creating system resttore point, please be patient.
echo.
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "ESodaAcrobatFix", 100, 7)
goto editReg

:editReg

echo editreg success!


:restartAsk
cls
echo.
echo Fixing Acrobat is complete. The system needs to restart.
set /p restartConfirm=Restart? (y/n): 

If /I "%restartConfirm%"=="y" (
	echo.
	echo The system will restart in 60 seconds.
	shutdown /r /t 60
	
	)
	
	else (
	:: Reminds user to restart, then pauses the script
	echo.
	echo You will need to manually restart for changes to take place.
	pause
)

pause