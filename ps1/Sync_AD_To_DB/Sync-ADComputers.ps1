<#

    .SYNOPSIS
        Queries active directory for computer objects and pushes them to a SQL database
    .DESCRIPTION
        .PARAMETER $SQLServer
            Name of the SQL server to which the data is to be written.  
        .PARAMETER $DBName 
            Name of the Database.   This database must already have the initial load tables, permanent tables, and 
            stored procedure to insert/update/delete the permanent values from the load tables.  
        .PARAMETER $SearchBase 
            The Base OU from which search should start, e.g, "DC=domdomain,DC=Local"
        .PARAMETER $OURex
            The RegEx string to isolate the OU from a DistinguishedName, e.g, "(?<=^...)[^,]*,(?<ou>\s*([^\n\r]*))"

    .EXAMPLE
        .\Sync-AdComputers.ps1 -SQLServer "MYDBSERVER" -DBName "MYDB" -SearchBase "dc=domdomain,dc=local" -OURex "(?<=^...)[^,]*,(?<ou>\s*([^\n\r]*))"
 
    .NOTES
        Version:        1.0
        Author:         Ralph Avery
        Create Date:    2019-08-26
        History:
        - YYYYMMDD - ZD#0000000 - Description of Change
#>
 
param(
    [Parameter(Mandatory=$true)]
    [string]$SQLServer,
    [string]$DBName, 
    [string]$SearchBase, 
    [string]$ouRex
)

# define Error handling
# note: do not change these values
$global:ErrorActionPreference = "Stop"
if($verbose){ $global:VerbosePreference = "Continue" }
 

# ============================================================================================
#              AD COMPUTERS
# ============================================================================================
$computers_loadTable = "[dbo].[_ad_computers]"
$computer_memberOf_loadTable = "[dbo].[_ad_computer_memberOf]"
$computer_spn_loadTable = "[dbo].[_ad_computer_spns]"
$update_adcomputers_SP = "[dbo].[ad_insert_update_ad_computers]"

$ADCPropertyNames = @(
    "Name",
    "CanonicalName",
    "CN",
    "Description",
    "DistinguishedName",
    "DNSHostName",
    "Enabled",
    "IPv4Address",
    "LastLogonDate",
    "Location",
    "ManagedBy",
    "MemberOf",
    "ObjectCategory",
    "ObjectClass",
    "ObjectGUID",
    "OperatingSystem",
    "OperatingSystemVersion",
    "ServiceAccount",
    "ServicePrincipalNames",
    "SID",
    "Created",
    "Modified",
    "Deleted"
)
    
$sqlCommand = "Truncate table $($computers_loadTable)"
Invoke-SQLcmd -ServerInstance $sqlServer -query $sqlCommand -Database $dbName -ErrorAction Stop 

$sqlCommand = "Truncate table $($computer_memberOf_loadTable)"
Invoke-SQLcmd -ServerInstance $sqlServer -query $sqlCommand -Database $dbName -ErrorAction Stop 

$sqlCommand = "Truncate table $($computer_spn_loadTable)"
Invoke-SQLcmd -ServerInstance $sqlServer -query $sqlCommand -Database $dbName -ErrorAction Stop 

