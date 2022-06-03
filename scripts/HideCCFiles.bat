@echo off
title CCStopper - Hide Creative Cloud Files
mode con: cols=100 lines=42

Setlocal EnableDelayedExpansion
for /f "usebackq delims=" %%a in (`reg query "HKEY_CURRENT_USER\SOFTWARE\Classes\CLSID"`) do (
	set key=%%a
	for %%f in (!key!) do set keyName=%%~nxf
	if "!keyName:~0,25!" equ "{0E270DAA-1BE6-48F2-AC49-" set clsid=!key!
)
Setlocal DisableDelayedExpansion

:: Check if System.IsPinnedToNameSpaceTree is already disabled
:patchCheck
for /f "usebackq tokens=3*" %%A IN (`reg query %clsid% /v System.IsPinnedToNameSpaceTree`) do set data=%%A %%B

if %data% EQU 0 (
	cls
	echo.
	echo Creative Cloud Files are already hidden.
	pause
	exit
) else (
	goto mainScript
)

:exit
start cmd /k %~dp0\..\CCStopper.bat
exit

:mainScript
:: Asks for Administrator Permissions
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd","/c %~s0 ::","","runas",1)(window.close) && exit
cd /d "%~dp0"

cls
:: Thanks https://github.com/massgravel/Microsoft-Activation-Scripts for the UI
echo:
echo:
echo                   _______________________________________________________________
echo                  ^|                                                               ^| 
echo                  ^|                                                               ^|
echo                  ^|                            CCSTOPPER                          ^|
echo                  ^|                         Made by eaaasun                       ^|
echo                  ^|                        HideCCFiles Module                     ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|                  THIS WILL EDIT THE REGISTRY!                 ^|
echo                  ^|                                                               ^|
echo                  ^|      It is HIGHLY recommended to create a system restore      ^|
echo                  ^|      point in case something goes wrong.                      ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [1] Make system restore point                            ^|
echo                  ^|                                                               ^|
echo                  ^|      [2] Proceed without creating restore point               ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [3] Exit                                                 ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|_______________________________________________________________^|
echo:          
choice /C:123 /N /M ">                                            Select [1,2,3]: "

cls
if errorlevel 3 (
	goto exit
)
if errorlevel 2 goto:editReg
if errorlevel 1 (
	echo Creating system restore point, please be patient.
	wmic /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Before CCStopper Hide CC Files Script", 100, 12
	goto editReg
)

:editReg
:: Hides CCF from file explorer
reg add %clsid% /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0 /f /reg:64
goto restartAsk
pause

:restartAsk
cls
:: Thanks https://github.com/massgravel/Microsoft-Activation-Scripts for the UI
echo:
echo:
echo                   _______________________________________________________________
echo                  ^|                                                               ^| 
echo                  ^|                                                               ^|
echo                  ^|                            CCSTOPPER                          ^|
echo                  ^|                         Made by eaaasun                       ^|
echo                  ^|                          HideCCF Module                       ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|                Hiding CCF from explorer complete!             ^|
echo                  ^|                                                               ^|
echo                  ^|      The system needs to restart for changes to apply.        ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [1] Restart now.                                         ^|
echo                  ^|                                                               ^|
echo                  ^|      [2] Skip (You will need to manually restart later)       ^|
echo                  ^|                                                               ^| 
echo                  ^|                                                               ^| 
echo                  ^|_______________________________________________________________^|
echo:          
choice /C:12 /N /M ">                                            Select [1,2]: "

if errorlevel 2 (
	goto exit
)
if errorlevel 1 (
	cls
	shutdown /r /t 0
)