#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Domain Controller initial setup and AD DS promotion.
.DESCRIPTION
    Phase 1: Configures static IP, installs AD DS role, and promotes to Domain Controller.
#>

$DomainName = "lab.local"
$NetBIOSName = "LAB"
$SafeModePassword = ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force

Write-Host "=== Phase 1: Domain Controller Setup ===" -ForegroundColor Cyan

# Set static IP (already set via Vagrant, but ensuring DNS points to self)
Write-Host "[1/4] Configuring network adapter..." -ForegroundColor Yellow
$adapter = Get-NetAdapter | Where-Object { $_.Status -eq "Up" -and $_.Name -like "*Ethernet*" } | Select-Object -First 1
Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -ServerAddresses "127.0.0.1"

# Install AD DS Role
Write-Host "[2/4] Installing AD DS role..." -ForegroundColor Yellow
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Promote to Domain Controller
Write-Host "[3/4] Promoting to Domain Controller..." -ForegroundColor Yellow
Install-ADDSForest `
    -DomainName $DomainName `
    -DomainNetbiosName $NetBIOSName `
    -SafeModeAdministratorPassword $SafeModePassword `
    -InstallDns:$true `
    -Force:$true

# Note: Server will reboot automatically after promotion
Write-Host "[4/4] Promotion complete. Server will reboot." -ForegroundColor Green