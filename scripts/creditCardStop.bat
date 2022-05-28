:: language: bat
@echo off
title CCStopper - Credit Card Prompt Stopper
Set "Path=%Path%;%CD%;%CD%\Plugins;"
mode con: cols=100 lines=36

:: ask for admin perms
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"

:: Main script
:menu
cls
echo:
echo:
echo                   _______________________________________________________________
echo                  ^|                                                               ^| 
echo                  ^|                                                               ^|
echo                  ^|                            CCSTOPPER                          ^|
echo                  ^|                         Made by eaaasun                       ^|
echo                  ^|                    Credit Card Trial Remover                  ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      This module stops the credit card prompt through         ^|
echo                  ^|      a firewall rule when downloading a trial app.            ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [1] Stop Credit Card prompt                              ^|
echo                  ^|                                                               ^|
echo                  ^|      [2] Reset firewall rule                                  ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [3] Exit                                                 ^|
echo                  ^|_______________________________________________________________^|
echo:
echo:          
choice /C:123 /N /M ">                                     Select [1,2,3]: "

if errorlevel  3 (
	goto exit
)

if errorlevel  2 (
	netsh advfirewall firewall delete rule name="CCStopper-CreditCardBlock" dir=out program="%programfiles(x86)%\Common Files\Adobe\Adobe Desktop Common\ADS\Adobe Desktop Service.exe" profile=any
	pause
	goto exit
)
if errorlevel  1 (
	goto ruleChecker

	:addRule
		netsh advfirewall firewall add rule name="CCStopper-CreditCardBlock" dir=out program="%programfiles(x86)%\Common Files\Adobe\Adobe Desktop Common\ADS\Adobe Desktop Service.exe" profile=any action=block
		pause
		goto exit

)

:exit
start cmd /k %~dp0\..\CCStopper.bat
exit

:ruleChecker
	:: check if the rule exists, errorlevel 0 means that it exists, errorlevel 1 means that it doesn't
	netsh advfirewall firewall show rule name="CCStopper-CreditCardBlock" > nul
	if errorlevel 1 (
		goto addRule
	)

	if errorlevel 0 (
		goto ruleExists
	)



:ruleExists
cls
echo:
echo:
echo                   _______________________________________________________________
echo                  ^|                                                               ^| 
echo                  ^|                                                               ^|
echo                  ^|                            CCSTOPPER                          ^|
echo                  ^|                         Made by eaaasun                       ^|
echo                  ^|                    Credit Card Trial Remover                  ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|                             ERROR!                            ^|
echo                  ^|                                                               ^|
echo                  ^|      The firewall rule already exists! Creating another       ^|
echo                  ^|      one does nothing. If this patch doesn't work,            ^|
echo                  ^|      please open an issue in the Github repo.                 ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [1] Go back                                              ^|
echo                  ^|_______________________________________________________________^|
echo:
echo:          
choice /C:1 /N /M ">                                     Select [1]: "

if errorlevel 1 (
	goto menu
)