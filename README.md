# LeeLogAnalyzer
This will be a repository that functions like a splunk type tool for practicing reading logs and alerting.
This project is for educational and simulation purposes only.
Any response actions (account lockouts, password changes, etc.) are conceptual and should not be used in production environments.

## What This Project Demonstrates
- PowerShell design using multiple ps files
- Config-driven scripting to be able to modify one file to make changes everywhere
- Log analysis and alerting logic
- Streaming vs batch processing
- Script reusability and maintainability

## Project Goals
- Practice log generation, parsing, and alerting logic similar to SIEM tools (e.g., Splunk).
- Provide a lightweight, script-based environment for experimenting with detection logic to learn security logging concepts.
- Keep everything PowerShell-based and dependency-free.

## Not Goals 
- Not intended to replace a real SIEM.
- No real-time correlation across distributed systems.
- No production security enforcement (all “response” actions are simulated and not real).


# Repo Structure

LeeLogAnalyzer/
│
├── analyzer.ps1        # Parses logs, summarizes events, triggers alerts
├── generator.ps1       # Generates simulated logs (batch or streaming)
├── utils.ps1           # Shared helper functions used in analyzer.ps1 and generator.ps1
├── config.ps1          # Centralized configuration for analyzer.ps1 and generator.ps1
│
├── data/
│   └── logs/            # Generated log files in the following formats (CSV/JSON/TXT)
│
└── README.md

## Requirements to Run
- PowerShell 5.1+ or PowerShell 7+
- Windows, macOS, or Linux
- No external modules required currently


# Config File

- Stores all configurable parameters: services, events, thresholds, log paths, streaming settings.
- Configuration file is used to get the settings to use for analzyer and generator script so that any changes to either are made in the configuration file
- Essentially a centralized spot to make changes for different script runs 

# Analzyer File
- Reads log files (CSV/JSON/text) produced by the generator and summarizes events, counts, and basic alerts using thresholds from `config.ps1`.
- Supports both batch and streaming analysis modes with simple filtering by service/event and output to console or file.
- Relies on `config.ps1` for settings and imports `utils.ps1` for shared helper functions; intended for quick exploration and lightweight alerting.

# Generator File
- How to import a PowerShell file to another script to use it -- Imports utils.ps1 file      . "$PSScriptRoot\utils.ps1"
- Useful for pulling utils or config or anything else for a different project

- This script generates simulated event logs in either batch or streaming mode and writes them to CSV, JSON, and plain-text files using paths, sizes, and rates defined in config.ps1.

- It uses the separate config and utility files, creating clean log entries with simple custom objects, and builds file paths for the logs to go based off the information in config.ps1. 

- It also has optional features—such as appending to existing logs or clearing old ones with switch parameters. 

- The script handles timing for streaming mode with basic date and sleep functions, validates user input, automatically creates folders when needed, and organizes log data in formats like CSV, JSON, and plain text so everything is easy to read and reuse when analyzing the data with analyzer.ps1.

# Utils File
- Provides small reusable helper functions (path builders, timestamp formatting, simple log parsing, validation, and file I/O helpers).
- Imported into other scripts with `. "$PSScriptRoot\utils.ps1"` to keep common logic centralized and reusable.
- Keeps `analyzer.ps1` and `generator.ps1` concise by handling repetitive tasks.

# Usage examples (generator + analyzer)
- Run the generator (batch): `./generator.ps1 -Mode batch -Count 100` — creates logs in `data/logs/`.
- Run the generator (streaming): `./generator.ps1 -Mode stream -Rate 5 -Duration 60` — streams events into log files.
- Run the analyzer against a log folder: `./analyzer.ps1` — parses logs, computes counts, and prints alerts.

# How to configure services/events/thresholds
- Edit `config.ps1` to define the services, event types, probabilities, and alert thresholds used by the generator and analyzer.
- Typical configuration elements:
	- A list of services (e.g., web, auth, db).
	- Event definitions with probabilities and error rates (used by the generator to simulate events).
	- Thresholds for alerting (errors per minute, failed logins, etc.) that `analyzer.ps1` uses to trigger alerts.

Example (conceptual snippet):
```
# config.ps1 (concept)
$Services = @('web','auth')
$Events = @{
	'login'   = @{ probability = 0.7; errorRate = 0.01 }
	'request' = @{ probability = 0.3; errorRate = 0.005 }
}
$Thresholds = @{ ErrorsPerMinute = 5; FailedLogins = 3 }
```

- After editing `config.ps1`, re-run the generator or analyzer to apply the new settings.

# Future Enhancements and Updates

- Add anomaly detection rules to send an alert (Email function and logic for error rate per user)

- Change user log to generate username list to use for logs so we have one user having multiple events

- GUI dashboard for analyzer

- Enable/disable bad actor automatically (Function to lock AD account, scramble password, etc -- Just in theory)
