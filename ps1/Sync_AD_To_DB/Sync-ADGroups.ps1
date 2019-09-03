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
        .\Sync-AdUsers.ps1 -SQLServer "MYDBSERVER" -DBName "MYDB" -SearchBase "dc=domdomain,dc=local" -OURex "(?<=^...)[^,]*,(?<ou>\s*([^\n\r]*))"
 
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
#              AD GROUPS  
# ============================================================================================
$ADGroups_loadTable = "[dbo].[_ad_groups]"
$ADGroupMembers_loadTable = "[dbo].[_ad_group_members]"
$ADGroupMemberOf_loadTable = "[dbo].[_ad_group_memberOf]"
$update_adobjects_SP = "[dbo].[ad_insert_update_ad_groups]"

$ADGPropertyNames = @(
    "ObjectGUID",
    "Name",
    "DisplayName",
    "Description",
    "CanonicalName",
    "CN",
    "DistinguishedName",
    "GroupCategory",
    "GroupScope",
    "ManagedBy",
    "MemberOf",
    "Members",
    "SamAccountName",
    "SID",
    "Created",
    "Modified",
    "Deleted",
    "ObjectCategory",
    "ObjectClass"
)

$sqlCommand = "Truncate table $($ADGroups_loadTable)"
Invoke-SQLcmd -ServerInstance $sqlServer -query $sqlCommand -Database $dbName -ErrorAction Stop 

$sqlCommand = "Truncate table $($ADGroupMembers_loadTable)"
Invoke-SQLcmd -ServerInstance $sqlServer -query $sqlCommand -Database $dbName -ErrorAction Stop 

$sqlCommand = "Truncate table $($ADGroupMemberOf_loadTable)"
Invoke-SQLcmd -ServerInstance $sqlServer -query $sqlCommand -Database $dbName -ErrorAction Stop 

Get-ADGroup -Filter 'SamAccountName -Like "*"' -SearchBase  $searchBase -Properties $ADGPropertyNames | ForEach-Object {

    $ou = [regex]::match($_.DistinguishedName,$ouRex).Groups['ou'].value
    $guid = $_.ObjectGUID

    $_.MemberOf | ForEach-Object { 
        $member_insertQuery = "
        Insert into $($ADGroupMemberOf_loadTable)(objectGuid, memberOf_DN)
        Values
        ('$($guid)','$($_  -Replace "'", "''")')
        "
        Invoke-SQLcmd -ServerInstance $sqlServer -query $member_insertQuery -Database $dbName -ErrorAction Stop 
    }

    $_.Members | ForEach-Object { 
            $member_insertQuery = "
            Insert into $($ADGroupMembers_loadTable)(objectGuid, member_DN)
            Values
            ('$($guid)','$($_  -Replace "'", "''")')
            "
            Invoke-SQLcmd -ServerInstance $sqlServer -query $member_insertQuery -Database $dbName -ErrorAction Stop 
    }

    $group_insertQuery = "INSERT INTO $($ADGroups_loadTable)
    (
        
        [ObjectGUID]
        ,[Name]
        ,[DisplayName]
        ,[Description]
        ,[CanonicalName]
        ,[CN]
        ,[DistinguishedName]
        ,[GroupCategory]
        ,[GroupScope]
        ,[ManagedBy]
        ,[MemberOf]
        ,[Members]
        ,[OU]
        ,[SamAccountName]
        ,[SID]
        ,[Created]
        ,[Modified]
        ,[Deleted]
        ,[ObjectCategory]
        ,[ObjectClass]   
    )
    Values (
        '$($_.ObjectGUID -Replace "'", "''" )'  --ObjectGUID
        , '$($_.Name -Replace "'", "''" )'  --Name
        , '$($_.DisplayName -Replace "'", "''" )'  --DisplayName
        , '$($_.Description -Replace "'", "''" )'  --Description
        , '$($_.CanonicalName -Replace "'", "''" )'  --CanonicalName
        , '$($_.CN -Replace "'", "''" )'  --CN
        , '$($_.DistinguishedName -Replace "'", "''" )'  --DistinguishedName
        , '$($_.GroupCategory -Replace "'", "''" )'  --GroupCategory
        , '$($_.GroupScope -Replace "'", "''" )'  --GroupScope
        , '$($_.ManagedBy -Replace "'", "''" )'  --ManagedBy
        , '$($_.MemberOf -Replace "'", "''" )'  --MemberOf
        , '$($_.Members -Replace "'", "''" )'  --Members
        , '$($ou)' --OU
        , '$($_.SamAccountName -Replace "'", "''" )'  --SamAccountName
        , '$($_.SID -Replace "'", "''" )'  --SID
        , '$($_.Created -Replace "'", "''" )'  --Created
        , '$($_.Modified -Replace "'", "''" )'  --Modified
        , '$($_.Deleted -Replace "'", "''" )'  --Deleted
        , '$($_.ObjectCategory -Replace "'", "''" )'  --ObjectCategory
        , '$($_.ObjectClass -Replace "'", "''" )'  --ObjectClass
    )
    GO"

    Write-Host "Inserting ADGroup:  $($_.Name)"
    #$ado_insertQuery | out-file -FilePath .\testquery.txt
    Invoke-SQLcmd -ServerInstance $sqlServer -query $group_insertQuery -Database $dbName -ErrorAction Stop

}



Invoke-SQLcmd -ServerInstance $sqlServer -query $update_adobjects_SP -Database $dbName -ErrorAction Stop 
