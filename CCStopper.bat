@echo off
title CCStopper
Set "Path=%Path%;%CD%;%CD%\Plugins;"
mode con: cols=100 lines=36

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
echo                  ^|                           ver. 1.1.3                          ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|                         SAVE YOUR FILES!                      ^|
echo                  ^|                                                               ^|
echo                  ^|      Stopping Adobe processess will also close apps           ^|
echo                  ^|      like Photohsop/Premiere.                                 ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [1] Stop Adobe Processess                                ^|
echo                  ^|                                                               ^|
echo                  ^|      [2] Remove Genuine Checker                               ^|
echo                  ^|                                                               ^|
echo                  ^|      [3] Patch Acrobat                                        ^|
echo                  ^|                                                               ^|
echo                  ^|      [4] Credit Card Prompt Fix                               ^|
echo                  ^|                                                               ^|
echo                  ^|      [5] Block Adobe                                          ^|
echo                  ^|                                                               ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [6] Github Repo (Detailed instructions there)            ^|
echo                  ^|                                                               ^|
echo                  ^|      [7] Exit                                                 ^|
echo                  ^|                                                               ^|
echo                  ^|_______________________________________________________________^|
echo:          
choice /C:1234567 /N /M ">                                     Select [1,2,3,4,5,6,7]: "

if errorlevel  7 exit
if errorlevel  7 (
	cls
	start https://github.com/eaaasun/CCStopper
	goto menu

)
if errorlevel  5 (
	cls
	.\scripts\BlockAdobe.bat
	goto menu
)
if errorlevel  4 (
	cls
	.\scripts\creditCardStop.bat
	goto menu
)
if errorlevel  3 (
	cls
	.\scripts\acrobatfix.bat
	goto menu
)
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