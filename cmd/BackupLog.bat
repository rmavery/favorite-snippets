@echo off
set curdir=%~dp0
cd /d %curdir% 
:: Backup Log Files to single running log  
SET YMStamp=%DATE:~10,4%%DATE:~4,2%

SET yr=%DATE:~10,4%
SET mo=%DATE:~4,2%
SET dy=%DATE:~7,2%
SET dy=%dy: =0%
SET hr=%TIME:~0,2%
SET hr=%hr: =0%
SET mn=%TIME:~3,2%
SET sc=%TIME:~9,2%
SET NOWStamp=%yr%%mo%%dy%%hr%%mn%%sc%

IF NOT EXIST LOG MD LOG
SET LogFile=LOG\LOG_%YMStamp%.txt
ECHO NOWStamp=%NOWStamp%
ECHO BEGIN LOG : ================================== %NOWStamp% =========================================== >> %LogFile% 2>&1 
for /f %%a in ('dir /b *.log') do (
ECHO --------------------------------------------------------------------------- >> %LogFile% 2>&1  
ECHO *********************************** %%a ***************************** >> %LogFile% 2>&1 
ECHO --------------------------------------------------------------------------- >> %LogFile% 2>&1    
TYPE %%a >> %LogFile% 2>&1 
DEL %%a
) 
ECHO END LOG: ===================================== %NOWStamp% =========================================== >> %LogFile% 2>&1 