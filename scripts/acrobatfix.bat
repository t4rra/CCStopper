@echo off
:: Asks for Administrator Permissions
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"

color 70
echo.
echo                                      ---ESODA'S CREATIVE CLOUD STOPPER---
echo.
echo This will edit the registry. It is highly recommended to create a system restore point in case something goes wrong. 
:: Ask to create system restore point
set /p restorePntConfirm=Create system restore point? (y/n): 
:: Every other option other than "n" will create a system restore point
If /I "%restorePntConfirm%"=="n" (echo denied restore point) else (wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Before registry edited to fix Adobe Acrobat", 100, 7)

echo after restore point confirmation

pause