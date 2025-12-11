<#
.SYNOPSIS
    Analyzes logs that are used to simulate event logs

.DESCRIPTION
    Analyzes logs and outputs the metrics to $PSScriptRoot/data/analysis/

.EXAMPLE
    ./analyzer.ps1 
    ./analyzer.ps1 
    ./analyzer.ps1 


.NOTES
    Used to analyze the logs that we create in generator.ps1 

#>

[CmdletBinding()]
param
(
    <#
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
    #>
)
# Imports configuration file config.ps1
. "$PSScriptRoot\config.ps1"

# Imports utils.ps1 file
. "$PSScriptRoot\utils.ps1"
