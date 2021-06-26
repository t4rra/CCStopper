@echo off
color 70
title CCStopper by ESoda

:updateCHK
:: Update Checker
set local=1.0.1

:internetCHK
:: Check if comptuer can connect to githubusercontent.com, if not, skip directly to menu

echo Checking internet connection...
echo.
Ping www.githubusercontent.com -n 1 -w 1000
cls
if errorlevel 1 (
	set remote=N/A
	echo.
	echo                                      ---ESODA'S CREATIVE CLOUD STOPPER---
	echo.

	echo Github cannot be reached right now, so this script cannot check for updates.
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
IF "%local%"=="%remote%" (goto noupdate) else (goto update)
:: IF NOT "%local%"=="%remote%" goto update

:update
cls
echo.
echo                                      ---ESODA'S CREATIVE CLOUD STOPPER---
echo.
echo Update found!  Current version: %local%. Latest version: %remote%.
echo.
echo It is recommended that you update the script. Would you like to go to the Github (1) or skip this update (2)?

set /p updatechoice=Select an option: (1/2):
If /I "%updatechoice%"=="1" start https://github.com/E-Soda/CCStopper/releases

goto menu
pause

:noupdate
cls
echo No updates found or update server cannot be accessed. Current version: %local%
pause
goto menu


:: Main script
:menu
cls
echo.
echo                                      ---ESODA'S CREATIVE CLOUD STOPPER---
echo.
echo Get rid of Adobe's pesky background apps and more!
echo Made by ESoda (E-Soda on Github)
echo.
echo Current version: %local%. Latest version: %remote%.
echo.
echo NOTICE: Don't use this tool for piracy. It's illegal, and multi-billion dollar companies like Adobe *needs* to profit off of unreliable and overpriced software.
echo Plus, Adobe will be sad :(
echo.
echo MAKE SURE TO SAVE YOUR FILES! This will kill all Adobe apps (INCLUDING Photoshop, After Effects, etc.)
echo.
echo MENU:
echo 1: Kill all running Adobe Processess 
echo 2: Delete Adobe Genuine Software Integrity Service (AdobeGCClient)
echo 3: Patch Acrobat
echo 4: Check for updates
echo 0: Quit
echo.
set /p menu=Select an option: (1/2/3/4/0): 

If /I "%menu%"=="1" goto processkill
If /I "%menu%"=="2" goto agskill
If /I "%menu%"=="3" goto acrobatfix
If /I "%menu%"=="4" goto updateCHK

If /I "%menu%"=="0" goto quit

goto other

:processkill
cls

echo.
echo                                      ---ESODA'S CREATIVE CLOUD STOPPER---
echo.
echo MAKE SURE TO SAVE YOUR FILES! This will kill all Adobe apps (INCLUDING Photoshop, After Effects, etc.)
echo.
set /p StopAppConfirm=Are you sure you want to continue? (y/n): 
If /I "%StopAppConfirm%"=="y" Powershell.exe -executionpolicy remotesigned -File  .\scripts\ProcessKill.ps1
goto menu

:agskill
cls

echo.
echo                                      ---ESODA'S CREATIVE CLOUD STOPPER---
echo.
set /p AGSDeleteConfirm=Are you sure you want to delete/disable AGS? (y/n): 
If /I "%AGSDeleteConfirm%"=="y" start .\scripts\AGSKill.bat
goto menu

:acrobatfix
cls

echo.
echo                                      ---ESODA'S CREATIVE CLOUD STOPPER---
echo.
set /p acrobatfixconfirm=Are you sure you want to patch Acrobat? (y/n): 
If /I "%acrobatfixconfirm%"=="y" start .\scripts\acrobatfix.bat
goto menu

:quit
exit

:other
echo That's not a valid option!
pause
goto menu
