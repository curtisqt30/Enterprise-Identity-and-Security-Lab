# Lab Completion Summary

## Environment Setup

- **Hypervisor:** Hyper-V
- **IaC Tool:** Vagrant with multi-provider Vagrantfile
- **Domain:** lab.local
- **Network:** Default Switch (Hyper-V NAT)

| VM | Hostname | IP | Role |
|----|----------|-----|------|
| DC01-Server2022 | DC01 | 172.28.209.217 | Domain Controller |
| CLIENT01-Win10 | CLIENT01 | 172.28.217.20 | Domain Workstation |

---

## Phase 1: Infrastructure

- [x] Created multi-provider Vagrantfile (Hyper-V + VirtualBox support)
- [x] Provisioned Windows Server 2022 VM (DC01)
- [x] Installed AD DS role and promoted to Domain Controller
- [x] Configured DNS on DC01
- [x] Provisioned Windows 10 VM (CLIENT01)
- [x] Joined CLIENT01 to lab.local domain

**Key Commands:**
```powershell
vagrant up dc01 --provider=hyperv
vagrant up client01 --provider=hyperv
```

---

## Phase 2: Identity & Automation

- [x] Created Organizational Unit (OU) structure:
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

- [x] Created Security Groups:
  - IT-Admins
  - Help-Desk
  - HR-Staff
  - Finance-Staff

- [x] Created sample users:
  | Username | OU | Group |
  |----------|-----|-------|
  | a.admin | IT | IT-Admins |
  | b.helpdesk | Help Desk | Help-Desk |
  | c.hr | HR | HR-Staff |
  | d.finance | Finance | Finance-Staff |

- [x] Configured Help Desk Delegation (password reset rights on LAB Users OU)

**Verification:**
- Active Directory Users and Computers (`dsa.msc`)
- View → Advanced Features → Security tab for delegation

---

## Phase 3: Hardening & Monitoring

- [x] Created and linked Group Policy Objects:

  | GPO | Linked To | Purpose |
  |-----|-----------|---------|
  | SEC - Password and Lockout Policy | Domain Root | Enforce strong passwords |
  | SEC - Disable USB Storage | LAB Computers OU | Block removable drives |
  | SEC - Screen Lock Timeout | LAB Computers OU | 15 min idle lock |
  | SEC - Advanced Audit Logging | Domain Root | Security event logging |

- [x] Applied policies to CLIENT01 via `gpupdate /force`

**Verification:**
- Group Policy Management Console (`gpmc.msc`)
- `Get-GPO -All | Select-Object DisplayName`

---

## Post-Setup Configuration

- [x] Installed RSAT on CLIENT01 for remote AD management:
  ```powershell
  Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
  ```

- [x] Added Domain Users to Remote Desktop Users on CLIENT01:
  ```powershell
  Add-LocalGroupMember -Group "Remote Desktop Users" -Member "LAB\Domain Users"
  ```

---

## Validation Tests Completed

- [x] Logged in as domain user (d.finance) on CLIENT01
- [x] Tested Help Desk delegation: b.helpdesk successfully reset d.finance password
- [x] Verified OU structure in AD Users and Computers
- [x] Verified GPOs in Group Policy Management Console

---

## Useful Commands

```powershell
# Vagrant management
vagrant up                    # Start VMs
vagrant suspend               # Pause VMs (saves state)
vagrant halt                  # Shutdown VMs
vagrant status                # Check VM state

# AD verification (run on DC01)
Get-ADDomain                  # Verify domain info
Get-ADOrganizationalUnit -Filter * | Select Name    # List OUs
Get-ADUser -Filter * | Select Name, SamAccountName  # List users
Get-ADGroup -Filter * | Select Name                 # List groups
Get-GPO -All | Select DisplayName                   # List GPOs

# Client management
gpupdate /force               # Refresh group policies
(Get-WmiObject Win32_ComputerSystem).Domain         # Check domain membership
```

---

## Lessons Learned

1. **Hyper-V vs VirtualBox:** Modern Windows security features (VBS, Credential Guard) conflict with VirtualBox. Hyper-V is the better choice for Windows-on-Windows virtualization and mirrors enterprise environments.

2. **Multi-provider Vagrantfile:** Supports both Hyper-V and VirtualBox, allowing flexibility across different machines.

3. **Remote Administration:** In enterprise environments, you don't log into Domain Controllers directly. Install RSAT on workstations and manage AD remotely.

4. **Principle of Least Privilege:** Help Desk delegation demonstrates granting only necessary permissions (password reset) without full admin access.