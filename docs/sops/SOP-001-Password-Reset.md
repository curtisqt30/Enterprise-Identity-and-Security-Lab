# SOP-001: Standard User Password Reset

| Info | Detail |
| :--- | :--- |
| **Department** | IT Help Desk |
| **Last Updated** | 2026-01-08 |
| **Required Access** | `Help-Desk` Group Membership |
| **Scope** | Standard Staff (Finance, HR, Sales). **EXCLUDES IT-Admins.** |

## 1. Purpose
To provide a secure, consistent method for resetting forgotten passwords while maintaining audit trails and security compliance.

## 2. Identity Verification (CRITICAL)
**STOP:** Before resetting any password, you **must** verify the requestor's identity.
* **In-Person:** Verify Employee Badge.
* **Phone:** Verify Manager Name and Employee ID.
* *Note: If verification fails, deny the request and log a Security Incident.*



## 3. Procedure

### Phase 1: Preparation
1.  Log in to the management workstation (`CLIENT01`).
2.  Launch **Active Directory Users and Computers** (`dsa.msc`).
3.  Ensure **Advanced Features** is enabled (View -> Advanced Features).

### Phase 2: Execution
1.  Navigate to the user's Organizational Unit (e.g., `LAB Users > Finance`).
2.  **Security Check:** Verify the user is **NOT** in a privileged group (Domain Admins).
3.  Right-click the user object -> **Reset Password**.
4.  Enter the temporary password standard (e.g., `Welcome2026!`).
5.  **Mandatory Settings:**
    * ✅ Check: **User must change password at next logon**.
    * ✅ Check: **Unlock the user's account** (if locked).
6.  Click **OK**.

### Phase 3: Handoff
1.  Provide the temporary password to the user verbally or via secure SMS. **NEVER** email the password.
2.  Instruct the user to log in immediately to set their own private password.

## 4. Escalation Path
* **Error:** "Access is Denied"
    * **Cause:** You are likely trying to reset an Admin account or a user in a protected OU.
    * **Action:** Do not attempt to bypass. Escalate ticket to **Tier 2 / Security Team**.

## 5. Associated Policies
* Acceptable Use Policy (AUP)
* Password Complexity Policy (GPO-001)