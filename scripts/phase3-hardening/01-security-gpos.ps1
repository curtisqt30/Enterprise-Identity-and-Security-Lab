#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Creates and links security hardening GPOs.
.DESCRIPTION
    Phase 3: Implements CySA+ aligned security controls via Group Policy.
    - Password Policy
    - Account Lockout Policy  
    - USB Storage Restrictions
    - Screen Lock Timeout
    - Advanced Audit Logging
.NOTES
    Run on Domain Controller.
#>

Import-Module GroupPolicy

$DomainName = "lab.local"
$DomainDN = "DC=lab,DC=local"

Write-Host "=== Phase 3: Security Hardening GPOs ===" -ForegroundColor Cyan

# ============================================
# GPO 1: Password & Account Lockout Policy
# ============================================
Write-Host "[1/4] Creating Password Policy GPO..." -ForegroundColor Yellow

$GPOName = "SEC - Password and Lockout Policy"
$GPO = New-GPO -Name $GPOName -Comment "Enforces strong password and account lockout settings"

# Link to domain root (applies to all)
New-GPLink -Name $GPOName -Target $DomainDN

# Note: Password policies must be set via Default Domain Policy or Fine-Grained Password Policies
# This script creates the GPO structure - manual configuration via GPMC recommended for:
#   - Minimum password length: 12 characters
#   - Password complexity: Enabled
#   - Maximum password age: 90 days
#   - Account lockout threshold: 5 attempts
#   - Account lockout duration: 30 minutes
#   - Reset lockout counter: 30 minutes

Write-Host "  Created: $GPOName (configure settings in GPMC)" -ForegroundColor Gray

# ============================================
# GPO 2: USB Storage Restriction
# ============================================
Write-Host "[2/4] Creating USB Restriction GPO..." -ForegroundColor Yellow

$GPOName = "SEC - Disable USB Storage"
$GPO = New-GPO -Name $GPOName -Comment "Prevents use of removable storage devices"

# Set registry value to disable USB storage
Set-GPRegistryValue -Name $GPOName `
    -Key "HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR" `
    -ValueName "Start" `
    -Type DWord `
    -Value 4

New-GPLink -Name $GPOName -Target "OU=LAB Computers,$DomainDN"

Write-Host "  Created and linked: $GPOName" -ForegroundColor Gray

# ============================================
# GPO 3: Screen Lock Policy
# ============================================
Write-Host "[3/4] Creating Screen Lock GPO..." -ForegroundColor Yellow

$GPOName = "SEC - Screen Lock Timeout"
$GPO = New-GPO -Name $GPOName -Comment "Enforces screen lock after inactivity"

# Screen saver timeout (900 seconds = 15 minutes)
Set-GPRegistryValue -Name $GPOName `
    -Key "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop" `
    -ValueName "ScreenSaveTimeOut" `
    -Type String `
    -Value "900"

# Require password on resume
Set-GPRegistryValue -Name $GPOName `
    -Key "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop" `
    -ValueName "ScreenSaverIsSecure" `
    -Type String `
    -Value "1"

New-GPLink -Name $GPOName -Target "OU=LAB Computers,$DomainDN"

Write-Host "  Created and linked: $GPOName" -ForegroundColor Gray

# ============================================
# GPO 4: Advanced Audit Policy
# ============================================
Write-Host "[4/4] Creating Audit Policy GPO..." -ForegroundColor Yellow

$GPOName = "SEC - Advanced Audit Logging"
$GPO = New-GPO -Name $GPOName -Comment "Enables detailed security auditing for SOC analysis"

New-GPLink -Name $GPOName -Target $DomainDN

# Advanced Audit Policies are best configured via:
#   auditpol.exe or Security Settings in GPMC
# Key events to audit:
#   - Logon Success/Failure
#   - Account Lockout
#   - Credential Validation
#   - Security Group Modifications
#   - User Account Management

Write-Host "  Created: $GPOName (configure audit categories in GPMC)" -ForegroundColor Gray

Write-Host "`n=== Phase 3 GPOs Created ===" -ForegroundColor Green
Write-Host @"

Next Steps:
1. Open Group Policy Management Console (gpmc.msc)
2. Configure password policy in Default Domain Policy
3. Review and adjust audit policies as needed
4. Run 'gpupdate /force' on clients to apply

"@ -ForegroundColor Gray