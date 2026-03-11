# Detection Engineering Lab: MITRE ATT&CK Coverage Analysis

## Overview

This project demonstrates a detection engineering workflow built on cloud infrastructure using Infrastructure as Code (IaC). The lab deploys a simulated enterprise environment in Azure where attacker techniques are executed and telemetry is collected for detection development.

The environment is deployed using Azure Bicep, which provisions a Windows server instrumented with **Sysmon** to capture detailed endpoint telemetry. Logs are collected using the Azure Monitor Agent and Data Collection Rules, and streamed into Microsoft Sentinel and Splunk for security monitoring and detection development.

Attacker behaviors are simulated using Atomic Red Team from a Kali Linux host. Detection rules are developed using SIEM queries and mapped to the MITRE ATT&CK framework to evaluate detection coverage across common adversary techniques such as credential access, lateral movement, and command-and-control activity.

The goal of this project is to demonstrate how security telemetry pipelines and SIEM detections can be engineered to identify attacker behavior and measure detection coverage across the MITRE ATT&CK framework.

---

# Technologies Used

| Technology | Purpose |
|-----------|--------|
| Azure Bicep | Infrastructure as Code deployment |
| Microsoft Sentinel | SIEM and detection platform |
| Splunk | SIEM log analysis |
| Atomic Red Team | Attack simulation framework |
| Sysmon | Endpoint telemetry collection |
| Windows Active Directory | Simulated enterprise identity environment |
| Azure Monitor Agent | Telemetry forwarding |
| Log Analytics Workspace | Centralized log storage |
| MITRE ATT&CK Framework | Detection coverage mapping |
| Kali Linux | Attacker simulation host |

---

# Architecture

This lab simulates a real-world enterprise security monitoring pipeline where attacker activity is generated, endpoint telemetry is collected, and detection rules are developed within SIEM platforms.

Attack simulations are executed using Atomic Red Team against a Windows environment instrumented with Sysmon. Endpoint logs are collected using the Azure Monitor Agent and forwarded to a Log Analytics Workspace, where Microsoft Sentinel analyzes the data for security detections.

Splunk is also used as a secondary SIEM platform to compare detection logic and validate telemetry across platforms.

### Security Monitoring Pipeline

- Attack Simulation (Atomic Red Team / Kali Linux)
- Windows Enterprise Environment (Active Directory + Endpoints)
- Endpoint Telemetry Collection (Windows Event Logs + Sysmon)
- Log Ingestion into SIEM Platforms (Microsoft Sentinel and Splunk)
- Detection Engineering using SIEM queries (KQL and SPL)
- MITRE ATT&CK Detection Coverage Analysis

---

# Detection Pipeline

<img width="1024" height="1536" alt="image" src="https://github.com/user-attachments/assets/5ab2904c-e10b-4f9c-af45-467ea4320073" />

MITRE ATT&CK Coverage Mapping


---

## Detection Engineering Workflow

Detection engineering in this lab follows a structured process:

1. Simulate attacker techniques using Atomic Red Team
2. Generate endpoint telemetry using Sysmon and Windows Event Logs
3. Ingest logs into SIEM platforms
4. Develop detection queries using KQL (Sentinel) and SPL (Splunk)
5. Map detections to MITRE ATT&CK techniques
6. Evaluate detection coverage and identify monitoring gaps

Detection rules are tuned to reduce false positives and improve signal quality while maintaining coverage for relevant attacker behaviors.

---

## Example Detection Scenarios

Example attack behaviors simulated in this lab include:

- Credential dumping activity  
- Suspicious PowerShell execution  
- Lateral movement using remote services  
- Privilege escalation events  
- Command-and-control network activity  

Each detection rule is mapped to a MITRE ATT&CK technique to measure how effectively security telemetry can identify adversary behavior.

---

## MITRE ATT&CK Coverage Analysis

Detection results are evaluated against the MITRE ATT&CK framework to determine which techniques are successfully detected and where monitoring gaps exist.

This allows security teams to:

- Measure detection coverage  
- Identify blind spots in telemetry collection  
- Improve SIEM detection logic  
- Strengthen overall security monitoring capabilities  

---

## Project Objective

This project demonstrates how a detection engineering pipeline can be built from infrastructure deployment to telemetry ingestion and detection development.

By combining attack simulation, endpoint telemetry, and SIEM detection logic, the lab provides a practical environment for developing and validating security detections mapped to real-world attacker behaviors.
