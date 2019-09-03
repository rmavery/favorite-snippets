:: List all Microsoft Security Patches
wmic qfe list

wmic bios getserialnumber 

wmic bios get

:: Set password to never expire. 
wmic path Win32_UserAccount where Name='xxxxxx' set PasswordExpires=false

:: Uninstall products named like 'Java' 
wmic product where "Name like '%Java%'" call uninstall

@echo off
cls
wmic csproduct get name
wmic bios get serialnumber
wmic bios get SMBIOSBIOSVersion
pause >nul

::
@echo off
echo Don't forget to run it as an admin
echo.
echo Compiling list of installed Dell software...
echo.
wmic product where "name like '%%Dell%%'" get name

echo Uninstalling Dell Backup and Recovery Manager
wmic product where "name='Dell Backup and Recovery Manager'" call uninstall
echo Uninstalling Dell Protected Workspace
wmic product where "name='Dell Protected Workspace'" call uninstall
echo Uninstalling Dell Foundation Services
wmic product where "name='Dell Foundation Services'" call uninstall
echo Uninstalling Dell Command ^| Power Manager
wmic product where "name='Dell Command | Power Manager'" call uninstall
echo Uninstalling Dell Update
wmic product where "name='Dell Update'" call uninstall
::echo Uninstalling Dell Digital Delivery
::wmic product where "name='Dell Digital Delivery'" call uninstall
echo Uninstalling Dell Command ^| Update
wmic product where "name='Dell Command | Update'" call uninstall
echo Uninstalling Dell ControlVault Host Components Installer 64 bit
wmic product where "name='Dell ControlVault Host Components Installer 64 bit'" call uninstall
echo Uninstalling Dell Data Vault
wmic product where "name='Dell Data Vault'" call uninstall

echo.
echo Dell software that is still installed...
echo.
wmic product where "name like '%%Dell%%'" get name`

:: I don't understand these, but study them.  Maybe I will learn.. 
wmic /failfast:on /node:stupidinfecteduser product where "vendor like 'Oracle'" get name
wmic /node:stupidinfecteduser product where name="'Java(TM) 6 Update 29'" call uninstall
