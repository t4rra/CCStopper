@echo off
title CCStopper
mode con: cols=102 lines=36

:: Asks for Administrator Permissions
net session >nul 2>&1
if %errorlevel% neq 0 goto elevate
cd /d "%~dp0\scripts"
goto mainScript

:elevate
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd","/c %~s0 ::","","runas",1)(window.close)
exit

:mainScript
for %%a in (*.ps1) do (
	set zoneIdentifier="<"%%a:Zone.Identifier
	:: Check if file is blocked
	if defined zoneIdentifier (
		:: Unblock files
		echo.>%%a:Zone.Identifier
	)
)
powershell -ExecutionPolicy RemoteSigned -File .\Menu.ps1