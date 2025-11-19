Overview & goals

MARK STEP AS COMPLETE AFTER YOU DO IT TO TRACK CHANGES OR USE ISSUES ON GITHUB TO TRACK

Goal: build a production-like Log Simulator + Analyzer that supports multiple services, real-time streaming, correlation, anomaly detection, a CLI dashboard, report output, and basic alerting.
Platform: PowerShell 7 running in GitHub Codespaces. Store persistent state in a local workspace folder or a dotfile directory.

Day 0 (Preparation — 1 hour)

Purpose: create project skeleton, decide config, and install any minimal tooling.

Tasks

Create a repo and Codespace.

Define project name, README, and license.

Create folders: generator/, analyzer/, docs/, data/, tests/, scripts/.

Decide and document the log formats you’ll support (newline JSON + plain text). Write one-paragraph descriptions for each format (fields, optional fields).

Create a simple config spec document listing CLI flags and config file options (output path, log rate, services, bad-actor toggle, real-time vs batch, analyzer watch interval, thresholds).

Add a short “how to run” section to the README.

Deliverables

Repo scaffold with folders and README stub.

Config spec file (plain text MD).

Quick checks

You can open the Codespace terminal and create files.

README contains the project goals and config summary.

Day 1 (Generator core — ~6 hours)

Purpose: get a robust multi-service log generator that can run in batch and streaming modes.

High-level design decisions

Generator supports multiple synthetic “services” (e.g., auth, web, db, worker). Each service has a characteristic event profile.

Support two modes: batch (generate N logs and exit) and streaming (append logs to file(s) continuously).

Support both plain-text lines and single-line JSON-per-line logs.

Ability to designate a “bad actor” user or IP and tune its behavior.

Tasks

Define service profiles:

For each service list typical events, probabilities, error rates, average latency distribution, and fields to include (timestamp, level, user, sessionId, correlationId, ip, component, latencyMs, statusCode).

Implement batch generator:

Accept parameters: number of events, log types, time range, output directory.

For each event select service → event type → level based on probabilities → fill fields → serialize to chosen format → append to file.

Implement streaming generator:

Accept parameters: events-per-second, runtime duration, rotating file option.

Support writing to multiple log files concurrently (one per service).

Add “bad actor” behavior:

Spike error events, many failed logins, or high request rate from one IP/user.

Add simple log rotation:

New file per hour or size-based rotation.

Add a config file loader so you can change service profiles and rates without editing code.

Deliverables

Generator produces realistic logs into data/logs/ with at least three log files (system/app/access).

Config file exists in config/ describing service profiles.

Testing

Generate 10K events in batch mode and inspect files for diversity of events and correct formatting.

Run streaming for 1 minute and ensure files are appended and rotated as expected.

Validate bad-actor appears in logs with expected behavior.

Acceptance criteria

Generated logs contain timestamps, levels, user/session IDs and are readable by a human.

Both JSON and text outputs supported and documented.

Day 2 (Analyzer basics + parsing + normalization — ~8 hours)

Purpose: build the engine to ingest logs, normalize disparate formats into a common internal representation, and produce core analytics.

High-level design decisions

Analyzer will accept a log directory or single file, detect format per line/file, and normalize into a record with fixed fields (timestamp, level, service, event, user, sessionId, correlationId, ip, latencyMs, rawMessage).

Analyzer supports both batch processing (scan historical logs) and tailing (real-time).

Tasks

Build ingestion pipeline:

File discovery over a directory (recursively), open files, and read line-by-line.

Format detection: JSON lines vs plain text. Create robust parsing rules for text format.

Create normalization mapping for each service/event type.

Implement a simple datastore:

In-memory store during a run with optional snapshot to a JSON or CSV summary file.

Persist state (e.g., last-read offsets) so the tailing mode can resume without reprocessing earlier data.

Implement core metrics:

Total logs processed, count by level, count by service, count by event type.

Lines/events per minute histogram.

Lines added/removed equivalent: for this project, track total events and bytes written per service.

Implement error rules and basic anomaly detection:

Errors-per-minute calculation.

Threshold alerts when errors-per-minute exceeds a configured rate.

Flag spikes: sudden change of >X% over baseline (baseline can be rolling average).

Implement pattern search:

Allow user to supply keywords or regex filters to find matching events.

CLI for basic reports:

Summaries (overall), per-service breakdown, top N users causing errors, suspicious users list.

Deliverables

Analyzer can ingest the generated logs and emit plain-text summaries.

Snapshot or summary files written under data/analysis/.

Testing

Feed generated logs from Day 1 and verify counts (total lines, errors) match expected proportions.

