# Detection Engineering Lab: MITRE ATT&CK Coverage Analysis

## Overview

This project demonstrates a detection engineering workflow by simulating real-world cyber attacks and measuring SIEM detection coverage against the MITRE ATT&CK framework.

Attack techniques are executed using Atomic Red Team against a simulated Windows enterprise environment. The resulting telemetry is ingested into Splunk and Microsoft Sentinel where detection rules are developed and mapped to MITRE ATT&CK techniques.

The objective of this lab is to evaluate how effectively security monitoring tools can detect common attacker behaviors and identify gaps in detection coverage.

## Technologies Used

- Splunk SIEM
- Microsoft Sentinel
- Atomic Red Team
- Windows Active Directory
- Sysmon
- MITRE ATT&CK Framework
- Kali Linux

## Architecture

This lab simulates an enterprise detection pipeline where attacker activity is generated, telemetry is collected from Windows systems, and logs are analyzed in SIEM platforms to build detection rules mapped to the MITRE ATT&CK framework.

Attack simulations are executed using Atomic Red Team against a Windows Active Directory environment. Endpoint telemetry is collected using Windows Event Logs and Sysmon and forwarded to SIEM platforms for analysis.

The security monitoring pipeline includes:

1. Attack Simulation (Atomic Red Team / Kali Linux)
2. Windows Enterprise Environment (Active Directory + Endpoints)
3. Telemetry Collection (Windows Security Logs + Sysmon)
4. Log Ingestion into SIEM Platforms (Splunk and Microsoft Sentinel)
5. Detection Engineering using SIEM queries
6. MITRE ATT&CK Detection Coverage Analysis
