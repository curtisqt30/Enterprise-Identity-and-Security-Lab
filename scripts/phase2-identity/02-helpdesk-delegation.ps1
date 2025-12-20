#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Delegates password reset rights to Help Desk group.
.DESCRIPTION
    Phase 2: Implements Principle of Least Privilege by delegating
    specific permissions to Help Desk for user password management.
.NOTES
    Run on Domain Controller after OU/user creation.
#>

Import-Module ActiveDirectory

$DomainDN = "DC=lab,DC=local"
$HelpDeskGroup = "Help-Desk"
$TargetOU = "OU=LAB Users,$DomainDN"

Write-Host "=== Help Desk Delegation of Control ===" -ForegroundColor Cyan

# Get the Help Desk group SID
$HelpDeskSID = (Get-ADGroup -Identity $HelpDeskGroup).SID

# Get the OU
$OU = Get-ADOrganizationalUnit -Identity $TargetOU

# Define the ACL
$ACL = Get-Acl -Path "AD:\$TargetOU"

# GUID for "Reset Password" extended right
$ResetPasswordGUID = [GUID]"00299570-246d-11d0-a768-00aa006e0529"

# GUID for "User" object class
$UserGUID = [GUID]"bf967aba-0de6-11d0-a285-00aa003049e2"

# Create the ACE for password reset delegation
$ACE = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $HelpDeskSID,
    "ExtendedRight",
    "Allow",
    $ResetPasswordGUID,
    "Descendents",
    $UserGUID
)

# Add the ACE to the ACL
$ACL.AddAccessRule($ACE)

# Apply the ACL
Set-Acl -Path "AD:\$TargetOU" -AclObject $ACL

Write-Host "Delegated password reset rights to $HelpDeskGroup on $TargetOU" -ForegroundColor Green
Write-Host "`nHelp Desk users can now reset passwords for users in LAB Users OU." -ForegroundColor Gray