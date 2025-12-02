[CmdletBinding()]
param
(
	[Parameter(Mandatory = $True)]
    [ValidateSet("Batch", "Streaming")]
    [string]$Mode,
    [Parameter(Mandatory = $False)]
    [int]$AmountOfEvents # Only 
)
# Imports configuration file config.ps1
. "$PSScriptRoot\config.ps1"
Write-Host "Test to see if this is working"
# Gets the log path from config file -- So it basically makes the variable a global one in a way
$LogPath 
#Write-Host "$LogPath"

# Imports utils.ps1 file
. "$PSScriptRoot\utils.ps1"
$timeStamp = Generate-RandomTimeStamp # Generates a timestamp in JSON, CSV, and PlainText
$timeStamp.JSON
$timeStamp.CSV
$timeStamp.PlainText

