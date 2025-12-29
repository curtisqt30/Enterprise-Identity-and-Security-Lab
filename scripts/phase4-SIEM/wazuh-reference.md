# Phase 4: Wazuh SIEM Setup Guide

## Overview

This phase adds a Wazuh SIEM server to collect and analyze security events from your Windows domain environment.

## Prerequisites

- Phase 1-3 complete (DC01 and CLIENT01 running)
- Additional 4GB RAM available for Wazuh VM

## Step 1: Deploy Wazuh Server

From your host machine (Admin PowerShell):

```powershell
vagrant up wazuh01 --provider=hyperv
```

This will:
- Download Ubuntu 22.04 box
- Create WAZUH01 VM
- Install Wazuh all-in-one (manager + indexer + dashboard)

**Note:** Installation takes 15-20 minutes.

## Step 2: Get Wazuh Server Details

Connect to WAZUH01 in Hyper-V Manager, then:

```bash
# Get IP address
hostname -I

# Get dashboard credentials
cat /home/vagrant/wazuh-credentials.txt
```

Save the IP and admin password.

## Step 3: Access Dashboard

Open browser and navigate to:
```
https://<WAZUH_IP>
```

Login with:
- Username: `admin`
- Password: (from wazuh-credentials.txt)

## Step 4: Deploy Agents

On **DC01** (PowerShell as Admin):

```powershell
# Copy script content or download from repo
.\scripts\phase4-siem\02-deploy-windows-agent.ps1 -WazuhServerIP "<WAZUH_IP>"
```

On **CLIENT01** (PowerShell as Admin):

```powershell
.\scripts\phase4-siem\02-deploy-windows-agent.ps1 -WazuhServerIP "<WAZUH_IP>"
```

## Step 5: Verify Agents

In Wazuh dashboard:
1. Go to **Agents** section
2. You should see DC01 and CLIENT01 listed as active

## What Wazuh Monitors

With the default configuration, Wazuh will collect:

| Source | Events |
|--------|--------|
| Windows Security Log | Logon/logoff, account changes, privilege use |
| Windows System Log | Service changes, system errors |
| Windows Application Log | Application errors, installations |
| Sysmon (if installed) | Process creation, network connections |

## Testing Detection

Generate some events to see Wazuh in action:

1. **Failed logon attempts** - Try wrong password on CLIENT01
2. **User creation** - Create a new AD user on DC01
3. **Group membership change** - Add user to a group
4. **Password reset** - Reset a user's password

These should appear in the Wazuh dashboard under **Security Events**.

## Optional: Enhanced Windows Logging

For deeper visibility, enable advanced audit policies (already partially done in Phase 3):

```powershell
# On DC01 - Enable command line logging
auditpol /set /subcategory:"Process Creation" /success:enable
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System\Audit" /v ProcessCreationIncludeCmdLine_Enabled /t REG_DWORD /d 1 /f
```

## Troubleshooting

**Agent not connecting:**
```powershell
# Check service status
Get-Service WazuhSvc

# Check agent logs
Get-Content "C:\Program Files (x86)\ossec-agent\logs\ossec.log" -Tail 50
```

**Dashboard not loading:**
```bash
# On wazuh01 - check services
systemctl status wazuh-manager
systemctl status wazuh-indexer
systemctl status wazuh-dashboard
```

## Network Requirements

Ensure these ports are open between VMs:

| Source | Destination | Port | Purpose |
|--------|-------------|------|---------|
| DC01/CLIENT01 | WAZUH01 | 1514/TCP | Agent registration |
| DC01/CLIENT01 | WAZUH01 | 1515/TCP | Agent communication |
| Your browser | WAZUH01 | 443/TCP | Dashboard access |