@echo off
:: Asks for Administrator Permissions
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"

:: Disables AGSSerivce from starting up, then stops it
sc config "AGSService" start= disabled
sc stop "AGSService"
taskkill /IM "AGSService.exe" /F

sc config "AGMService" start= disabled
sc stop "AGMService"
taskkill /IM "AGMService.exe" /F


:: Checks if AGSService Exists
IF EXIST "C:\program files (x86)\common files\adobe\AdobeGCClient" (
	rmdir /Q /S "C:\program files (x86)\common files\adobe\AdobeGCClient"
)

cd "C:\program files (x86)\common files\adobe\"
mkdir "C:\program files (x86)\common files\adobe\AdobeGCClient"
icacls "C:\program files (x86)\common files\adobe\AdobeGCClient" /deny Administrators:(F)

cd ..
start CCStopper.bat