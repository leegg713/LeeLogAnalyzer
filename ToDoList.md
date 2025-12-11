MARK STEP AS COMPLETE AFTER YOU DO IT TO TRACK CHANGES OR USE ISSUES ON GITHUB TO TRACK BIGGER CHANGES OR UPDATES

Create a repo and Codespace. -- Completed 

https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository

Define project name, README, and license. -- Completed (FURTHER REVIEW OF LICENSE AT A LATER DATE)

Phase 1 — Setup & Basic Structure

Create folders: generator/, analyzer/, docs/, data/, tests/, scripts/. etc -- Completed

 Create empty scripts: generator.ps1, analyzer.ps1, utils.ps1, config.ps1

 Define project name, README, and license. -- Completed (FURTHER REVIEW OF LICENSE AT A LATER DATE)

 Add .gitignore and ignore data/logs/ and data/analysis/  -- Completed -- Ignoring whole data folder in git

Phase 2 — Config

Define services and events in config.ps1 -- Completed (Can add more later for further analysis)

Event types with probabilities and error rates -- Completed (Can adjust and modify as needed)

Define default paths for logs and analysis output -- Completed

Set thresholds for alerts (e.g., errors/minute, failed logins) -- Completed

Add streaming parameters defaults (events/sec, duration) -- Completed 

Phase 3 — Utils Functions

 Random timestamp generator -- Completed

 Random user/session/correlation ID generator -- Completed

 Random log level generator (INFO/WARN/ERROR) -- Completed 

Phase 4 — Generator.ps1

 Dot-source utils.ps1 and config.ps1 - Completed

 Add CLI argument parsing for: - Completed

Batch vs streaming mode - Both completed

 Write generated events to data/logs/ - Completed
 
Parameter to append to the file instead of overwrite - Completed

Optional: print summary of generation (number of logs, bad actor events) - Completed

Phase 5 — Analyzer.ps1

First 3 can go in utils or analyzer its up to you

Parsing helper functions (for analyzer)

 Normalization and correlation helpers (for analyzer)

 Metrics calculation helpers (error counts, events per minute, etc.)

 Dot-source utils.ps1 and config.ps1

 Add CLI argument parsing for:

Batch vs tailing mode

Target log file(s) or folder

 Load and parse logs from data/logs/

 Normalize log entries

 Compute metrics:

Errors per minute per service

Log counts

TODO: correlation of events by session or ID

 Detect anomalies based on thresholds

 Trigger alerts (console output + optional file output in data/analysis/)

 Generate summary reports in data/analysis/ (JSON or text)

Phase 6 — Testing

 Create small test logs in data/logs/ for validation

 Test generator in batch and streaming modes

 Test analyzer for parsing, metrics, alerting

 Verify bad actor anomalies appear as expected

 Make sure output files go to data/analysis/ and logs go to data/logs/

Phase 7 — Documentation

 Write README sections:

Project overview

Folder/file structure

Usage examples (generator + analyzer)

How to configure services/events/thresholds

 Add license info to README

Phase 8 — Optional Enhancements

Change user log to generate username list to use for logs so we have one user having multiple events

 Real-time CLI dashboard in analyzer

 Configurable output formats (JSON, CSV, text)

 Additional log types or services

 Extra anomaly detection rules

 Enable/disable bad actor automatically

 Make the streaming mode be exactly a second for each loop and not a little off (Stopwatch needed)