Simulate a bad-actor and ensure analyzer flags it.

Test pattern searches across many files and confirm results.

Acceptance criteria

Analyzer can parse both JSON and text logs and create coherent summaries.

Alerts fire when error rates breach configured thresholds.

Day 3 (Correlation, real-time, dashboard, and alerts — ~8 hours)

Purpose: add cross-log correlation, real-time tailing + dashboard, and a lightweight alert system.

High-level design decisions

Correlation uses sessionId or correlationId first, then falls back to user+time proximity.

Real-time mode tails files and updates in-memory metrics and the dashboard every few seconds.

Alerts can be simple console messages, and optionally write to an alerts file or send a webhook (configurable).

Tasks

Correlation engine:

When processing events, store events keyed by correlationId or sessionId.

Provide queries: show full trace for a correlationId, show timeline for a session.

Build a summary that counts how many events belong to the same correlation and average latency across the trace.

Real-time tailing:

Implement file-watching or tail logic using safe file-read offsets.

Periodically aggregate metrics and append to rolling window for anomaly detection.

Dashboard CLI:

Text-based dashboard that refreshes: total logs/min, errors/min, top error users, top services, recent alerts.

Optionally a “drill down” mode to inspect traces.

Alerts:

Define alert rules in config (e.g., errors/min > X for Y minutes, or failed logins > Z in 60s).

When rule triggers, emit alert with context (which user, last N events, file, timestamp).

Optionally write alerts to an alerts/ file and support a webhook target URL.

Performance tuning:

Ensure tailing + correlation for modest load (say ~1000 EPS) runs without runaway memory usage: implement retention (drop old entries older than N minutes) and sampling if needed.

Documentation:

Update README with tailing usage, alert config, and dashboard instructions.

Deliverables

Working tail mode with live dashboard.

Correlation trace query available.

Alerts are generated for simulated conditions.

Testing

Start generator streaming with a configured bad-actor and high error rate, then run analyzer in tail mode and confirm real-time alerts and dashboard updates.

Run load for X minutes and monitor memory to ensure retention policy works.

Acceptance criteria

Real-time mode updates metrics and fires alerts in a timely manner.

Correlation traces can be retrieved and show linked events across services.

Day 4 (Polish, reporting, CI, tests, and extras — 4–8 hours)

Purpose: make the tool robust, add reporting export, tests, CI, and polish.

Tasks

Reporting:

Implement HTML or JSON report generation for end-of-day summaries; include counts, top offenders, charts (simple ASCII histograms or JSON suitable for plotting).

Unit & integration tests:

Create test logs and test cases verifying parser behavior, metric calculations, alert triggers, and correlation logic.

Continuous Integration:

Add a CI workflow that runs the analyzer tests on push and optionally runs a small generator→analyzer smoke test.

Packaging & distribution:

Add a simple install/run script to make it easy to run in Codespaces (documented only, no code here).

Performance benchmarks:

Document observed EPS handling and memory usage under test loads.

Nice-to-haves (pick a couple):

Add compressed log output (rotate and gz).

Add a small web UI (optional; could be a separate day).

Add webhook integration to send alerts to Slack/Discord.

Deliverables

Test suite in tests/.

CI workflow in repo.

Final README with examples, sample reports in data/reports/.

Performance notes and known limitations.

Testing

Run CI tests locally or via Codespaces CI run.

Generate a sample full-day log and produce final report.

Acceptance criteria

Tests pass.

Final report produced and readable.

CI detects regressions.

Implementation & engineering notes (non-code)

Keep modules small and focused: generator, parser, normalizer, metrics, correlation, dashboard, alert engine, persistence.

Use a single JSON/YAML config file to tune behavior and thresholds.

Persist analyzer state (offsets, rolling averages) so you can resume tailing without reprocessing.

For correlation, limit memory by expiring old sessions/traces after a configurable retention window.

Design logs so each line can be parsed independently (newline-delimited JSON or predictable text format).

Use deterministic randomness for generator during tests (seed option) so test outputs are reproducible.

Risks & how to mitigate

Memory growth in correlation: mitigate by retention and sampling.

Parsing ambiguity in free-form text: prefer JSON for critical fields, or standardize text logs with key=value metadata.

False positives in anomaly detection: use rolling baseline and require sustained thresholds (e.g., breach for Y seconds).

Deliverables checklist (final)

Generator: batch + streaming, multiple services, bad-actor mode.

Analyzer: parser, normalizer, metrics, anomalies, pattern search.

Real-time tailing + dashboard.

Correlation engine and trace query.

Alerts (console/file/webhook).

Tests, CI, README, sample logs, and sample report.