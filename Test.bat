@Echo off
cls

Title Button Function 2.0 - Demo - www.thebateam.org
Set "Path=%Path%;%CD%;%CD%\GUI Plugin;"

:Main
REM Generating Buttons on the Console...
@REM call Button 5 5 A0 "AAAAA" 19 5 E0 "Button 2" 33 5 C0 "Button 3"  5 12 70 "Button 4" 19 12 80 "Button 5" 33 12 B0 "Button 6" X _Var_Box _Var_Hover

call Button 5 5 7C "TEST" X _Var_Box _Var_Hover
GetInput /M %_Var_Box% /H %_Var_Hover% 

Echo.
Echo.
Echo.
Echo.
Echo. You Clicked Button - %Errorlevel%...
timeout /t 3
Cls 
goto main