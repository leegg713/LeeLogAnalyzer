<#
.SYNOPSIS
    Generates simulated event log data in batch or streaming mode.

.DESCRIPTION
    Creates log events based on configured services, users, and event definitions
    to simulate a real-world application and security logs. Logs can be generated in batch
    mode for static analysis or streaming mode to mimic live logs being generated.
    Output is written to CSV, JSON, and plain text formats using paths and defaults
    defined in config.ps1 to have data save in multiple formats

.PARAMETER Mode
    Specifies how logs are generated.
    Valid values:
      - Batch: Generates a fixed number of events in a single run.
      - Streaming: Continuously generates events for a specified duration.

.PARAMETER Append
    Appends generated log data to existing log files instead of overwriting them.

.PARAMETER Duration
    Duration in seconds for streaming mode. Overrides the default duration in config.ps1.

.PARAMETER EventsPerSecond
    Number of events generated per second in streaming mode.
    Overrides the default value in config.ps1.

.PARAMETER ClearOldLogs
    Deletes existing log files in the log directory before generating new logs.

.INPUTS
    None. All data is generated internally.

.OUTPUTS
    Log files written to the directory specified by $LogPath:
      - CSV_Generated_Logs.csv
      - JSON_Generated_Logs.json
      - Text_Generated_Logs.txt

.EXAMPLE
    ./generator.ps1 -Mode Batch

.EXAMPLE
    ./generator.ps1 -Mode Batch -Append

.EXAMPLE
    ./generator.ps1 -Mode Streaming -Duration 60 -EventsPerSecond 10

.NOTES
    Requires config.ps1 and utils.ps1 in the script root.
    Designed for log analysis practice, alerting simulations, and Splunk-style workflows.
#>

[CmdletBinding()]
param
(
	[Parameter(Mandatory = $True)]
    [ValidateSet("Batch", "Streaming")]
    [string]$Mode,
    [Parameter(Mandatory = $False)]
    [switch]$Append,
    [Parameter(Mandatory = $False)]
    [int]$Duration, # Duration in seconds
    [Parameter(Mandatory = $False)]
    [int]$EventsPerSecond,
    [Parameter(Mandatory = $False)]
    [switch]$ClearOldLogs
)
# Imports configuration file config.ps1
. "$PSScriptRoot\config.ps1"
#Write-Host "Test to see if this is working"
# Gets the log path from config file -- So it basically makes the variable a global one in a way
#$LogPath = "$PSScriptRoot/data/logs/"          # Where generated logs are stored
#Write-Host "$LogPath"

# Imports utils.ps1 file
. "$PSScriptRoot\utils.ps1"

# Clears Old Logs 
if ($ClearOldLogs) {
    Write-Host "Clearing entire log directory..." -ForegroundColor Yellow
    Get-ChildItem -Path $LogPath -File | Remove-Item -Force
}


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
# Prepare an empty array for the lines for the txt file
$logLines = @()


# Batch Mode Set Up
if ($Mode -eq "Batch"){
# Loop for creating events in batch mode only
for ($i = 0; $i -lt $DefaultBatchSize; $i++) {
    $timeStamp = Generate-RandomTimeStamp # Stores function data retrieved in $timestamp -- EX: $timeStamp.CSV
    $userLog = Generate-RandomUserLog # Stores function data retrieved in $userLog -- EX: $userLog.Email
    $logEvent = Generate-RandomLogEvent # Stores function data retrieved in $logEvent -- EX: $logEvent.EventType
    

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

# TXT
# Loop through each log object in the array $Log_Objects
# and create a formatted string for each log entry.

# Loop through each CSV log object and build a formatted string
foreach ($log in $CSV_Log_Objects) {
    $line = "$($log.TimeStamp) | $($log.Email) | $($log.Event) | $($log.Service) | $($log.EventType) | $($log.LogID)"
    $logLines += $line
}
# 
if ($Append){
    # Appends to CSV and doesn't overwrite if $Append parameter selected
    $CSV_Log_Objects | Export-Csv -Path $CSVLog -Append -NoTypeInformation
    $JSON_Log_Objects | ConvertTo-Json -Depth 5 | Out-File -FilePath $JSONLog -Encoding UTF8 -Append
    $logLines | Out-File -FilePath $PlainTextLog -Encoding UTF8 -Append


}
else{
    $CSV_Log_Objects | Export-Csv -Path $CSVLog -NoTypeInformation
    $JSON_Log_Objects | ConvertTo-Json -Depth 5 | Out-File -FilePath $JSONLog -Encoding UTF8
    $logLines | Out-File -FilePath $PlainTextLog -Encoding UTF8

}

# Summary of last batch run

# Prints a small output of what the last batch run created -- Can be used for verifying everything worked and just a nice output to have
$CSV_Log_Objects | Group-Object -Property Service,EventType,Event | Select Name, Count


} # END OF BATCH IF STATEMENT # 

# Streaming Mode Start

if ($Mode -eq "Streaming") {

    # Override defaults if a different value is provided
    if ($Duration){
        $DefaultDuration = $Duration
    }
    if ($EventsPerSecond){
        $DefaultEventsPerSecond = $EventsPerSecond
    }

    $endTime = (Get-Date).AddSeconds($DefaultDuration)
    # Can comment out the write hosts after verifying everything works
    Write-Host "Ending at: $endTime"
    Write-Host "Duration: $DefaultDuration seconds"
    Write-Host "Events per second: $DefaultEventsPerSecond"

    Write-Host "Streaming mode enabled... Ctrl+C to stop it early"

    while ((Get-Date) -lt $endTime) {

        # Reset per-loop for streaming mode
        $CSV_Log_Objects = @()
        $JSON_Log_Objects = @()
        $logLines = @()

        # Generate N events per second
        for ($i = 0; $i -lt $DefaultEventsPerSecond; $i++) {

            $timeStamp = Generate-RandomTimeStamp
            $userLog   = Generate-RandomUserLog
            $logEvent  = Generate-RandomLogEvent

            # CSV / TXT object
            $CSVLogObject = [PSCustomObject]@{
                TimeStamp = $timeStamp.CSV
                Service   = $logEvent.Service
                EventType = $logEvent.EventType
                Event     = $logEvent.Event
                Email     = $userLog.Email
                LogID     = $userLog.LogID
            }
            $CSV_Log_Objects += $CSVLogObject

            # JSON object
            $JSON_Log_Objects += [PSCustomObject]@{
                TimeStamp = $timeStamp
                User      = $userLog
                Event     = $logEvent
            }
        }

        # Build TXT log lines
        foreach ($log in $CSV_Log_Objects) {
            $line = "$($log.TimeStamp) | $($log.Email) | $($log.Event) | $($log.Service) | $($log.EventType) | $($log.LogID)"
            $logLines += $line
        }

        # (Streaming = append the whole time -- Tip: Use Clear Old Logs to start fresh)
        $CSV_Log_Objects  | Export-Csv -Path $CSVLog -Append -NoTypeInformation
        $JSON_Log_Objects | ConvertTo-Json -Depth 5 | Out-File -FilePath $JSONLog -Encoding UTF8 -Append
        $logLines         | Out-File -FilePath $PlainTextLog -Encoding UTF8 -Append

        # Maintain exactly 1 loop per second
        Start-Sleep -Seconds 1
    }
}


