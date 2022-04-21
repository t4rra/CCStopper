:: language: bat
@echo off
title CCStopper - Credit Card Prompt Stopper test
Set "Path=%Path%;%CD%;%CD%\Plugins;"
mode con: cols=100 lines=36

netsh advfirewall firewall show rule name="CCStopper-CreditCardBlock"

if errorlevel 1 (
	echo "rule no exist"
	pause 
	exit
)

if errorlevel 0 (
	echo "rule yes exist"
	pause 
	exit
)

