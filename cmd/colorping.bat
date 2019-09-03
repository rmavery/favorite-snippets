@echo off
cls
:: Changes the color of the screen to match success or failure of the ping result. 
set /p IP=Enter your IP Address :
:top
 PING  -n 1 %IP% | FIND "TTL="
 IF ERRORLEVEL 1 (SET OUT=4F  & echo Request timed out.) ELSE (SET OUT=2F)
 color %OUT%
 ping -n 2 -l 10 127.0.0.1 >nul 7uj
GoTo top