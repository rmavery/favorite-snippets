
# https://social.technet.microsoft.com/wiki/contents/articles/12037.active-directory-get-aduser-default-and-extended-properties.aspx

$sqlServer = "sqlServerName"
$dbName = "mydb"
$searchBase = "dc=domdomain,dc=local"
$ouRex='(?<=^...)[^,]*,(?<ou>\s*([^\n\r]*))'

$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

$transcriptPath = "$($PSScriptRoot)\SyncAD2SQL.Transcript.txt"

Try{
    Start-Transcript -Path $transcriptPath
} Catch {}

    # NOTE: Sync-ADObjects MUST always run first to ensure you have the most up to date list of AD-Objects. 
    # Other scripts depend on this to be current and timely.  

    Set-Location $PSScriptRoot
    .\Sync-ADObjects.ps1 -SQLServer $sqlServer -DBName $dbName -SearchBase $searchBase -ouRex $ouRex
    Set-Location $PSScriptRoot
    .\Sync-ADUsers.ps1 -SQLServer $sqlServer -DBName $dbName -SearchBase $searchBase -ouRex $ouRex
    Set-Location $PSScriptRoot
    .\Sync-ADGroups.ps1 -SQLServer $sqlServer -DBName $dbName -SearchBase $searchBase -ouRex $ouRex
    Set-Location $PSScriptRoot
    .\Sync-ADComputers.ps1 -SQLServer $sqlServer -DBName $dbName -SearchBase $searchBase -ouRex $ouRex

try {
        Stop-Transcript
} Catch {}


























