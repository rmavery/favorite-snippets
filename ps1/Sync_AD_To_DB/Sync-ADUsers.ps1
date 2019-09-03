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
    [Parameter(Mandatory=$true)]
    [string]$DBName, 
    [Parameter(Mandatory=$true)]
    [string]$SearchBase, 
    [Parameter(Mandatory=$true)]
    [string]$ouRex
)

# define Error handling
# note: do not change these values
$global:ErrorActionPreference = "Stop"
if($verbose){ $global:VerbosePreference = "Continue" }


# ============================================================================================
#              AD USERS  
# ============================================================================================
$users_loadTable = "[dbo].[_ad_users]"
$members_loadTable = "[dbo].[_ad_user_memberOf]"
$update_adusers_SP = "[dbo].[ad_insert_update_ad_users]"


$ADUPropertyNames = @(
    "City",
    "CN",
    "Company",
    "Country", 
    "Department", 
    "Description", 
    "DistinguishedName",
    "Division", 
    "EmailAddress",
    "EmployeeID",
    "EmployeeNumber",
    "Enabled",
    "GivenName",
    "HomeDirectory", 
    "LastLogonDate",
    "Manager",
    "MobilePhone",
    "Mail",
    "MemberOf",
    "Name",
    "ObjectCategory", 
    "ObjectClass",
    "ObjectGUID",
    "Office",
    "OfficePhone", 
    "Organization",
    "OtherName",
    "OU",
    "POBox",
    "PostalCode", 
    "SamAccountName",
    "SID",
    "State", 
    "Surname",
    "Title",
    "UserPrincipalName"
       )
    
$sqlCommand = "Truncate table $($users_loadTable)"
Invoke-SQLcmd -ServerInstance $sqlServer -query $sqlCommand -Database $dbName -ErrorAction Stop 

$sqlCommand = "Truncate table $($members_loadTable)"
Invoke-SQLcmd -ServerInstance $sqlServer -query $sqlCommand -Database $dbName -ErrorAction Stop 

Get-ADUser -Filter 'SamAccountName -Like "*"' -SearchBase $searchBase -Properties $ADUPropertyNames | ForEach-Object {

    #Extract the capture group [ou] from the DN 
    # https://adamtheautomator.com/regex-capture-groups-powershell/
    $ou = [regex]::match($_.DistinguishedName,$ouRex).Groups['ou'].value
    $guid = $_.ObjectGUID

    # [regex]::match($dn,'(?<=^...)[^,]*,(?<ou>\s*([^\n\r]*))').Groups['ou'].value
    
    
    $_.MemberOf | ForEach-Object { 
            $member_insertQuery = "
            Insert into $($members_loadTable)(user_objectGuid, memberOf_DN)
            Values
            ('$($guid)','$($_)')
            "
            Invoke-SQLcmd -ServerInstance $sqlServer -query $member_insertQuery -Database $dbName -ErrorAction Stop 
    }


    $user_insertquery=" 
    INSERT INTO $($users_loadTable) 
               (
                [City]
                ,[CN]
                ,[Company]
                ,[Country]
                ,[Department]
                ,[Description]
                ,[DistinguishedName]
                ,[Division]
                ,[EmailAddress]
                ,[EmployeeID]
                ,[EmployeeNumber]
                ,[Enabled]
                ,[GivenName]
                ,[HomeDirectory]
                ,[LastLogonDate]
                ,[Manager]
                ,[MobilePhone]
                ,[Mail]
                ,[MemberOf]
                ,[Name]
                ,[ObjectCategory]
                ,[ObjectClass]
                ,[ObjectGUID]
                ,[Office]
                ,[OfficePhone]
                ,[Organization]
                ,[OtherName]
                ,[OU]
                ,[POBox]
                ,[PostalCode]
                ,[SamAccountName]
                ,[SID]
                ,[State]
                ,[Surname]
                ,[Title]
                ,[UserPrincipalName]
               ) 
         VALUES 
               (
                   
                '$($_.City)' --CITY
                ,'$($_.CN -Replace "'", "''")'  --CN
                ,'$($_.Company -Replace "'", "''")'  --Company
                ,'$($_.Country -Replace "'", "''")' --Country 
                ,'$($_.Department -Replace "'", "''")' --Department
                ,'$($_.Description -Replace "'", "''")' --Description 
                ,'$($_.DistinguishedName -Replace "'", "''")' --DistinguishedName
                ,'$($_.Division -Replace "'", "''")' --Division 
                ,'$($_.EmailAddress -Replace "'", "''")' --EmailAddress 
                ,'$($_.EmployeeID)' --EmployeeID 
                ,'$($_.EmployeeNumber)'  --EmloyeeNumber 
                ,'$($_.Enabled)'  --Enabled 
                ,'$($_.GivenName -Replace "'", "''")'  --GivenName 
                ,'$($_.HomeDirectory -Replace "'", "''")'  --HomeDirectory 
                ,'$($_.LastLogonDate)'  --LastLogonDate
                ,'$($_.Manager -Replace "'", "''")'  --Manager 
                ,'$($_.MobilePhone)'  --MobilePhone 
                ,'$($_.Mail -Replace "'", "''")'  --Mail 
                ,'$($_.MemberOf -replace "local CN", "local|CN")'  --MemberOf 
                ,'$($_.Name -Replace "'", "''")' --Name 
                ,'$($_.ObjectCategory)'  --ObjectCategory 
                ,'$($_.ObjectClass)'  --ObjectClass 
                ,'$($_.ObjectGUID)'  --ObjectGuid 
                ,'$($_.Office -Replace "'", "''")'  --Office 
                ,'$($_.OfficePhone -Replace "'", "''")'  --OfficePhone 
                ,'$($_.Organization -Replace "'", "''")'  --Organization
                ,'$($_.OtherName -Replace "'", "''")'  --OtherName 
                ,'$($ou)' --OU
                ,'$($_.POBox)'  --POBox 
                ,'$($_.PostalCode)'  --PostalCode
                ,'$($_.SamAccountName)'  --SamAccountName d
                ,'$($_.SID)'  --SID
                ,'$($_.State)'  --State
                ,'$($_.Surname -Replace "'", "''")'  --Surname 
                ,'$($_.Title -Replace "'", "''")'  --Title
                ,'$($_.UserPrincipalName)' --UserPrincipalName 
               
               ) 
    GO 
    " 
    Write-Host "Inserting ADUser: $($_.UserPrincipalName)"
    # $user_insertquery | out-file -FilePath .\testquery.txt
    Invoke-SQLcmd -ServerInstance $sqlServer -query $user_insertquery -Database $dbName -ErrorAction Stop

}


Invoke-SQLcmd -ServerInstance $sqlServer -query $update_adusers_SP -Database $dbName -ErrorAction Stop 

# | ConvertTo-Csv |  Out-File -FilePath "F:\dev\Sync_AD_2_SQL\$($outfile)" 