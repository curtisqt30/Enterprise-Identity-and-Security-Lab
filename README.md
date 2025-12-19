# The Enterprise Identity & Security Lab

## Project Purpose
To demonstrate the ability to architect, secure, and automate a corporate Windows Domain environment using a DevSecOps mindset.

##  The Four Goals
1. **Infrastructure as Code (IaC):** Repeatable deployment using Vagrant & VirtualBox.
2. **Infrastructure:** Windows Server 2022/25 DC & Windows 10/11 Client communication via DNS/DHCP.
3. **Identity Management:** Implementing Principle of Least Privilege, OUs, and Group-based access.
4. **Governance & Security (CySA+):** Hardening via Group Policy Objects (GPOs) and Audit Logging.

---

##  Lab Progress Tracker
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

## Tools Used
- **Hypervisor:** VirtualBox
- **IaC:** Vagrant
- **Scripting:** PowerShell
- **Documentation:** Git/GitHub
