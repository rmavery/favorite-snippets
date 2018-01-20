
# set min age of files
$max_days = "-365"
# set folder path
$dump_path = "F:\Friday\"

$dom = (get-date).Day
# get the current date
$curr_date = Get-Date
$del_date = $curr_date.AddDays($max_days)

$LogFilePath = "F:\Friday\Cleanup_Log_$dom.Log"

if (Test-Path $LogFilePath) {
  Remove-Item $LogFilePath
}

function Write-Log
{
    param (
        [Parameter(Mandatory)]
        [string]$Message,
        
        [Parameter()]
        [ValidateSet('1','2','3')]
        [int]$Severity = 1 ## Default to a low severity. Otherwise, override
    )
    
    $line = [pscustomobject]@{
        'DateTime' = (Get-Date)
        'Message' = $Message
        'Severity' = $Severity
    }
    
    ## Ensure that $LogFilePath is set to a global variable at the top of script
    $line | Export-Csv -Path $LogFilePath -Append -NoTypeInformation
}

Write-Log "========================================================"
Write-Log "Delete Objects older than $max_days days"
Write-Log "Log file: $LogFilePath" 


Write-Log "Current Date is $curr_date" 
# determine how far back we go based on current date

Write-Log "Delete files older than $del_date" 
Write-Log "========================================================"

# Identify and delete the old files: 
Write-log "--------------- F I L E S --------------------"
foreach( $f in Get-ChildItem $dump_path -Recurse | Where-Object {$_.PSIsContainer -eq $False}) {
    if($f.LastAccessTime -lt $del_date) {
           # Write-Host "I would delete : " $i.LastAccessTime $i.Name
           Remove-Item $f.FullName -ErrorAction SilentlyContinue -Confirm:$false -WhatIf
           $d = $f.LastAccessTime | get-date -Format "yyyyMMdd"
           $fn = $f.FullName
           Write-Log "Last Accessed: $d - $fn"  
    } 
}

# Locate and delete empty folders:  
Write-log "--------------- FOLDERS --------------------"
$a = Get-ChildItem $dump_path -recurse | Where-Object {$_.PSIsContainer -eq $True} | Where-Object {$_.GetDirectories().Count -eq 0} | Where-Object {$_.GetFiles().Count -eq 0}
foreach ($f in $a){
            Remove-Item $f.FullName -Recurse -ErrorAction SilentlyContinue -Confirm:$false -WhatIf
            $d = $f.LastAccessTime | get-date -Format "yyyyMMdd"  
            $fn = $f.FullName
            Write-Log "Last Accessed: $d - $fn" 
}
