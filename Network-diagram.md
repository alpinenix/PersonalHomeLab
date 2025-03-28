![network](https://github.com/user-attachments/assets/e703a2d8-8593-412f-a37d-319d675490d8)

Network Topology Overview
This document describes the advanced network architecture of my home laboratory environment, designed to provide comprehensive network segmentation, security testing, and advanced monitoring capabilities.
Network Segments
1. Home Router (VMBR0)

Role: Primary network interface
Network Range: 192.168.x.x
Function: Main entry point for home network connectivity

2. DMZ Network (VMBR1)

Network Range: 10.10.x.x
Role: Demilitarized Zone for isolated services
Advanced Security Components:

SIEM | WAZUH (Security Information and Event Management)
SOAR | SHUFFLE (Security Orchestration, Automation, and Response)


Purpose:

Provide a controlled environment for security tool testing
Enable advanced threat detection and response capabilities
Simulate complex network security scenarios


3. General Home Network

Hosted Services:

Pihole (Network-wide ad blocking)
Searxng (Private meta search engine)
Nextcloud (Private cloud storage and productivity platform)
Additional home services and applications


4. Pentest/Purple Team Network

Purpose: Dedicated environment for security testing and research
Capabilities:

Isolated network for offensive and defensive security practices
Simulate attack and defense scenarios
Test security tools and techniques


Isolation: Completely separated from main home network for maximum security

Network Architecture Highlights

Multi-layered network segmentation using different network bridges (VMBR0, VMBR1)
Advanced security testing capabilities in DMZ
Comprehensive isolation between different network segments
Integrated security monitoring and response infrastructure

Security Considerations

DMZ provides a controlled environment for security tool testing
SIEM and SOAR enable advanced threat detection and automated response
IDS/IPS add an extra layer of network protection
Pentest network allows safe exploration of security tools and techniques
Strict network segmentation prevents cross-contamination between environments
