@setlocal enableextensions enabledelayedexpansion
@echo off
title CCStopper - Patch Retention
Set "Path=%Path%;%CD%;%CD%\Plugins;"
mode con: cols=100 lines=36

:filePathSet

:: Asks for Administrator Permissions
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"

:: set adobe apps installation path
set paths="D:\Code\CCStopper\README.md"

:: Main script
:menu
cls
:: Thanks https://github.com/massgravel/Microsoft-Activation-Scripts for the UI
echo:
echo:
echo                   _______________________________________________________________
echo                  ^|                                                               ^| 
echo                  ^|                                                               ^|
echo                  ^|                            CCSTOPPER                          ^|
echo                  ^|                         Made by eaaasun                       ^|
echo                  ^|                   genP Patch Retention Module                 ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|                      PATCH WITH GENP FIRST!                   ^|
echo                  ^|                                                               ^|
echo                  ^|      This script prevents *any* program (including genP)      ^|
echo                  ^|      from messing with the patched files or files that        ^|
echo                  ^|      need to be patched.                                      ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|                                            ^|
echo                  ^|                                                               ^|
echo                  ^|      [1] Patch Apps                                           ^|
echo                  ^|                                                               ^|
echo                  ^|      [2] Reset patch (won't affect genP patch)                ^|
echo                  ^|                                                               ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [3] Set app installation path                            ^|
echo                  ^|                                                               ^|
echo                  ^|      [4] Back                                                 ^|
echo                  ^|                                                               ^|
echo                  ^|_______________________________________________________________^|
echo:          
choice /C:1234 /N /M ">                               Select [1,2,3,4]: "

if errorlevel  4 exit
if errorlevel  3 goto installPath
if errorlevel  2 (
	cls
	.\scripts\AGSKill.bat
	goto menu
)
if errorlevel  1 (
	cls
	Powershell.exe -executionpolicy remotesigned -File  .\scripts\ProcessKill.ps1
	goto menu
)


:: Deny permissions to file
@REM icacls %paths% /deny Administrators:(F)

cd %~dp0
cd ..
start cmd /k CCStopper.bat

:: test file picker
:installPath
setlocal

set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Choose folder where Adobe apps are installed.',0,0).self.path""

for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"

setlocal enabledelayedexpansion
:: !folder! is the path to the folder you chose
echo paths=!folder!>.\paths.ini
echo Path set successfully!
pause
endlocal