@echo off
title CCStopper
cd /D "%~dp0"
set "Path=%Path%;%CD%;%CD%\Plugins;"
mode con: cols=100 lines=42

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
echo                  ^|                          ver. 1.1.4-dev                       ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|                         SAVE YOUR FILES!                      ^|
echo                  ^|                                                               ^|
echo                  ^|      Stopping Adobe processess will also close apps           ^|
echo                  ^|      like Photohsop/Premiere.                                 ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [1] Stop Adobe Processes & Services                      ^|
echo                  ^|                                                               ^|
echo                  ^|      [2] Remove Genuine Checker                               ^|
echo                  ^|                                                               ^|
echo                  ^|      [3] Patch Acrobat                                        ^|
echo                  ^|                                                               ^|
echo                  ^|      [4] Credit Card Prompt Fix                               ^|
echo                  ^|                                                               ^|
echo                  ^|      [5] Patch Host File                                      ^|
echo                  ^|                                                               ^|
echo                  ^|      [5] Hide "Creative Cloud Files" from File Explorer       ^|
echo                  ^|                                                               ^|
echo                  ^|      [6] Disable Adobe Processes & Services Auto-Start        ^|
echo                  ^|                                                               ^|
echo                  ^|      [7] Hide Trial Banner                                    ^|
echo                  ^|                                                               ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [8] Github Repo (Detailed instructions there)            ^|
echo                  ^|                                                               ^|
echo                  ^|      [9] Exit                                                 ^|
echo                  ^|                                                               ^|
echo                  ^|_______________________________________________________________^|
echo:          
choice /C:123456789 /N /M ">                                     Select [1,2,3,4,5,6,7,8,9]: "

cls
if errorlevel 9 exit
if errorlevel 8 (
	cls
	start https://github.com/eaaasun/CCStopper
	goto menu
)
if errorlevel 7 (
	:: Source: https://www.reddit.com/r/GenP/comments/qwermj/wrote_a_quick_script_to_fix_up_the_trial_banner/
	Powershell -ExecutionPolicy RemoteSigned -File .\scripts\TrialRemove.ps1
	goto menu
)
if errorlevel 6 (
	Powershell -ExecutionPolicy RemoteSigned -File .\scripts\DisableAutoStart.ps1
	goto menu
)
if errorlevel 5 (
	.\scripts\HideCCFiles.bat
	goto menu
)
if errorlevel 4 (
	.\scripts\CreditCardStop.bat
	goto menu
)
if errorlevel 3 (
	.\scripts\AcrobatFix.bat
	goto menu
)
if errorlevel 2 (
	.\scripts\AGSKill.bat
	goto menu
)
if errorlevel 1 (
	Powershell -ExecutionPolicy RemoteSigned -File .\scripts\ProcessKill.ps1
	goto menu
)