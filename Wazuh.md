# Wazuh Installation Documentation

This is my documentation for my Wazuh installation. Theres lots more you can setup and configure, but for my home-lab setup, this just makes sense to me. 

## Overview

[Wazuh](https://wazuh.com/) is an open-source security monitoring solution that provides threat detection, integrity monitoring, incident response, and compliance capabilities. This installation uses the quick start method for a streamlined setup process.

## Prerequisites

- A server with at least 4GB RAM (8GB recommended)
- 50GB of free disk space (minimum)
- Linux-based operating system (this guide uses CentOS/RHEL, but can be adapted for Ubuntu/Debian)
- Root or sudo access
- Valid FQDN (Fully Qualified Domain Name) for your server
- VirusTotal API key

## Installation Steps

### 1. Server Preparation

Update your system packages:

```bash
# For CentOS/RHEL
sudo yum update -y

# For Ubuntu/Debian
sudo apt update && sudo apt upgrade -y
```

### 2. Install Wazuh

Download and run the Wazuh installation script:

```bash
curl -sO https://packages.wazuh.com/4.5/wazuh-install.sh
sudo bash wazuh-install.sh
```

During the installation process, the script will prompt you for:
- The installation type (select "all-in-one")
- Your FQDN (enter your server's fully qualified domain name)

### 3. Configure FQDN

The installation script should automatically detect and configure your FQDN. To verify:

```bash
sudo grep -r "server.host" /etc/wazuh-dashboard/opensearch_dashboards.yml
```

You should see your FQDN listed in the output.

### 4. Integrate VirusTotal API

1. Edit the Wazuh manager configuration file:

```bash
sudo nano /etc/wazuh-manager/ossec.conf
```

2. Add the VirusTotal integration inside the `<ossec_config>` block:

```xml
<integration>
  <name>virustotal</name>
  <api_key>YOUR_VIRUSTOTAL_API_KEY</api_key>
  <group>syscheck</group>
  <alert_format>json</alert_format>
</integration>
```

Replace `YOUR_VIRUSTOTAL_API_KEY` with your actual VirusTotal API key.

3. Restart the Wazuh manager:

```bash
sudo systemctl restart wazuh-manager
```

### 5. Verify Installation

1. Check the status of Wazuh services:

```bash
sudo systemctl status wazuh-manager
sudo systemctl status wazuh-indexer
sudo systemctl status wazuh-dashboard
```

2. Access the Wazuh dashboard:
   - Open your web browser and navigate to `https://your-fqdn`
   - Log in with the credentials generated during installation
     - Default username: `admin`
     - The password can be found in the file: `/etc/wazuh-dashboard/passwords/wazuh-password.txt`

### 6. Deploy Wazuh Agents

To monitor additional systems, you'll need to deploy Wazuh agents. From the Wazuh dashboard:

1. Go to "Agents" in the menu
2. Click "Deploy new agent"
3. Follow the on-screen instructions to install agents on your endpoints

## Common Issues and Troubleshooting

### Service Not Starting

If any Wazuh service fails to start:

```bash
# Check logs for Wazuh Manager
sudo tail -f /var/ossec/logs/ossec.log

# Check logs for Wazuh Indexer
sudo tail -f /var/log/wazuh-indexer/wazuh-indexer.log

# Check logs for Wazuh Dashboard
sudo tail -f /var/log/wazuh-dashboard/opensearch_dashboards.log
```

### Certificate Issues

If you encounter certificate problems:

```bash
# Regenerate certificates
sudo /usr/share/wazuh-indexer/bin/wazuh-certificates-tool
sudo systemctl restart wazuh-manager wazuh-indexer wazuh-dashboard
```

### VirusTotal Integration Not Working

If the VirusTotal integration is not functioning:

1. Verify your API key is correctly entered in the configuration
2. Check the Wazuh manager logs for API-related errors:

```bash
sudo grep -i "virustotal" /var/ossec/logs/ossec.log
```

## Maintenance

### Regular Updates

Keep your Wazuh installation up to date:

```bash
sudo wazuh-update
```

### Backup Configuration

Regularly backup your configuration files:

```bash
sudo cp -r /etc/wazuh-manager /backup/wazuh-manager-config
sudo cp -r /etc/wazuh-indexer /backup/wazuh-indexer-config
sudo cp -r /etc/wazuh-dashboard /backup/wazuh-dashboard-config
```

## Resources

- [Wazuh Documentation](https://documentation.wazuh.com/)
- [Wazuh GitHub Repository](https://github.com/wazuh/wazuh)
- [VirusTotal Documentation](https://developers.virustotal.com/reference)
