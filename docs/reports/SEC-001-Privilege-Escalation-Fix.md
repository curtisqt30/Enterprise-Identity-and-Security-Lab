# Security Remediation Report: SEC-001

| Field | Detail |
| :--- | :--- |
| **Type** | Security Vulnerability / Misconfiguration |
| **Severity** | **Critical** (Potential Domain Compromise) |
| **Date Detected** | 2026-01-08 |
| **Remediation Date** | 2026-01-08 |
| **Author** | Curtis |

## Executive Summary
During a routine permission audit of the Active Directory environment, a critical misconfiguration was identified. Support staff members (Help Desk) possessed effective permissions to reset the passwords of Domain Administrator accounts. This created a vertical privilege escalation path, allowing a compromised Help Desk account to seize control of the domain.

## Technical Findings
* **Vulnerability:** The `Help-Desk` group had "Reset Password" rights inherited on the `LAB Users` container.
* **Impact:** Administrative accounts (e.g., `Alice Admin`) residing within the `LAB Users` hierarchy inherited these permissions.
* **Evidence:** "Effective Access" tab confirmed `b.helpdesk` had `Reset Password` = Allow on `Alice Admin`.

## Remediation Actions (The "Change")
1.  **Architecture Change:** Created a protected Organizational Unit (OU) named `IT-Admins` at the domain root.
2.  **Access Control:** This new OU does **not** inherit the delegated permissions assigned to standard user OUs.
3.  **Migration:** Moved all Tier-0 (Domain Admin) accounts from `LAB Users` to `IT-Admins`.

## Verification
* **Method:** Re-ran "Effective Access" audit on `Alice Admin` (now in `IT-Admins`).
* **Result:** `Reset Password` permission for `b.helpdesk` is now explicitly **DENIED** (Red X).
* **Result:** `Change Password` remains allowed (standard behavior), but poses no risk without knowledge of current credentials.

## Status
✅ **remediated**