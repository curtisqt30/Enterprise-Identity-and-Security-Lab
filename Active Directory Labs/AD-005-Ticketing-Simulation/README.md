# Lab Report: AD-005 - IT Helpdesk Ticketing Simulation
**Date:** February 2026
**Platform:** Windows Server 2022, RSAT (Windows 10), Odoo

### 1. Scenario Overview
* **User:** James Smith (VIP User / Finance Dept)
* **Issue:** User reported inability to log in to their workstation.
* **Environment:**
    * **Identity Provider:** Windows Server 2019 Active Directory (`CORP.LOCAL`)
    * **ERP/Ticketing:** Odoo v16 (Project/Helpdesk Module)
    * **Workstation:** Windows 10 Enterprise
    * **Security Tool:** Wazuh SIEM (Monitoring Login Failures)

### 2. Issue Simulation & Verification
The "Account Lockout" policy was triggered on the Domain Controller to replicate a security event where a user attempts too many incorrect passwords.

* **Evidence:** The user attempted to authenticate, resulting in a specific security error message confirming the account status in Active Directory.

> **Exhibit A: User Lockout Message**
>
> ![User Locked Out Screen](./lockout.png)
> 
>*Figure 1: Workstation error message explicitly stating "The referenced account is currently locked out."*

### 3. Incident Management (Ticketing)
Upon verification of the user's identity, a support ticket was generated in the central ERP system (Odoo) to track the incident lifecycle.

* **Workflow Configured:**
    * **New Ticket:** Incoming requests.
    * **In Progress:** Active troubleshooting.
    * **Resolved:** Verified fixes.

> **Exhibit B: Helpdesk Pipeline**
> ![Odoo Kanban Board](./kanban.png)
> *Figure 2: The IT Helpdesk Kanban board configured with standard support stages.*

* **Ticket Details:**
    * **Subject:** `User Locked Out - James Smith`
    * **Priority:** High (Work Stoppage)
    * **Assignee:** Mitchell Admin (IT Support)

> **Exhibit C: Ticket Documentation**
> ![Ticket Details](./ticket.png)
> *Figure 3: The active ticket record containing the user's report and triage details.*

### 4. Resolution & Closure
1.  **Administrative Action:** Accessed **Active Directory Users and Computers (ADUC)** on the Domain Controller.
2.  **Fix:** Located the `James.Smith` object $\rightarrow$ **Account Tab** $\rightarrow$ Checked **"Unlock Account."**
3.  **Verification:** User successfully logged in to the workstation.
4.  **Documentation:** Ticket `User Locked Out` was updated with resolution notes and moved to the **Resolved** stage.

### 5. Conclusion
This lab demonstrates the integration between **Technical Execution** (AD Administration) and **Business Process** (ERP Ticketing). The workflow mimics real-world SLA requirements where every administrative action must be logged and tracked for audit purposes.