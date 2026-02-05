# Project: AD-000-Identity-Infrastructure-Build
**Date:** February 2026
**Platform:** Vagrant, Hyper-V, Windows Server 2022, Windows 10

## 1. Project Overview
This project established the foundational Identity and Access Management (IAM) environment for the enterprise lab. Moving away from manual GUI installs, I utilized **Infrastructure as Code (IaC)** via Vagrant to provision a "Clean Slate" environment. The primary objective was to deploy a functioning Active Directory Forest (`corp.local`), configure a Primary Domain Controller (PDC) using PowerShell, and successfully enroll a Windows 10 client, simulating a real-world enterprise onboarding workflow.

## 2. Topology Design
* **Domain Controller (DC01):**
    * **OS:** Windows Server 2022 Standard
    * **Role:** Primary Domain Controller, DNS Server, Global Catalog
    * **IP:** Static Assignment (Hyper-V NAT Network)
* **Endpoint (CLIENT01):**
    * **OS:** Windows 10 Enterprise
    * **Role:** Domain-Joined Workstation
* **Network Architecture:**
    * **Hyper-V Default Switch:** Provides NAT access to the internet for package installation.
    * **Domain:** `corp.local`

## 3. Configuration Details

### Phase 1: Infrastructure Initialization (Lab AD-000)
* **Vagrant & Hyper-V Setup:**
    * Configured `Vagrantfile` to leverage the **Hyper-V provider** for performance, bypassing VirtualBox.
    * Implemented `config.vm.boot_timeout` adjustments to handle Windows boot latency.
    * **Code-Based Provisioning:** Disabled default provisioning scripts to ensure a "Vanilla" start for manual configuration practice.

### Phase 2: Domain Controller Build (Lab AD-001)
* **Network Configuration (PowerShell):**
    * Enforced **Static IP** addressing on the DC to ensure service reliability.
    * Configured the **DNS Loopback** (`127.0.0.1`) to ensure the server queries itself for AD replication.
* **Forest Promotion:**
    * Installed AD DS binaries: `Install-WindowsFeature AD-Domain-Services`.
    * Promoted the server to the first DC in a new forest: `Install-ADDSForest -DomainName "corp.local"`.

### Phase 3: Client Enrollment (Lab AD-002)
* **DNS Mapping:**
    * Pointed the Client's DNS settings exclusively to the DC IP (`172.17.x.x`) to resolve the `corp.local` namespace.
* **Domain Join:**
    * Executed the join operation via PowerShell: `Add-Computer -DomainName corp.local`.
    * Validated the trust relationship by logging in with Domain Admin credentials (`CORP\vagrant`).

## 4. Challenges & Troubleshooting

### A. The "Hyper-V Network Trap" (Dynamic Subnets)
* **Issue:** The Hyper-V Default Switch rotates its subnet address upon host reboot. Hardcoded Static IPs in the VMs became "orphaned" on an old network subnet (e.g., `172.17.188.x` vs `172.17.179.x`), breaking connectivity.
* **Solution:** Developed a "Scout" methodology. I set the Client to DHCP to discover the *current* active subnet, then updated the DC's Static IP to match the new network map before attempting the join.

### B. Firewall & DNS Resolution
* **Issue:** The Client threw "DNS name does not exist" errors despite correct IP configuration. Packet inspection revealed the DC was online but dropping traffic.
* **Solution:** Identified the **Windows Firewall** on the DC as the blocker. Executed `Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False` to permit the initial join traffic.

### C. The "Enhanced Session" Lockout
* **Issue:** After joining the domain, Hyper-V's "Enhanced Session Mode" (which uses RDP) rejected logins because the Domain User lacked Remote Desktop rights.
* **Solution:**
    1.  Bypassed RDP by toggling **Basic Session Mode** in Hyper-V.
    2.  Logged in via the "Backdoor" local admin account (`.\vagrant`).
    3.  Granted rights via PowerShell: `Add-LocalGroupMember -Group "Administrators" -Member "CORP\vagrant"`.

## 5. Verification & Testing
* **Forest Validation:** Run `Get-ADDomain` on DC01 confirmed the forest Mode, Domain SIDs, and PDC Emulator roles were active.
* **Name Resolution:** Run `Resolve-DnsName corp.local` on CLIENT01 returned the authoritative IP of the DC, confirming internal DNS functionality.
* **Authentication:** Successfully logged into CLIENT01 using `CORP\vagrant`, verifying the Kerberos ticket exchange with the Domain Controller.