@echo off
:: Asks for Administrator Permissions
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd","/c %~s0 ::","","runas",1)(window.close) && exit
cd /d "%~dp0"

:: Disables AGSSerivce from starting up, then stops it
for %%a in (AGSService AGMService) do ( 
	sc config "%%a" start= disabled
	sc stop "%%a" >nul 2>&1
	taskkill /im "%%a.exe" /f >nul 2>&1
)

:: Checks if AGSService Exists
if exist "%ProgramFiles(x86)%\Common Files\Adobe\AdobeGCClient" (
	rmdir /Q /S "%ProgramFiles(x86)%\Common Files\Adobe\AdobeGCClient"
)

cd "%ProgramFiles(x86)%\Common Files\Adobe\"
mkdir "%ProgramFiles(x86)%\Common Files\Adobe\AdobeGCClient"
icacls "%ProgramFiles(x86)%\Common Files\Adobe\AdobeGCClient" /deny Administrators:(F)

start cmd /k %~dp0\..\CCStopper.bat