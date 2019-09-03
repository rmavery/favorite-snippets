@echo off 

SET /P ANSWER=Do you want to continue (Y/N)? 
echo You chose: %ANSWER% 
if /i {%ANSWER%}=={y}   (goto :yes) 
if /i {%ANSWER%}=={yes} (goto :yes) 
goto :no 
:yes 
echo You pressed yes! 
exit /b 0 

:no 
echo You pressed no! 
exit /b 1