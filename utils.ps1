# Load the config so $Services and other settings are available
. "$PSScriptRoot\config.ps1"
Write-Host " $LogPath "
<#
#### FUNCTIONS TO WORK ON ####
 Random log level generator (INFO/WARN/ERROR)

 Bad actor behavior generator (optional, triggers anomalies)

 Parsing helper functions (for analyzer)

 Normalization and correlation helpers (for analyzer)

 Metrics calculation helpers (error counts, events per minute, etc.)
#>

## PARAMETER BLOCK EXAMPLE ##
<#
    [CmdletBinding()]
    param(
    [Parameter(Mandatory = $false)]
    [ValidateSet("Text","CSV","JSON")]
    [string]$OutputType = "Text"    # Default output format
    )
    #>


######## Function to create a random time stamp ########
    function Generate-RandomTimeStamp {
    $daysAgo = 30
    $startTime = (Get-Date).AddDays(-$daysAgo)   # 30 days ago
    $endTime = Get-Date
    #$random = Get-Random -Minimum 1 -Maximum 11 #Gets you between 1 and 10 
    #Write-Host "$random"
    <#
    $startTime.Ticks -- numeric start of the range.
    $endTime.Ticks --  numeric end of the range.
    Get-Random -- picks a random tick count between those two numbers.
    Get-Date(random ticks) -- converts that number back into a proper date/time.
    $randomTime --  now holds a random DateTime object somewhere in the last $daysAgo days
    #>
    $randomTime = Get-Date ((Get-Random -Minimum $startTime.Ticks -Maximum $endTime.Ticks))
    <#
    # Plain text
    $plainTextTime = $randomTime.ToString("yyyy-MM-dd HH:mm:ss")
    #Write-Host "$plainTextTime"

    # CSV or ISO-like
    $csvTime = $randomTime.ToString("yyyy-MM-ddTHH:mm:ss")
    #Write-Host "$csvTime"

    # JSON with milliseconds
    $jsonTime = $randomTime.ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
    #Write-Host "$jsonTime"
    #>

    #### Return as a hashtable ####
    return @{
        PlainText = $randomTime.ToString("yyyy-MM-dd HH:mm:ss")
        CSV       = $randomTime.ToString("yyyy-MM-ddTHH:mm:ss")
        JSON      = $randomTime.ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
    }
}
### EXAMPLE USAGE ###
<#
$timeStamp = Generate-RandomTimeStamp
$timeStamp.PlainText   # 2025-11-19 21:09:23
$timeStamps.CSV        # 2025-11-19T21:09:23
$timeStamp.JSON        # 2025-11-19T21:09:23.289Z
#>
#Generate-RandomTimeStamp


#Random user/logID generator
######## Function to create a random user with a log event ID ########
function Generate-RandomUserLog {
    # Function Variables that can modify output/return
    $domain = "@leeTestDomain.com"
    $MinLength = 4
    $MaxLength = 8
    ### USERNAME GENERATION SECTION ###
    $totalLength = Get-Random -Minimum $MinLength -Maximum ($MaxLength + 1)
    # Number of letters (at least 3 currently, but could be full length)
    $letterCount = Get-Random -Minimum 3 -Maximum ($totalLength + 1)
    # Numbers are optional depending on what random $totalLength and $letter count that was generated
    $numberCount = $totalLength - $letterCount
    <#
    This creates a range of numbers from 97 to 122, which are ASCII codes for lowercase letters:
    Pipe (|) to Get-Random -Count $letterCount This takes that list of numbers and randomly selects $letterCount items to get the actual letters
    ForEach-Object { [char]$_ } -- Converts each to an actual letter so [char]97 is a and so on and so forth and 
    then the -join combines the array into a single string
    #>
    $letters = -join (97..122 | Get-Random -Count $letterCount | ForEach-Object { [char]$_ })

    $numbers = ""
    if ($numberCount -gt 0) {
        $numbers = -join (0..9 | Get-Random -Count $numberCount)
        }
    $user = "$letters$numbers"
    $email = $user + $domain

    ### LOG ID GENERATION SECTION ###
    $guid = [guid]::NewGuid().ToString() # A GUID (Globally Unique Identifier) is a 128-bit value and should be unique
    Write-Host "$guid"
    # Return as a hashtable
    #<#
    return @{
        Email = $email
        LogID = $guid
    }
    #>
}
### EXAMPLE USAGE ###
<#
$userLog = Generate-RandomUserLog
$userLog.Email   # zvm721@leeTestDomain.com
$userLog.LogID   # 3e288663-54d7-433c-9dfb-de98583daea0
#>
#Generate-RandomUserLog

#Random log level generator (INFO/WARN/ERROR)
######## Function to create a log level for a log event ########
function Generate-LogLevel {


}
Generate-LogLevel