Get-ADComputer -Filter 'SamAccountName -Like "*"' -SearchBase $searchBase -Properties $ADCPropertyNames | ForEach-Object {

    #Extract the capture group [ou] from the DN 
    # https://adamtheautomator.com/regex-capture-groups-powershell/
    $ou = [regex]::match($_.DistinguishedName, $ouRex).Groups['ou'].value
    $guid = $_.ObjectGUID

    # [regex]::match($dn,'(?<=^...)[^,]*,(?<ou>\s*([^\n\r]*))').Groups['ou'].value
    
    
    $_.MemberOf | ForEach-Object { 
        $computer_memberOf_insertQuery = "
            Insert into $($computer_memberOf_loadTable)(computer_objectGuid, memberOf_DN)
            Values
            ('$($guid)','$($_)')
            "
        Invoke-SQLcmd -ServerInstance $sqlServer -query $computer_memberOf_insertQuery  -Database $dbName -ErrorAction Stop 
    }


    $_.ServicePrincipalNames | ForEach-Object { 
        $computer_spn_insertQuery = "
            Insert into $($computer_spn_loadTable)(objectGuid, ServicePrincipalName)
            Values
            ('$($guid)','$($_)')
            "
        #$computer_spn_insertQuery | out-file -FilePath .\computer_spn_insertQuery.txt
        Invoke-SQLcmd -ServerInstance $sqlServer -query $computer_spn_insertQuery  -Database $dbName -ErrorAction Stop 
    }

    $computer_insertquery = "INSERT INTO $($computers_loadTable) 
               (
                [Name]
                ,[CanonicalName]
                ,[CN]
                ,[Description]
                ,[DistinguishedName]
                ,[DNSHostName]
                ,[Enabled]
                ,[IPv4Address]
                ,[LastLogonDate]
                ,[Location]
                ,[ManagedBy]
                ,[MemberOf]
                ,[ObjectCategory]
                ,[ObjectClass]
                ,[ObjectGUID]
                ,[OperatingSystem]
                ,[OperatingSystemVersion]
                ,[OU]
                ,[ServiceAccount]
                ,[ServicePrincipalNames]
                ,[SID]
                ,[Created]
                ,[Modified]
                ,[Deleted]
        ) 
    VALUES 
        (               
            '$($_.Name -Replace "'", "''" )'  --Name
            , '$($_.CanonicalName -Replace "'", "''" )'  --CanonicalName
            , '$($_.CN -Replace "'", "''" )'  --CN
            , '$($_.Description -Replace "'", "''" )'  --Description
            , '$($_.DistinguishedName -Replace "'", "''" )'  --DistinguishedName
            , '$($_.DNSHostName -Replace "'", "''" )'  --DNSHostName
            , '$($_.Enabled -Replace "'", "''" )'  --Enabled
            , '$($_.IPv4Address -Replace "'", "''" )'  --IPv4Address
            , '$($_.LastLogonDate -Replace "'", "''" )'  --LastLogonDate
            , '$($_.Location -Replace "'", "''" )'  --Location
            , '$($_.ManagedBy -Replace "'", "''" )'  --ManagedBy
            , '$($_.MemberOf -Replace "'", "''" )'  --MemberOf
            , '$($_.ObjectCategory -Replace "'", "''" )'  --ObjectCategory
            , '$($_.ObjectClass -Replace "'", "''" )'  --ObjectClass
            , '$($_.ObjectGUID -Replace "'", "''" )'  --ObjectGUID
            , '$($_.OperatingSystem -Replace "'", "''" )'  --OperatingSystem
            , '$($_.OperatingSystemVersion -Replace "'", "''" )'  --OperatingSystemVersion
            , '$($ou)' --OU
            , '$($_.ServiceAccount -Replace "'", "''" )'  --ServiceAccount
            , '$($_.ServicePrincipalNames -Replace "'", "''" )'  --ServicePrincipalNames
            , '$($_.SID -Replace "'", "''" )'  --SID
            , '$($_.Created -Replace "'", "''" )'  --Created
            , '$($_.Modified -Replace "'", "''" )'  --Modified
            , '$($_.Deleted -Replace "'", "''" )'  --Deleted       
        ) 
    GO 
    " 
    Write-Host "Inserting ADComputer: $($_.Name)"
    #$computer_insertquery | out-file -FilePath .\testquery.txt
    Invoke-SQLcmd -ServerInstance $sqlServer -query $computer_insertquery -Database $dbName -ErrorAction Stop

}


Invoke-SQLcmd -ServerInstance $sqlServer -query $update_adcomputers_SP -Database $dbName -ErrorAction Stop 