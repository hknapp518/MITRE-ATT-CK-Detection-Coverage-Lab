# MITRE ATT&CK Detection Coverage Lab

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
