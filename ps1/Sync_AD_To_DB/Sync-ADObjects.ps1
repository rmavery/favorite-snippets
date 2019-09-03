<#

$sqlServer = "MYDBSERVER"
$dbName = "MYDB"
$searchBase = "dc=domdomain,dc=local"
$ouRex="(?<=^...)[^,]*,(?<ou>\s*([^\n\r]*))"

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
        .\Sync-AdObjects.ps1 -SQLServer "MYDBSERVER" -DBName "MYDB" -SearchBase "dc=domdomain,dc=local" -OURex "(?<=^...)[^,]*,(?<ou>\s*([^\n\r]*))"
 
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
#              AD OBJECTS 
# ============================================================================================
$adObjects_loadTable = "[dbo].[_ad_objects]"
$update_adobjects_SP = "[dbo].[ad_insert_update_ad_objects]"

$sqlCommand = "Truncate table $($adObjects_loadTable)"
Invoke-SQLcmd -ServerInstance $sqlServer -query $sqlCommand -Database $dbName -ErrorAction Stop 

$ADOPropertyNames = @( 
    "ObjectGUID",
    "Name",
    "DisplayName",
    "Description",
    "CanonicalName",
    "CN",
    "DistinguishedName",
    "Created",
    "Modified",
    "Deleted",
    "ObjectCategory",
    "ObjectClass"
)

Get-ADObject -Filter "*" -SearchBase $searchBase -Properties $ADOPropertyNames | ForEach-Object {
    $tst = [string]$_.ObjectGUID
    

    if($tst.length -gt 3){
        $ou = [regex]::match($_.DistinguishedName,$ouRex).Groups['ou'].value
        $ado_insertQuery = "INSERT INTO $($adObjects_loadTable) 
        (
            [ObjectGUID]
            ,[Name]
            ,[DisplayName]
            ,[Description]
            ,[CanonicalName]
            ,[CN]
            ,[DistinguishedName]
            ,[OU]
            ,[Created]
            ,[Modified]
            ,[Deleted]
            ,[ObjectCategory]
            ,[ObjectClass]

        )
        Values(
             '$($_.ObjectGUID -Replace "'", "''" )'  --ObjectGUID
            , '$($_.Name -Replace "'", "''" )'  --Name
            , '$($_.DisplayName -Replace "'", "''" )'  --DisplayName
            , '$($_.Description -Replace "'", "''" )'  --Description
            , '$($_.CanonicalName -Replace "'", "''" )'  --CanonicalName
            , '$($_.CN -Replace "'", "''" )'  --CN
            , '$($_.DistinguishedName -Replace "'", "''" )'  --DistinguishedName
            , '$($ou -Replace "'", "''" )'--OU
            , '$($_.Created -Replace "'", "''" )'  --Created
            , '$($_.Modified -Replace "'", "''" )'  --Modified
            , '$($_.Deleted -Replace "'", "''" )'  --Deleted
            , '$($_.ObjectCategory -Replace "'", "''" )'  --ObjectCategory
            , '$($_.ObjectClass -Replace "'", "''" )'  --ObjectClass
        )
        GO "
        Write-Host "Inserting ADObject:  $($_.Name)"
        #$ado_insertQuery | out-file -FilePath .\testquery.txt
        Invoke-SQLcmd -ServerInstance $sqlServer -query $ado_insertQuery -Database $dbName -ErrorAction Stop
    }
}


Invoke-SQLcmd -ServerInstance $sqlServer -query $update_adobjects_SP -Database $dbName -ErrorAction Stop 
