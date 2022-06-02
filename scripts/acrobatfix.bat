@echo off
title CCStopper - Acrobat Fix
mode con: cols=100 lines=36

:: Check if IsNGLEnforced already replaced w/ IsAMTEnforced
:patchCheck
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Adobe\Adobe Acrobat\DC\Activation" /v IsAMTEnforced

if %ERRORLEVEL% EQU 0 (
	cls
	echo.
	echo Acrobat has already been patched.
	pause
	exit
) else (
goto targetCheck
)

:: Check if target path exists
:targetCheck
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Adobe\Adobe Acrobat\DC\Activation" /v IsNGLEnforced

if %ERRORLEVEL% EQU 1 (
	cls
	echo The target registry key cannot be found. Cannot proceed with Acrobat fix.
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
echo                  ^|                        AcrobatFix Module                      ^|
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

if errorlevel 2 goto:editReg

if errorlevel 3 (
	start cmd /k %~dp0\..\CCStopper.bat
)

cls
echo beans
pause
exit
echo/
echo Creating system restore point, please be patient.
Wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Before CCStopper Acrobat Fix Script", 100, 12
goto editReg

:editReg
:: Adds IsAMTEnforced with proper values, then deletes IsNGLEnfoced
reg add "HKLM\Software\WOW6432Node\Adobe\Adobe Acrobat\DC\Activation" /v IsAMTEnforced /t REG_DWORD /d 1 /f /reg:64
reg delete "HKLM\Software\WOW6432Node\Adobe\Adobe Acrobat\DC\Activation" /v IsNGLEnforced /f /reg:64
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
echo                  ^|                        AcrobatFix Module                      ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|                   Acrobat patching complete!                  ^|
echo                  ^|                                                               ^|
echo                  ^|      The system needs to restart for changes to apply.        ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [1] Restart in 60 seconds.                               ^|
echo                  ^|                                                               ^|
echo                  ^|      [2] Skip (You will need to manually restart later)       ^|
echo                  ^|                                                               ^| 
echo                  ^|                                                               ^| 
echo                  ^|_______________________________________________________________^|
echo:          
choice /C:12 /N /M ">                                            Select [1,2]: "

if errorlevel 2 (
	start cmd /k %~dp0\..\CCStopper.bat
)
if errorlevel 1 (
	cls
	shutdown /r /t 60
)