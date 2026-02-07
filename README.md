# Enterprise Infrastructure & Security Lab

A unified repository documenting my home lab projects, focusing on **Windows Identity Management** and **Cisco Network Engineering**.

## Project Goals
1.  **SysAdmin & Security:** Simulate a real-world corporate IT environment with Active Directory, SIEM monitoring, and Help Desk workflows.
2.  **Network Engineering:** Design and configure enterprise network topologies using GNS3.

---

## Lab A: Identity & Security (Windows/Linux)
A "DevSecOps" approach to building a secure Windows domain, complete with monitoring and support tools.

### Core Stack
* **Hypervisor:** Hyper-V
* **Identity:** Windows Server 2022 AD DS
* **Security (SIEM):** Wazuh (Forensics & Log Analysis)
* **Operations:** Odoo (Help Desk Ticketing) & BookStack (SOP Documentation)

### Key Scenarios Implemented
* **Lifecycle Management:** Automated user provisioning and "Department" based group governance.
* **Incident Response Workflow:**
    * *Scenario:* VIP User (James Smith) locked out.
    * *Workflow:* Detect in Wazuh $\rightarrow$ Ticket in Odoo $\rightarrow$ Verify User $\rightarrow$ Fix via RSAT $\rightarrow$ Log in BookStack.
* **Hardening:** Tiered Admin accounts (Tier-0), Least Privilege delegation, and Attack Surface Reduction rules.

---

## Lab B: Network Infrastructure (GNS3)
Standalone network simulations focusing on routing, switching, and segmentation.

### Core Stack
* **Platform:** GNS3
* **Hardware Emulation:** Cisco IOS / IOL
* **Focus:** VLANs, STP, OSPF, and Access Control Lists (ACLs).

---

## Technology Stack

| Category | Tools |
| :--- | :--- |
| **Virtualization** | Hyper-V, GNS3, Docker |
| **Operating Systems** | Windows Server 2022, Windows 10, Ubuntu 22.04 |
| **Security & Monitor** | Wazuh SIEM, Sysmon |
| **Business Apps** | Odoo ERP, BookStack |
| **Automation** | PowerShell, Bash, Vagrant |

## Skills Demonstrated
* **Directory Services:** Managing AD Objects, GPO, and DNS.
* **Blue Team Ops:** Correlating logs in Wazuh to validate security incidents.
* **ITSM Process:** Integrating technical fixes with business logic (Ticketing/SOPs).
* **Infrastructure as Code:** Deploying reproducible labs via Vagrant and scripts.
