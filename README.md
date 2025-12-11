# LeeLogAnalyzer
This will be a repository that functions like a splunk type tool for practicing reading logs and alerting. 

# This will contain information that will be useful for other projects
# Will track import things I learn along with useful links and external documentation
# Will help create a good read me at the end

# Config File

- Stores all configurable parameters: services, events, thresholds, log paths, streaming settings.
- Configuration file is used to get the settings to use for analzyer and generator script so that any changes to either are made in the configuration file
- Essentially a centralized spot to make changes for different script runs 

# Analzyer File

# Generator File
- How to import a PowerShell file to another script to use it -- Imports utils.ps1 file      . "$PSScriptRoot\utils.ps1"
- Useful for pulling utils or config or anything else for a different project

- This script generates simulated event logs in either batch or streaming mode and writes them to CSV, JSON, and plain-text files using paths, sizes, and rates defined in config.ps1.

- It uses the separate config and utility files, creating clean log entries with simple custom objects, and builds file paths for the logs to go based off the information in config.ps1. 

- It also has optional features—such as appending to existing logs or clearing old ones with switch parameters. 

- The script handles timing for streaming mode with basic date and sleep functions, validates user input, automatically creates folders when needed, and organizes log data in formats like CSV, JSON, and plain text so everything is easy to read and reuse when analyzing the data with analyzer.ps1.

# Utils File