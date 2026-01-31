# Enterprise Identity & Security Lab

A fully automated Windows Active Directory lab environment demonstrating enterprise identity management, security hardening, and SIEM monitoring using a DevSecOps approach.

## Purpose

This project showcases the ability to architect, deploy, and secure a corporate Windows domain environment — the foundational infrastructure found in most enterprise organizations. It demonstrates practical skills in:

- Infrastructure as Code (IaC) for repeatable deployments
- Windows Server administration and Active Directory
- Identity management with least privilege principles
- Security hardening through Group Policy
- Centralized security monitoring with SIEM

## Operational Portfolio (Live Scenarios)

Beyond deployment, this lab serves as a live environment for simulating Help Desk and Security Operations.

### 1. Help Desk Operations (Ticket & SOP)
- **Scenario:** Simulated a "User Locked Out" incident for a Finance employee.
- **Resolution:** Performed remote resolution via RSAT on a secure management workstation (`CLIENT01`) rather than accessing the Domain Controller directly.
- **Documentation:**
  - [TKT-001: Password Reset Ticket](./docs/tickets/TKT-001-Finance-Password-Reset.md) (Incident Lifecycle)
  - [SOP-001: Standard Password Reset Procedure](./docs/sops/SOP-001-Password-Reset.md) (Standard Operating Procedure)

### 2. Security Audit & Remediation
- **Finding:** During a privilege audit, discovered a Critical Misconfiguration allowing Help Desk users to reset Domain Admin passwords (vertical privilege escalation).
- **Remediation:** Re-architected OU structure to segregate Tier-0 (Admin) accounts into a protected container, breaking the inheritance model.
- **Validation:** Verified "Access Denied" on Admin objects using Active Directory "Effective Access" auditing.
- **Documentation:**
  - [SEC-001: Privilege Escalation Remediation Report](./docs/reports/SEC-001-Privilege-Escalation-Fix.md)

### 3. Account Lockout Hardening & SIEM RBAC
- **Scenario:** A routine lockout incident (Carol HR) revealed a disabled domain lockout policy and a lack of Help Desk visibility in the SIEM.
- **Remediation:** Hardened the domain's **Account Lockout Policy** via GPO (5-attempt threshold).
  - Implemented **Least Privilege** by delegating `lockoutTime` and `pwdLastSet` attributes to the Help Desk group
  - Developed a **Read-Only RBAC model** in Wazuh, resolving "Pattern Handler" errors to grant the Help Desk secure visibility into security logs.
- **Documentation:**
  - [SEC-002: Account Lockout Report](./docs/reports/SEC-002-Account-Lockout-Hardening.md)
  - [SOP-002: Standard Account Lockout Resolution](./docs/reports/SOP-002-Standard-Account-Lockout-Resolution.md)

### 4. Departmental Data Isolation (RBAC & ABE)
- **Scenario:** Required strict confidentiality between HR, Finance, and the new Sales department.
- **Resolution:** Deployed **Access-Based Enumeration (ABE)** on file shares so users only see folders they have permission to access.
- **Validation:** - Validated that `HR-Staff` cannot view `Finance` folders.
  - Confirmed `Help-Desk` has no read access to sensitive departmental files (Zero Trust).
- **Automation:** Implemented an **Identity Governance script** to automatically add/remove users from groups based on their "Department" attribute.

### 5. Enterprise Services & Knowledge Management
- **Scenario:** The IT department required a centralized "Source of Truth" for documentation and a realistic business application to generate network traffic for testing.
- **Resolution:** Deployed a Services Node (`services01`) using Docker Compose to host internal tools.
  - **ERP System (Odoo):** Deokiyed an open-source ERP to simulate "Finance" and "Inventory" workflows, creating a realistic applicatino surface for the Help Desk to support.
  - **Knowledge Base (BookStack):** Self-hosted a wiki platform to centralize SOPs and Incident Reports, migrating away from static Markdown files to a searchable tagged database.
- **Validation:**
  - Verified application uptime and connectivity from `CLIENT01`.
  - Documented the entire lab build process within the self-hosted BookStack instance.
