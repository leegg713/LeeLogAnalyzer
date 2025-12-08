<#
.SYNOPSIS
    Generates logs that are used to simulate event logs

.DESCRIPTION
    Generates logs in batch or streaming mode and outputs them to specific folders specified in the config.ps1 file. 

.EXAMPLE
    ./generator.ps1  -Mode $Streaming
    ./generator.ps1  -Mode $Batch 


.NOTES


#>

[CmdletBinding()]
param
(
	[Parameter(Mandatory = $True)]
    [ValidateSet("Batch", "Streaming")]
    [string]$Mode
)
# Imports configuration file config.ps1
. "$PSScriptRoot\config.ps1"
#Write-Host "Test to see if this is working"
# Gets the log path from config file -- So it basically makes the variable a global one in a way
#$LogPath = "$PSScriptRoot/data/logs/"          # Where generated logs are stored
#Write-Host "$LogPath"

# Imports utils.ps1 file
. "$PSScriptRoot\utils.ps1"

# If the folder does not exist for the data, creates the folder
if (-not (Test-Path $LogPath)) {
    New-Item -ItemType Directory -Path $LogPath | Out-Null
}

############ Global Log Path Variables for outputting data to files ############ 
$CSVLog = Join-Path $LogPath "CSV_Generated_Logs.csv"
$JSONLog = Join-Path $LogPath "JSON_Generated_Logs.json"
$PlainTextLog = Join-Path $LogPath "Text_Generated_Logs.txt"

############ Object arrays ############
$CSV_Log_Objects = @()
$JSON_Log_Objects = @()
$Text_Log_Objects = @()


# Batch Mode Set Up
if ($Mode -eq "Batch"){
# Loop for creating events in batch mode only
for ($i = 0; $i -lt $DefaultBatchSize; $i++) {
    $timeStamp = Generate-RandomTimeStamp # Stores function data retrieved in $timestamp -- EX: $timeStamp.CSV
    $userLog = Generate-RandomUserLog # Stores function data retrieved in $userLog -- EX: $userLog.Email
    $logEvent = Generate-RandomLogEvent # Stores function data retrieved in $logEvent -- EX: $logEvent.EventType
    # Need to have all this information go into a CSV, JSON, and PlainText file
    # Path for each would be $LogPath
    # Log object

    # CSV LOG OBJECTS and TXT LOG OBJECTS
    $CSVLogObject = [PSCustomObject]@{
    TimeStamp = $timeStamp.CSV
    Service   = $logEvent.Service
    EventType = $logEvent.EventType
    Event     = $logEvent.Event
    Email = $userLog.Email
    LogID = $userLog.LogID
    }
    $CSV_Log_Objects += $CSVLogObject

    # JSON LOG OBJECTS 
    $jsonLogObject = [PSCustomObject]@{
    TimeStamp = $timeStamp # All timestamp data 
    User      = $userLog
    Event     = $logEvent
    }
    $JSON_Log_Objects += $jsonLogObject


    }
    # BELOW/OUTSIDE FOR LOOP #
# Write CSV
# CSV
$CSV_Log_Objects | Export-Csv -Path $CSVLog -NoTypeInformation

# JSON
# Look into this more to understand it better
$JSON_Log_Objects | ConvertTo-Json -Depth 5 | Out-File -FilePath $JSONLog -Encoding UTF8

# TXT
# Loop through each log object in the array $Log_Objects
# and create a formatted string for each log entry.
# Each line will contain: TimeStamp | User | Event
$logLines = foreach ($log in $CSV_Log_Objects) {

    # Build a single line for this log object
    # Using the format: "TimeStamp | User | Event"
    $line = "$($log.TimeStamp) | $($log.Email) | $($log.Event) | $($log.Service) | $($log.EventType) | $($log.LogID)"

    
    # Output the line to the array $logLines
    $line
}

# At this point, $logLines contains one string per log object
# Example:
# 2025-01-01_10-00-00 | UserA | Login
# 2025-01-01_10-05-00 | UserB | Logout
# 2025-01-01_10-10-00 | UserC | AccessDenied

# Write all lines to a plain text file specified by $PlainTextLog
# The -Encoding UTF8 ensures proper encoding for special characters
$logLines | Out-File -FilePath $PlainTextLog -Encoding UTF8

} # END OF BATCH IF STATEMENT # 