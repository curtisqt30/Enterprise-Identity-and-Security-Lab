#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Creates OU structure and bulk users from CSV.
.DESCRIPTION
    Phase 2: Establishes OU hierarchy and creates users with proper group membership.
.NOTES
    Run on Domain Controller after AD DS promotion.
#>

$DomainDN = "DC=lab,DC=local"

Write-Host "=== Phase 2: Identity Management Setup ===" -ForegroundColor Cyan

# ============================================
# Create Organizational Unit Structure
# ============================================
Write-Host "[1/3] Creating OU structure..." -ForegroundColor Yellow

$OUs = @(
    "OU=LAB Users,$DomainDN",
    "OU=IT,OU=LAB Users,$DomainDN",
    "OU=HR,OU=LAB Users,$DomainDN",
    "OU=Finance,OU=LAB Users,$DomainDN",
    "OU=Help Desk,OU=IT,OU=LAB Users,$DomainDN",
    "OU=LAB Computers,$DomainDN",
    "OU=Workstations,OU=LAB Computers,$DomainDN",
    "OU=Servers,OU=LAB Computers,$DomainDN",
    "OU=LAB Groups,$DomainDN"
)

foreach ($OU in $OUs) {
    $ouName = ($OU -split ",")[0] -replace "OU=", ""
    $ouPath = ($OU -split ",", 2)[1]
    
    if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$OU'" -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name $ouName -Path $ouPath -ProtectedFromAccidentalDeletion $true
        Write-Host "  Created: $ouName" -ForegroundColor Gray
    }
}

# ============================================
# Create Security Groups
# ============================================
Write-Host "[2/3] Creating security groups..." -ForegroundColor Yellow

$Groups = @(
    @{ Name = "IT-Admins"; Path = "OU=LAB Groups,$DomainDN"; Description = "IT Administrators" },
    @{ Name = "Help-Desk"; Path = "OU=LAB Groups,$DomainDN"; Description = "Help Desk - Password Reset Delegation" },
    @{ Name = "HR-Staff"; Path = "OU=LAB Groups,$DomainDN"; Description = "Human Resources Staff" },
    @{ Name = "Finance-Staff"; Path = "OU=LAB Groups,$DomainDN"; Description = "Finance Department" }
)

foreach ($Group in $Groups) {
    if (-not (Get-ADGroup -Filter "Name -eq '$($Group.Name)'" -ErrorAction SilentlyContinue)) {
        New-ADGroup -Name $Group.Name -Path $Group.Path -GroupScope Global -GroupCategory Security -Description $Group.Description
        Write-Host "  Created: $($Group.Name)" -ForegroundColor Gray
    }
}

# ============================================
# Bulk User Creation (Example - expand with CSV import)
# ============================================
Write-Host "[3/3] Creating sample users..." -ForegroundColor Yellow

$DefaultPassword = ConvertTo-SecureString "Welcome123!" -AsPlainText -Force

$Users = @(
    @{ First = "Alice"; Last = "Admin"; Username = "a.admin"; OU = "OU=IT,OU=LAB Users,$DomainDN"; Groups = @("IT-Admins") },
    @{ First = "Bob"; Last = "HelpDesk"; Username = "b.helpdesk"; OU = "OU=Help Desk,OU=IT,OU=LAB Users,$DomainDN"; Groups = @("Help-Desk") },
    @{ First = "Carol"; Last = "HR"; Username = "c.hr"; OU = "OU=HR,OU=LAB Users,$DomainDN"; Groups = @("HR-Staff") },
    @{ First = "Dave"; Last = "Finance"; Username = "d.finance"; OU = "OU=Finance,OU=LAB Users,$DomainDN"; Groups = @("Finance-Staff") }
)

foreach ($User in $Users) {
    if (-not (Get-ADUser -Filter "SamAccountName -eq '$($User.Username)'" -ErrorAction SilentlyContinue)) {
        New-ADUser `
            -Name "$($User.First) $($User.Last)" `
            -GivenName $User.First `
            -Surname $User.Last `
            -SamAccountName $User.Username `
            -UserPrincipalName "$($User.Username)@lab.local" `
            -Path $User.OU `
            -AccountPassword $DefaultPassword `
            -ChangePasswordAtLogon $true `
            -Enabled $true
        
        foreach ($Group in $User.Groups) {
            Add-ADGroupMember -Identity $Group -Members $User.Username
        }
        Write-Host "  Created: $($User.Username)" -ForegroundColor Gray
    }
}

Write-Host "`n=== Phase 2 Complete ===" -ForegroundColor Green