@echo off
:: Asks for Administrator Permissions
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd", "/c %~s0 ::", "", "runas", 1)(window.close) && exit
cd /d "%~dp0"

:: Disables AGSSerivce from starting up, then stops it
sc config "AGSService" start= disabled
sc stop "AGSService"
taskkill /IM "AGSService.exe" /F

sc config "AGMService" start= disabled
sc stop "AGMService"
taskkill /IM "AGMService.exe" /F

:: Checks if AGSService Exists
IF EXIST "C:\Program Files (x86)\Common Files\Adobe\AdobeGCClient" (
	rmdir /Q /S "C:\Program Files (x86)\Common Files\Adobe\AdobeGCClient"
)

cd "C:\Program Files (x86)\Common Files\Adobe\"
mkdir "C:\Program Files (x86)\Common Files\Adobe\AdobeGCClient"
icacls "C:\Program Files (x86)\Common Files\Adobe\AdobeGCClient" /deny Administrators:(F)

start cmd /k %~dp0\..\CCStopper.bat