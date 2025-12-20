# The Enterprise Identity & Security Lab

## Project Purpose
To demonstrate the ability to architect, secure, and automate a corporate Windows Domain environment using a DevSecOps mindset.

## The Four Goals
1. **Infrastructure as Code (IaC):** Repeatable deployment using Vagrant & VirtualBox.
2. **Infrastructure:** Windows Server 2022/25 DC & Windows 10/11 Client communication via DNS/DHCP.
3. **Identity Management:** Implementing Principle of Least Privilege, OUs, and Group-based access.
4. **Governance & Security (CySA+):** Hardening via Group Policy Objects (GPOs) and Audit Logging.

---

## Lab Progress Tracker
- [ ] **Phase 1: Infrastructure**
    - [ ] Create Vagrantfile for Server & Client
    - [ ] Configure Internal Networking & Static IPs
    - [ ] Promote Server to Domain Controller (AD DS)
- [ ] **Phase 2: Identity & Automation**
    - [ ] Script bulk user creation via PowerShell
    - [ ] Establish Organizational Unit (OU) hierarchy
    - [ ] Configure Help Desk Delegation of Control
- [ ] **Phase 3: Hardening & Monitoring**
    - [ ] Implement Password & Account Lockout GPOs
    - [ ] Disable USB Storage & Configure Screen Lockouts
    - [ ] Enable Advanced Audit Policy Logging for SOC Analysis

---

## Prerequisites

- [Vagrant](https://www.vagrantup.com/downloads)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- ~8GB RAM available (4GB DC + 2GB Client + Host)
- ~60GB disk space for Windows VMs

---

## Quick Start

```powershell
# Clone the repository
git clone <repo-url>
cd <repo-name>

# Start the Domain Controller first
vagrant up dc01

# After DC is ready and rebooted, start the client
vagrant up client01
```

---

## Directory Structure

```
├── configs/                           # Configuration templates
├── docs/                              # Documentation
│   ├── architecture.md                # Network topology & design
│   ├── setup-guides/                  # Step-by-step walkthroughs
│   └── runbooks/                      # Operational procedures
├── scripts/
│   ├── phase1-infrastructure/         # DC & Client setup
│   │   ├── 01-dc-setup.ps1
│   │   └── 02-client-setup.ps1
│   ├── phase2-identity/               # AD users, OUs, delegation
│   │   ├── 01-create-ou-users.ps1
│   │   └── 02-helpdesk-delegation.ps1
│   └── phase3-hardening/              # GPOs & audit policies
│       └── 01-security-gpos.ps1
├── tests/                             # Pester tests & validation scripts
├── vms/                               # VM storage (gitignored)
└── Vagrantfile                        # Multi-VM configuration
```

---

## Lab Network

| VM        | Hostname  | IP Address     | Role              |
|-----------|-----------|----------------|-------------------|
| DC01      | DC01      | 192.168.56.10  | Domain Controller |
| CLIENT01  | CLIENT01  | 192.168.56.100 | Domain Workstation|

**Domain:** `lab.local`  
**Network:** `LabNet` (VirtualBox Internal Network)

---

## Tools Used
- **Hypervisor:** VirtualBox
- **IaC:** Vagrant
- **Scripting:** PowerShell
- **Documentation:** Git/GitHub