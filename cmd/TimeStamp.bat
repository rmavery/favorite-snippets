@echo off
:: First number = how many to skip.  Second = how many to take.  
:: %TIME:~6,2% = Time Skip first 6 and take the next 2. 
SET Stamp=%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%%TIME:~0,2%%TIME:~3,2%.%TIME:~6,2%%TIME:~9,2%
ECHO %Stamp%
Pause

::Examples: 
::Date = Mon 01/05/2015
:: %Date:~0,3% = 'Mon' 
:: %Date:~4,2% = '01'

SET Stamp=%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%%TIME:~0,2%%TIME:~3,2%.%TIME:~6,2%%TIME:~9,2%


@Echo === Generate a unique time stamp that can be made into a file name.  === 
::%DATE:~10,4% = YYYY [Year] 
::%DATE:~4,2 = MM  [Month]
::%DATE:~7,2% = DD [Day]
::%TIME:~3,2% = nn [Minutes]
::%TIME:~6,2% = SS [Seconds]
::%TIME:~9,2% = xx [Milliseconds] 
SET Stamp=%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%%TIME:~0,2%%TIME:~3,2%.%TIME:~6,2%%TIME:~9,2%
::Replace any spaces with 0 (zero pads date and time to prevent spaces in variable) 
SET Stamp=%STAMP: =0%

