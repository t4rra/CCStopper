@echo off
title CCStopper
Set "Path=%Path%;%CD%;%CD%\Plugins;"

:: Main script
:menu
cls



echo.
echo                                      ---CCSTOPPER---
echo.
echo. Get rid of Adobe's pesky background apps and more!
echo. Read the instructions first! They can be found in the Github repo.
echo.
echo. Made by easun (eaaasun on Github)
echo.
echo. MAKE SURE TO SAVE YOUR FILES! Ending Adobe processes will also close apps like Photoshop, After Effects, etc. 
echo.

call Button 1 10 F9 "End Adobe Processes" 26 10 F9 "Remove AGS"  42 10 F9 "Patch Acrobat" 1 14 FC "Github Repo" 18 14 FC "Exit"  X _Var_Box _Var_Hover
GetInput /M %_Var_Box% /H %_Var_Hover% 


If /I "%Errorlevel%"=="1" (
	cls
	Powershell.exe -executionpolicy remotesigned -File  .\scripts\ProcessKill.ps1
	goto menu
)
If /I "%Errorlevel%"=="2" (
	cls
	.\scripts\AGSKill.bat
	goto menu
)
If /I "%Errorlevel%"=="3" (
	cls
	.\scripts\acrobatfix.bat
	goto menu
)
If /I "%Errorlevel%"=="4" (
	cls
	start https://github.com/eaaasun/CCStopper
	goto menu
)
If /I "%Errorlevel%"=="5" exit

goto other

:other
goto menu
