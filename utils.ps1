<#
#### FUNCTIONS TO WORK ON ####
Random timestamp generator

 Random user/session/correlation ID generator

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


# Function to create a random time stamp
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
    # Plain text
    $plainTextTime = $randomTime.ToString("yyyy-MM-dd HH:mm:ss")
    #Write-Host "$plainTextTime"

    # CSV or ISO-like
    $csvTime = $randomTime.ToString("yyyy-MM-ddTHH:mm:ss")
    #Write-Host "$csvTime"

    # JSON with milliseconds
    $jsonTime = $randomTime.ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
    #Write-Host "$jsonTime"

    # Return as a hashtable
    return @{
        PlainText = $randomTime.ToString("yyyy-MM-dd HH:mm:ss")
        CSV       = $randomTime.ToString("yyyy-MM-ddTHH:mm:ss")
        JSON      = $randomTime.ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
    }
### EXAMPLE USAGE ###
<#
$timeStamp = Generate-RandomTimeStamp
$timeStamp.PlainText   # 2025-11-19 21:09:23
$timeStamps.CSV        # 2025-11-19T21:09:23
$timeStamp.JSON        # 2025-11-19T21:09:23.289Z
#>
}
Generate-RandomTimeStamp