- **Automation:** Implemented an **Identity Governance script** to automatically add/remove users from groups based on their "Department" attribute.

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          Hyper-V Host                                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐  │
│   │    DC01     │    │  CLIENT01   │    │   WAZUH01   │    │ SERVICES01  │  │
│   │ Win Server  │    │   Win 10    │    │   Ubuntu    │    │   Ubuntu    │  │
│   │ 2022        │    │             │    │   22.04     │    │   22.04     │  │
│   │             │    │             │    │             │    │             │  │
│   │ • AD DS     │    │ • Domain    │    │ • Wazuh     │    │ • Docker    │  │
│   │ • DNS       │◄───│   Joined    │───►│   Manager   │    │ • Odoo ERP  │  │
│   │ • GPO       │    │ • RSAT      │    │ • Dashboard │    │ • BookStack │  │
│   │ • Audit     │    │ • Agent     │    │ • Indexer   │    │   (KB)      │  │
│   └─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘  │
│         │                   │                  ▲                  ▲             │
│         │                   │                  │                  │             │
│         └───────────────────┼──────────────────┴──────────────────┘             │
│                             │                                                   │
│                     ┌───────▼───────┐                                           │
│                     │    EVE-NG     │                                           │
│                     │  Net Emul.    │                                           │
│                     │ 172.26.11.15  │                                           │
│                     │               │                                           │
│                     │ • Cisco IOS   │                                           │
│                     │ • VLANs/ACLs  │                                           │
│                     │ • Switching   │                                           │
│                     └───────────────┘                                           │
└─────────────────────────────────────────────────────────────────────────────┘
```
### Network Infrastructure
To move beyond a flat network topology, EVE-NG Community Edition has been deployed as a nested hypervisor appliance. This allows for the emulation of enterprise-grade switching and routing hardware alongside the Windows environment.
- **Host:** EVE-NG Community (Ubuntu 20.04 base)
- **Management IP:** `172.26.11.15`
- **Role:**
  - Hosting Cisco IOS/IOL images for switching logic.
  - Enforcing VLAN segmentation between HR, Finance, and IT resources.
  - Acting as the network backbone for the Windows AD environment. 

## Tool Stack

| Category | Technology |
|----------|------------|
| Hypervisor | Hyper-V |
| IaC | Vagrant |
| Domain Services | Windows Server 2022, Active Directory |
| Workstation | Windows 10 Enterprise |
| SIEM | Wazuh 4.9 |
| Network Emulation | EVE-NG Community (Bare Metal Kernel 5.17.8) |
| Scripting | PowerShell, Bash |
| Version Control | Git |
| Containerization | Docker, Docker Compose |
| Business Apps | Odoo ERP |
| Knowledge Management | BookStack |
| Databases | PostgreSQL, MariaDB (Dockerized) | 

## Key Features

### Identity Management
- Organizational Unit hierarchy mirroring enterprise structure
- Role-based security groups (IT-Admins, Help-Desk, HR-Staff, Finance-Staff, Sales-Staff)
- Delegated administration with least privilege (Help Desk password reset only)
- **Identity Governance:** Automated group membership reconciliation based on user attributes.

### Security Hardening (GPO)
- Password complexity and account lockout policies
- USB storage device restrictions
- Automated screen lock timeout
- Advanced audit logging for security events

### SIEM Integration
- Centralized log collection from all Windows endpoints
- Real-time security event monitoring
- Wazuh agents deployed to DC and workstation

## Project Structure

```
├── configs/                    # Configuration templates
├── docs/                       # Documentation
│   ├── script-reference.md     # Script documentation
│   └── setup-guides/           # Detailed setup guides
├── scripts/
│   ├── phase1-infrastructure/  # DC promotion, domain join
│   ├── phase2-identity/        # OUs, users, delegation
│   ├── phase3-hardening/       # GPO deployment
│   ├── phase4-siem/            # Wazuh server and agents
│   ├── phase5-network/         # EVE-NG topology and device configs
│   ├── phase6-services/        # BookStack knowledge base and Odoo ERP and Docker
├── tests/                      # Validation scripts
├── vms/                        # VM storage (gitignored)
└── Vagrantfile                 # Multi-provider VM definitions
```

## Skills Demonstrated

- **Systems Administration:** Windows Server, Active Directory, DNS, Group Policy
- **Security:** Least privilege access, audit logging, SIEM deployment, hardening
- **Automation:** Infrastructure as Code, PowerShell scripting, Vagrant
- **Operations:** Ticket management, SOP creation, and remote administration (RSAT)
- **Networking:** Domain services, internal networks, agent communication
- **DevSecOps:** Version-controlled infrastructure, repeatable deployments
- **SIEM Role-Based Access Control (RBAC):** Designing custom indexer roles and tenant mappings to provide secure, restricted visibility.
- **Granular AD Attribute Delegation:** Mastering the "Delegation of Control" wizard to grant specific rights (pwdLastSet) beyond simple password resets.
- **Application Lifecycle Management:** Deploying and maintaining containerized web applications (Odoo, BookStack) using Docker Compose and persistent volumes.

## Lessons Learned

1. **Hyper-V over VirtualBox** — Modern Windows security features (VBS, Credential Guard) conflict with VirtualBox. Hyper-V provides better stability for Windows guests.

2. **Least Privilege in Practice** — Delegating specific AD permissions (password reset) to Help Desk demonstrates real-world access control without granting full admin rights.

3. **Remote Administration** — Enterprise best practice is managing AD remotely via RSAT, not logging directly into Domain Controllers.

4. **SIEM Visibility** — Centralized logging transforms scattered Windows events into actionable security intelligence.

5. **Governance & Privilege Creep** — Learned that as a system evolves, permissions must be managed at the group level and documented thoroughly to prevent "creeping" administrative rights over time.

## Future Enhancements

- [ ] Sysmon deployment for enhanced endpoint telemetry
- [ ] Fine-grained password policies
- [ ] Certificate Services (AD CS)
- [ ] Azure AD Connect hybrid identity
- [ ] Automated attack simulation for detection testing
- [ ] Network Segmentation: Import Windows VMs into EVE-NG to simulate realistic VLAN segmentation (User, Server, DMZ).- [ ] Firewall Enforcement: Deploy a virtual firewall (pfsense/FortiGate) inside EVE-NG to inspect traffic between DC01 and endpoints.
- [ ] Sysmon deployment: Enhanced endpoint telemetry.
- [ ] Fine-grained password policies: FGPP implementation.
- [ ] Certificate Services: Deploy AD CS for internal PKI.