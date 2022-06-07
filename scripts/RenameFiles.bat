@echo off
title CCStopper - Rename Adobe Files
mode con: cols=100 lines=42

:: Asks for Administrator Permissions
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd","/c %~s0 ::","","runas",1)(window.close) && exit
cd /d "%~dp0"

:: Thanks to Verix#2020, from GenP Discord.
for /f "usebackq tokens=3*" %%A IN (`reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\PHSP_23_3" /v InstallLocation`) do set psAppLocation=%%A %%B

set file1="C:\Program Files (x86)\Adobe\Adobe Sync\CoreSync\CoreSync.exe"
set file2="C:\Program Files\Adobe\Adobe Creative Cloud Experience\CCXProcess.exe"
set file3="C:\Program Files (x86)\Common Files\Adobe\Adobe Desktop Common\ADS\Adobe Desktop Service.exe"
set file4="C:\Program Files\Common Files\Adobe\Creative Cloud Libraries\CCLibrary.exe"
set file5="%psAppLocation%\LogTransport2.exe"
set file6="C:\Program Files (x86)\Adobe\Acrobat DC\Acrobat\AdobeCollabSync.exe"
set files=%file1% %file2% %file3% %file4% %file5% %file6%

set targetExists=false
set renamedExists=false

:: Check if files are already renamed
:renamedCheck
setlocal EnableDelayedExpansion
for %%a in (%files%) do (
	set "_=%%a" & set renamed=!_:.exe=.exe.renamed!
	if exist !renamed! (
	 	set renamedExists=true	
	)
)
setlocal DisableDelayedExpansion

if %renamedExists% == true (
	cls
	echo:
	echo:
	echo                   _______________________________________________________________
	echo                  ^|                                                               ^| 
	echo                  ^|                                                               ^|
	echo                  ^|                            CCSTOPPER                          ^|
	echo                  ^|                         Made by eaaasun                       ^|
	echo                  ^|                        RenameFiles Module                     ^|
	echo                  ^|      ___________________________________________________      ^|
	echo                  ^|                                                               ^|
	echo                  ^|                ADOBE FILES ARE ALREADY RENAMED!               ^|
	echo                  ^|                                                               ^|
	echo                  ^|             Would you like to restore those files?            ^|
	echo                  ^|      ___________________________________________________      ^|
	echo                  ^|                                                               ^|
	echo                  ^|      [1] Restore Adobe files                                  ^|
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
) else (
	goto targetCheck
)

:: Check if target path exists
:targetCheck
for %%a in (%files%) do (
	if exist %%a (
		set targetExists=true	
	)
)

if %targetExists% == true (
	goto mainScript
) else (
	cls
	echo The target file cannot be found. Cannot proceed with renaming adobe files.
	pause
	goto exit
)

:exit
start cmd /k %~dp0\..\CCStopper.bat
exit

:mainScript
cls
:: Thanks https://github.com/massgravel/Microsoft-Activation-Scripts for the UI
echo:
echo:
echo                   _______________________________________________________________
echo                  ^|                                                               ^| 
echo                  ^|                                                               ^|
echo                  ^|                            CCSTOPPER                          ^|
echo                  ^|                         Made by eaaasun                       ^|
echo                  ^|                        RenameFiles Module                     ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|                  THIS WILL RENAME ADOBE FILES!                ^|
echo                  ^|                                                               ^|
echo                  ^|      It is HIGHLY recommended to backup the adobe files in    ^|
echo                  ^|      case something goes wrong. All adobe processes           ^|
echo                  ^|      will also be closed, in order to rename the files.       ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [1] Backup adobe files (Backup will be at C:\AdobeFiles) ^|
echo                  ^|                                                               ^|
echo                  ^|      [2] Proceed without backing up adobe files               ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [Q] Exit Module                                          ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|_______________________________________________________________^|
echo:          
choice /C:12Q /N /M ">                                            Select [1,2,Q]: "

cls
if errorlevel 3 (
	goto exit
)
if errorlevel 2 goto:renameFiles
if errorlevel 1 (
	for %%a in (%files%) do ( 
		setlocal EnableDelayedExpansion

		for %%f in (%%a) do set name=%%~nxf
		
		if %targetExists% == true (
			if not exist "C:\AdobeFiles" mkdir C:\AdobeFiles
			copy %%a "C:\AdobeFiles" /y >nul 2>&1
		)
		setlocal DisableDelayedExpansion
	)
)

:renameFiles
Powershell -ExecutionPolicy RemoteSigned -File .\StopProcesses.ps1
setlocal EnableDelayedExpansion
for %%a in (%files%) do (
	set "_=%%a" & set renamed=!_:.exe=.exe.renamed!

	for %%f in (%%a) do set name="%%~nxf"
	for %%f in (!renamed!) do set renamedName="%%~nxf"
	
	if %targetExists% == true (
		rename %%a !renamedName! >nul 2>&1
	) else if %renamedExists% == true (
		rename !renamed! !name! >nul 2>&1
	)
)
setlocal DisableDelayedExpansion
goto restartAsk

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
echo                  ^|                        RenameFiles Module                     ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|              Renaming adobe process files complete!           ^|
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