#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Windows client domain join configuration.
.DESCRIPTION
    Phase 1: Configures DNS to point to DC and joins the domain.
#>

$DomainName = "lab.local"
$DCIPAddress = "192.168.56.10"
$DomainAdmin = "LAB\Administrator"
$DomainPassword = ConvertTo-SecureString "vagrant" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($DomainAdmin, $DomainPassword)

Write-Host "=== Phase 1: Client Domain Join ===" -ForegroundColor Cyan

# Configure DNS to point to Domain Controller
Write-Host "[1/3] Configuring DNS to point to DC..." -ForegroundColor Yellow
$adapter = Get-NetAdapter | Where-Object { $_.Status -eq "Up" -and $_.Name -like "*Ethernet*" } | Select-Object -First 1
Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -ServerAddresses $DCIPAddress

# Test connectivity to DC
Write-Host "[2/3] Testing connectivity to Domain Controller..." -ForegroundColor Yellow
$maxRetries = 5
$retryCount = 0
do {
    $ping = Test-Connection -ComputerName $DCIPAddress -Count 1 -Quiet
    if (-not $ping) {
        $retryCount++
        Write-Host "  Waiting for DC... (Attempt $retryCount/$maxRetries)" -ForegroundColor Gray
        Start-Sleep -Seconds 10
    }
} while (-not $ping -and $retryCount -lt $maxRetries)

if (-not $ping) {
    Write-Host "ERROR: Cannot reach Domain Controller. Ensure DC01 is running." -ForegroundColor Red
    exit 1
}

# Join domain
Write-Host "[3/3] Joining domain: $DomainName..." -ForegroundColor Yellow
Add-Computer -DomainName $DomainName -Credential $Credential -Restart -Force

Write-Host "Domain join complete. Client will reboot." -ForegroundColor Green