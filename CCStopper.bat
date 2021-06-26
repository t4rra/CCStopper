@echo off
title CCStopper - esoda
Set "Path=%Path%;%CD%;%CD%\Plugins;"

:updateCHK
:: Update Checker
set local=1.1.0-dev

:internetCHK
:: Check if comptuer can connect to google.com, if not, skip directly to menu

echo Checking internet connection...
echo.
Ping www.google.com -n 1 -w 1000
cls
if errorlevel 1 (
	set remote=N/A
	echo.
	echo                                      ---ESODA'S CREATIVE CLOUD STOPPER---
	echo.

	echo The internet cannot be reached right now, cannot check for updates.
	pause
	goto menu
)

:: Source: https://github.com/nicamoq/batupdate
:: Local is installed ver. remote is latest ver.
set remote=%local%
set link=https://raw.githubusercontent.com/E-Soda/CCStopper/main/version.bat
:: Deletes version.bat if it exists
:check
IF EXIST "version.bat" DEL /Q "version.bat"
goto download
pause

:: Main download process
:download
download %link% version.bat
call "version.bat"
goto check-2


:: Check-2 checks if the current version matches the remote.
:check-2
IF "%local%"=="%remote%" (goto menu) else (goto update)
:: IF NOT "%local%"=="%remote%" goto update

:update
cls
echo.
echo                                      ---ESODA'S CREATIVE CLOUD STOPPER---
echo.
echo. Update found!  Current version: %local%. Latest version: %remote%.
echo.
echo. It is recommended that you update the script. Would you like to go to the Github Repo (1) or skip this update (2)?

call Button 1 7 F9 "Update" 15 7 F4 "Skip" X _Var_Box _Var_Hover
If /I "%Errorlevel%"=="1" start https://github.com/E-Soda/CCStopper/releases
GetInput /M %_Var_Box% /H %_Var_Hover% 

goto menu
pause

:: Main script
:menu
cls



echo.
echo                                      ---ESODA'S CREATIVE CLOUD STOPPER---
echo.
echo. Get rid of Adobe's pesky background apps and more!
echo. Made by esoda (E-Soda on Github)
echo.
echo. Current version: %local%. Latest version: %remote%.
echo.
echo. MAKE SURE TO SAVE YOUR FILES! Ending Adobe processes will also close apps like Photoshop, After Effects, etc. 
echo.

call Button 1 10 F9 "End Adobe Processes" 27 10 F9 "Remove AGS"  43 10 F9 "Patch Acrobat" 1 14 FC "Check For Updates" 24 14 FC "Exit"  X _Var_Box _Var_Hover
GetInput /M %_Var_Box% /H %_Var_Hover% 


If /I "%Errorlevel%"=="1" goto processkill
If /I "%Errorlevel%"=="2" goto agskill
If /I "%Errorlevel%"=="3" goto acrobatfix
If /I "%Errorlevel%"=="4" goto updateCHK

If /I "%Errorlevel%"=="5" goto quit

goto other

:processkill
cls
Powershell.exe -executionpolicy remotesigned -File  .\scripts\ProcessKill.ps1
goto menu

:agskill
cls

.\scripts\AGSKill.bat
goto menu

:acrobatfix
cls

.\scripts\acrobatfix.bat
goto menu

:quit
exit

:other
cls
echo.
echo                                      ---ESODA'S CREATIVE CLOUD STOPPER---
echo.

echo That's not a valid option!
pause
goto menu
