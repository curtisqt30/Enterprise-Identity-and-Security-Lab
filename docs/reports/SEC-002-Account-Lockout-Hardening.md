# Security Remediation Report: SEC-001

| Field | Detail |
| :--- | :--- |
| **Type** | Security Misconfiguration / Hardening |
| **Severity** | **High** |
| **Date Detected** | 2026-01-09 |
| **Remediation Date** | 2026-01-09 |
| **Author** | Alice Admin |

## Executive Summary
While investigating a user lockout incident (TKT-002), a critical misconfiguration was identified in the domain's default password policy. The Account Lockout Threshold was set to 0, effectively disabling the lockout mechanism. Additionally, the Help Desk lacked the necessary visibility and permissions to resolve lockouts securely. Both the policy and the operational workflow have been remediated.

## Technical Findings
* **Policy Vulnerability:** The domain-wide Account Lockout Threshold was disabled (`0`), meaning users could attempt an infinite number of incorrect passwords without the account being locked.
* **Operational Gap**: Help Desk staff (`b.helpdesk`) lacked `Read/Write` permissions for the `lockoutTime` and `pwdLastSet` attributes, leading to unauthorized escalation requests to Domain Admins.
* **Visibility Gap** The SIEM (Wazuh) lacked a restricted access model, preventing the Help Desk from investigating lockout sources without using administrative credentials.

## Remediation Actions (The "Change")
1.  **GPO Modification (Identity Protection)**
  - **Threshold:** Updated the Account Lockout Policy to 5 invalid attempts.
  - **Duration:** Set Lockout Duratoin and Observation Window to 15 minutes.
2.  **Least Privilege Delegation (Access Control)**
  - **AD Delegation**: Granted `Help-Desk` group specific rights to the `lockoutTime` and `pwdLastSet` attributes on the HR OU.
  - **Impact:** Bob Helpdesk can now unlock accounts and force password changes without requiring full Domain Admin rights.
3.  **SIEM RBAC Integration (Observability)**
  - **User Provisioning:** Created a restricted SIEM user (`b.helpdesk`).
  - **RBAC Mapping:** Configured a custom "Read-Only" role in the Wazuh indexer to resolve "Pattern Handler" errors, allowing the Help Desk to view Event ID 4740 (Lockouts) while preventing configuration changes.
 
## Verification
* **Policy:** Confirmed via Get-ADDefaultDomainPasswordPolicy.
* **Visibility:** Logged in as b.helpdesk and verified Event ID 4740 visibility in the Wazuh "Threat Hunting" dashboard.
* **Functionality:** Verified Bob Helpdesk could successfully toggle the "User must change password" flag in ADUC.

## Status
✅ **remediated**