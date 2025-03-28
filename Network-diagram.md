![network](https://github.com/user-attachments/assets/e703a2d8-8593-412f-a37d-319d675490d8)


Network Topology Overview
This document describes the network architecture of my home laboratory environment, designed to provide segmentation, security, and flexibility for various services and testing purposes.
Network Segments
1. Home Router (VMBR0)

Role: Primary network interface
Network Range: 192.168.x.x
Function: Main entry point for home network connectivity

2. DMZ Network (VMBR1)

Network Range: 10.10.x.x
Role: Demilitarized Zone for isolated services
Purpose: Provides an additional layer of network security for exposed services

3. General Home Network

Hosted Services:

Pihole
Searxng
Nextcloud
Additional home services and applications


4. Pentest Network

Purpose: Isolated network for security testing and vulnerability research
Isolation: Completely separated from main home network for security

Network Architecture Highlights

Utilizes multiple network bridges (VMBR0, VMBR1) for network segmentation
Implements DMZ for additional security
Separates general home services from potential testing/experimental networks

Security Considerations

DMZ network provides an additional security layer
Pentest network is isolated to prevent potential compromise of main network
Multiple network segments allow for granular access control
