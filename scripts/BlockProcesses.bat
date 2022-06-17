@echo off
title CCStopper - Block Adobe Processes
mode con: cols=100 lines=42

:: Asks for Administrator Permissions
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd","/c %~s0 ::","","runas",1)(window.close) && exit
cd /d "%~dp0"

setlocal EnableDelayedExpansion
for /f "usebackq delims=" %%a in (`reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"`) do (
	set key=%%a
	for %%f in (!key!) do set keyName=%%~nxf
	if "!keyName:~0,5!" equ "PHSP_" (
		for /f "usebackq tokens=3*" %%A IN (`reg query !key! /v InstallLocation`) do set psAppLocation=%%A %%B
	)
)
setlocal DisableDelayedExpansion

:: Thanks to Verix#2020, from GenP Discord.
set file1="%ProgramFiles(x86)%\Adobe\Adobe Sync\CoreSync\CoreSync.exe"
set file2="%ProgramFiles%\Adobe\Adobe Creative Cloud Experience\CCXProcess.exe"
set file3="%ProgramFiles(x86)%\Common Files\Adobe\Adobe Desktop Common\ADS\Adobe Desktop Service.exe"
set file4="%ProgramFiles%\Common Files\Adobe\Creative Cloud Libraries\CCLibrary.exe"
set file5="%psAppLocation%\LogTransport2.exe"
set file6="%ProgramFiles(x86)%\Adobe\Acrobat DC\Acrobat\AdobeCollabSync.exe"
set files=%file1% %file2% %file3% %file4% %file5% %file6%

set isNotBlocked=false
set isBlocked=false

:: Check if files are already blocked
:blockedCheck
for %%a in (%files%) do (
	if exist %%a (
		icacls %%a | findstr "BUILTIN\Administrators:(N)" >nul 2>&1
		if errorlevel 1 (
			set isNotBlocked=true
		) else (
			if errorlevel 0 (
				set isBlocked=true	
			)
		)
	)
)

if %isBlocked% == true (
	cls
	echo:
	echo:
	echo                   _______________________________________________________________
	echo                  ^|                                                               ^| 
	echo                  ^|                                                               ^|
	echo                  ^|                           CCSTOPPER                           ^|
	echo                  ^|                     BlockProcesses Module                     ^|
	echo                  ^|      ___________________________________________________      ^|
	echo                  ^|                                                               ^|
	echo                  ^|             ADOBE PROCESSES ARE ALREADY BLOCKED!              ^|
	echo                  ^|                                                               ^|
	echo                  ^|          Would you like to restore those processes?           ^|
	echo                  ^|      ___________________________________________________      ^|
	echo                  ^|                                                               ^|
	echo                  ^|      [1] Restore Adobe processes                              ^|
	echo                  ^|      ___________________________________________________      ^|
	echo                  ^|                                                               ^|
	echo                  ^|      [Q] Exit Module                                          ^|
	echo                  ^|                                                               ^|
	echo                  ^|                                                               ^|
	echo                  ^|_______________________________________________________________^|
	echo:          
	choice /C:1Q /N /M ">                                            Select [1,Q]: "
	if errorlevel 2 (
		goto exit
	)
	if errorlevel 1 (
		goto mainScript
	)
)
if %isNotBlocked% == true (
	goto mainScript
)

:exit
start cmd /k %~dp0\..\CCStopper.bat
exit

:mainScript
Powershell -ExecutionPolicy RemoteSigned -File .\StopProcesses.ps1
for %%a in (%files%) do (
	if %isBlocked% == true (
		icacls %%a /reset >nul 2>&1
	) else (
		if %isNotBlocked% == true (
			icacls %%a /deny Administrators:^(F^) >nul 2>&1
		)
	)
)
goto done

:done
cls
:: Thanks https://github.com/massgravel/Microsoft-Activation-Scripts for the UI
echo:
echo:
echo                   _______________________________________________________________
echo                  ^|                                                               ^| 
echo                  ^|                                                               ^|
echo                  ^|                           CCSTOPPER                           ^|
echo                  ^|                     BlockProcesses Module                     ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
if %isBlocked% == true (
echo                  ^|                      Unblocked processes!                     ^|
) else (
	if %isNotBlocked% == true (
echo                  ^|              Blocking adobe processes complete!               ^|
	)
)
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [Q] Exit Module                                          ^|
echo                  ^|                                                               ^| 
echo                  ^|                                                               ^| 
echo                  ^|_______________________________________________________________^|
echo:          
choice /C:Q /N /M ">                                            Select [Q]: "

if errorlevel 1 (
	goto exit
)