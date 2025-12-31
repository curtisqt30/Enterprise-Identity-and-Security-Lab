# Enterprise Identity & Security Lab

A fully automated Windows Active Directory lab environment demonstrating enterprise identity management, security hardening, and SIEM monitoring using a DevSecOps approach.

## Purpose

This project showcases the ability to architect, deploy, and secure a corporate Windows domain environment — the foundational infrastructure found in most enterprise organizations. It demonstrates practical skills in:

- Infrastructure as Code (IaC) for repeatable deployments
- Windows Server administration and Active Directory
- Identity management with least privilege principles
- Security hardening through Group Policy
- Centralized security monitoring with SIEM

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Hyper-V Host                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   ┌─────────────┐    ┌─────────────┐    ┌─────────────┐        │
│   │    DC01     │    │  CLIENT01   │    │   WAZUH01   │        │
│   │ Win Server  │    │   Win 10    │    │   Ubuntu    │        │
│   │ 2022        │    │             │    │   22.04     │        │
│   │             │    │             │    │             │        │
│   │ • AD DS     │    │ • Domain    │    │ • Wazuh     │        │
│   │ • DNS       │◄───│   Joined    │───►│   Manager   │        │
│   │ • GPO       │    │ • RSAT      │    │ • Dashboard │        │
│   │ • Audit     │    │ • Agent     │    │ • Indexer   │        │
│   └─────────────┘    └─────────────┘    └─────────────┘        │
│         │                   │                  ▲                │
│         │                   │                  │                │
│         └───────────────────┴──────────────────┘                │
│                     Security Events                             │
└─────────────────────────────────────────────────────────────────┘
```

## Tool Stack

| Category | Technology |
|----------|------------|
| Hypervisor | Hyper-V |
| IaC | Vagrant |
| Domain Services | Windows Server 2022, Active Directory |
| Workstation | Windows 10 Enterprise |
| SIEM | Wazuh 4.9 |
| Scripting | PowerShell, Bash |
| Version Control | Git |

## Key Features

### Identity Management
- Organizational Unit hierarchy mirroring enterprise structure
- Role-based security groups (IT-Admins, Help-Desk, HR-Staff, Finance-Staff)
- Delegated administration with least privilege (Help Desk password reset only)

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
│   └── phase4-siem/            # Wazuh server and agents
├── tests/                      # Validation scripts
├── vms/                        # VM storage (gitignored)
└── Vagrantfile                 # Multi-provider VM definitions
```

## Quick Start

```powershell
# Clone and deploy
git clone https://github.com/yourusername/Enterprise-Identity-and-Security-Lab.git
cd Enterprise-Identity-and-Security-Lab

# Start infrastructure (Hyper-V)
vagrant up dc01 --provider=hyperv
vagrant up client01 --provider=hyperv
vagrant up wazuh01 --provider=hyperv
```

See [docs/setup-guides/](docs/setup-guides/) for detailed instructions.

## Skills Demonstrated

- **Systems Administration:** Windows Server, Active Directory, DNS, Group Policy
- **Security:** Least privilege access, audit logging, SIEM deployment, hardening
- **Automation:** Infrastructure as Code, PowerShell scripting, Vagrant
- **Networking:** Domain services, internal networks, agent communication
- **DevSecOps:** Version-controlled infrastructure, repeatable deployments

## Lessons Learned

1. **Hyper-V over VirtualBox** — Modern Windows security features (VBS, Credential Guard) conflict with VirtualBox. Hyper-V provides better stability for Windows guests.

2. **Least Privilege in Practice** — Delegating specific AD permissions (password reset) to Help Desk demonstrates real-world access control without granting full admin rights.

3. **Remote Administration** — Enterprise best practice is managing AD remotely via RSAT, not logging directly into Domain Controllers.

4. **SIEM Visibility** — Centralized logging transforms scattered Windows events into actionable security intelligence.

## Future Enhancements

- [ ] Sysmon deployment for enhanced endpoint telemetry
- [ ] Fine-grained password policies
- [ ] Certificate Services (AD CS)
- [ ] Azure AD Connect hybrid identity
- [ ] Automated attack simulation for detection testing