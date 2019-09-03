@ECHO OFF
:: This will report the groups and members to remove (providing a script). If you just want the batch to do the removing, 
:: then remove the ECHO from the dsmod command, and run elevated.   
REM Get list of disabled users in the domain
FOR /F "usebackq delims=;" %%A IN (`dsquery user "DC=DOMAIN,DC=local"  -disabled -limit 0`) DO ( 
    echo User: %%A
    REM Enumerate user's group memberOf, exclude "Domain Users" group
    FOR /F "usebackq delims=;" %%B IN (`dsget user %%A -memberof ^| find /V "Domain Users"`) DO (
        ECHO Group: %%B
        REM Remove user %%A from Group %%B
        ECHO dsmod group %%B -rmmbr %%A
    )
)