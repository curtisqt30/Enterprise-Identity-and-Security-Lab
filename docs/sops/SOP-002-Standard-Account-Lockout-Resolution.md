# SOP-001: Standard User Password Reset

| Info | Detail |
| :--- | :--- |
| **Department** | IT Help Desk |
| **Last Updated** | 2026-01-09 |
| **Required Access** | `Help-Desk` Group Membership |
| **Scope** | Standard Staff (Finance, HR, Sales). **EXCLUDES IT-Admins.** |

## 1. Purpose
To safely restore access to locked accounts while investigating the source of the lockout to prevent immediate re-occurrence.

## 2. Identity Verification (CRITICAL)
**STOP:** Before resetting any password, you **must** verify the requestor's identity.
* **In-Person:** Verify Employee Badge.
* **Phone:** Verify Manager Name and Employee ID.
* *Note: If verification fails, deny the request and log a Security Incident.*

## 3. Procedure

### Phase 1: Investigation (SIEM Check)
Before unlocking, identify why the lockout happened to ensure it isn't an active attack.
1.  Open **Wazuh Dashboard**
2.  Filter for **Event ID 4740** (A user account was locked out) for the specific username.
3.  **Note the Source** Check the "Source Network Address" or "Caller Computer Name."
  - **Internal Device:** Likely a forgotten password on a phone or tablet.
  - **Unknown/External:** Escalate to Security Team (Alice Admin) immediately.

### Phase 2: Execution (RSAT)
1.  Log in to `CLIENT01` and launch Active Directory Users and Computers (`dsa.msc`).
2.  Navigate to the user's OU (e.g., `HR`).
3.  Right-click the user -> **Properties** -> **Account** tab.
4.  **Unlock:** Check the box **"Unlock Account. This account is currently locked out...**.
5.  **Security Reset:** To ensure the user has a fresh start, right-click -> **Reset Password**.
6.  **Mandatory Setting:** Check **"User must change password at next logon"**.
  - *Note: if this is grayed out, notify Alice Admin to verify `pwdLastSet` delegation.*

### Phase 3: Handoff
1.  Instruct the user to log in to their primary workstation.
2.  Refresh the user's properties in ADUC after 1 minute to ensure the account has not automatically locked again (which would indicate a hidden mobile device still using the old password).

## 4. Escalation Path
* **Recurring Lockouts:** If the account locks again within 5 minutes of being cleared, escalate to Tier 2 to identify and "kill" persistent sessions on mobile devices or cached credentials.
* **Privileged Accounts:** If the requestor is an IT-Admin, do not attempt to unlock. These accounts must be handled by another Tier-0 Administrator.

## 5. Associated Policies
* **Account Lockout Policy (GPO):** 5 attempts / 15-minute duration.
* **SEC-002:** Account Lockout Hardening Report.