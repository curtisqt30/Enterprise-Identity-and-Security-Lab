# Script Reference

Quick reference for all PowerShell provisioning scripts in this lab.

---

## Phase 1: Infrastructure

Scripts that build the foundational Windows domain environment.

| Script | Purpose |
|--------|---------|
| `01-dc-setup.ps1` | Installs AD DS role, promotes server to Domain Controller for `lab.local`, configures DNS to self, auto-reboots |
| `02-client-setup.ps1` | Points client DNS to DC (192.168.56.10), tests connectivity, joins domain, auto-reboots |

**Run order:** DC01 must complete promotion and reboot before starting CLIENT01.

---

## Phase 2: Identity & Automation

Scripts that establish the organizational structure and implement least privilege access.

| Script | Purpose |
|--------|---------|
| `01-create-ou-users.ps1` | Creates OU hierarchy (LAB Users, LAB Computers, LAB Groups), security groups (IT-Admins, Help-Desk, HR-Staff, Finance-Staff), and sample users with group membership |
| `02-helpdesk-delegation.ps1` | Delegates password reset rights to Help-Desk group on LAB Users OU — demonstrates Principle of Least Privilege |

**OU Structure Created:**
```
lab.local
├── LAB Users
│   ├── IT
│   │   └── Help Desk
│   ├── HR
│   └── Finance
├── LAB Computers
│   ├── Workstations
│   └── Servers
└── LAB Groups
```

**Sample Users:**
| Username | OU | Group Membership |
|----------|-----|------------------|
| a.admin | IT | IT-Admins |
| b.helpdesk | Help Desk | Help-Desk |
| c.hr | HR | HR-Staff |
| d.finance | Finance | Finance-Staff |

Default password: `Welcome123!` (forced change at first logon)

---

## Phase 3: Hardening & Monitoring

Scripts that implement CySA+ aligned security controls via Group Policy.

| Script | Purpose |
|--------|---------|
| `01-security-gpos.ps1` | Creates and links GPOs for security hardening and audit logging |

**GPOs Created:**

| GPO Name | Linked To | Function |
|----------|-----------|----------|
| SEC - Password and Lockout Policy | Domain Root | Enforces strong passwords, account lockout after failed attempts |
| SEC - Disable USB Storage | LAB Computers OU | Blocks removable storage devices |
| SEC - Screen Lock Timeout | LAB Computers OU | Forces screen lock after 15 min inactivity, requires password on resume |
| SEC - Advanced Audit Logging | Domain Root | Enables detailed security event logging for SOC analysis |

**Note:** Password policies require manual configuration in GPMC (Default Domain Policy) or via Fine-Grained Password Policies.

---

## Execution Summary

```powershell
# Phase 1 - Run via Vagrant provisioning
vagrant up dc01      # Wait for reboot
vagrant up client01  # Joins domain automatically

# Phase 2 - Run manually on DC01 after domain is ready
.\scripts\phase2-identity\01-create-ou-users.ps1
.\scripts\phase2-identity\02-helpdesk-delegation.ps1

# Phase 3 - Run manually on DC01
.\scripts\phase3-hardening\01-security-gpos.ps1
gpupdate /force      # Apply to DC
# Run gpupdate /force on CLIENT01 as well
```