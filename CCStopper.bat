@echo off
title CCStopper
mode con: cols=102 lines=36

echo.>CCStopper_AIO.ps1:Zone.Identifier
powershell -ExecutionPolicy Bypass -File .\CCStopper_AIO.ps1