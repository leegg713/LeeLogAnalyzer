# Imports configuration file config.ps1
. "$PSScriptRoot\config.ps1"
Write-Host "Test to see if this is working"
# Gets the log path from config file -- So it basically makes the variable a global one in a way
$LogPath 
Write-Host "$LogPath"