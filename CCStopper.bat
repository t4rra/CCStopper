@echo off
title ESoda's Creative Cloud Stopper
color 70
:menu
cls
echo.
echo                                      ---ESODA'S CREATIVE CLOUD STOPPER---
echo.
echo Get rid of Adobe's pesky background apps and more!
echo Made by ESoda (E-Soda on Github)
echo.
echo NOTICE: Don't use this tool for piracy. It's illegal, and multi-billion dollar companies like Adobe *needs* to profit off of unreliable and overpriced software.
echo.
echo MAKE SURE TO SAVE YOUR FILES! This will kill all Adobe apps (INCLUDING Photoshop, After Effects, etc.)
echo.
echo MENU:
echo 1: Kill all running Adobe Processess 
echo 2: Delete Adobe Genuine Software Integrity Service (AdobeGCClient)
echo 0: Quit

set /p menu=Select an option: (1/2/3): 

If /I "%menu%"=="1" goto processkill
If /I "%menu%"=="2" goto agskill
If /I "%menu%"=="3" goto acrobatfix
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


goto menu

:quit
cls

echo.
echo                                      ---ESODA'S CREATIVE CLOUD STOPPER---
echo.
set /p quit=Are you sure you want to quit? (y/n): 
If /I "%quit%"=="y" exit
goto menu

:other
echo That's not a valid option!
pause
goto menu
