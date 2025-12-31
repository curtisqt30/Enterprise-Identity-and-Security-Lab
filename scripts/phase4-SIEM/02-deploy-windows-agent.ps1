#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Deploys Wazuh agent to Windows machines.
.DESCRIPTION
    Phase 4: Installs and configures Wazuh agent to connect to Wazuh manager.
.PARAMETER WazuhServerIP
    IP address of the Wazuh manager server.
.NOTES
    Run on DC01 and CLIENT01 after Wazuh server is running.
.EXAMPLE
    .\02-deploy-windows-agent.ps1 -WazuhServerIP "172.28.x.x"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$WazuhServerIP
)

$WazuhVersion = "4.9.0-1"
$AgentName = $env:COMPUTERNAME

Write-Host "=== Phase 4: Wazuh Agent Deployment ===" -ForegroundColor Cyan

# Download Wazuh agent
Write-Host "[1/4] Downloading Wazuh agent..." -ForegroundColor Yellow
$InstallerUrl = "https://packages.wazuh.com/4.x/windows/wazuh-agent-$WazuhVersion.msi"
$InstallerPath = "$env:TEMP\wazuh-agent.msi"
Invoke-WebRequest -Uri $InstallerUrl -OutFile $InstallerPath

# Install agent
Write-Host "[2/4] Installing Wazuh agent..." -ForegroundColor Yellow
$InstallArgs = @(
    "/i", $InstallerPath,
    "/q",
    "WAZUH_MANAGER=$WazuhServerIP",
    "WAZUH_AGENT_NAME=$AgentName",
    "WAZUH_REGISTRATION_SERVER=$WazuhServerIP"
)
Start-Process msiexec.exe -ArgumentList $InstallArgs -Wait

# Start agent service
Write-Host "[3/4] Starting Wazuh agent service..." -ForegroundColor Yellow
Start-Service -Name "WazuhSvc"

# Verify installation
Write-Host "[4/4] Verifying installation..." -ForegroundColor Yellow
$Service = Get-Service -Name "WazuhSvc" -ErrorAction SilentlyContinue
if ($Service.Status -eq "Running") {
    Write-Host "Wazuh agent installed and running!" -ForegroundColor Green
} else {
    Write-Host "Warning: Agent service not running. Check logs at C:\Program Files (x86)\ossec-agent\logs\" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Agent Deployment Complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "Agent Name: $AgentName"
Write-Host "Manager: $WazuhServerIP"
Write-Host "Config: C:\Program Files (x86)\ossec-agent\ossec.conf"
Write-Host "Logs: C:\Program Files (x86)\ossec-agent\logs\"
Write-Host ""