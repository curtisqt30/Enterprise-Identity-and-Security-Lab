# Ticket #002: HR Account Lockout & Help Desk Permission Fix

| Field | Detail |
| :--- | :--- |
| **Status** | Closed |
| **Date Opened** | 2026-01-09 |
| **Requestor** | Carol HR (HR) |
| **Priority** | High |
| **Technician** | Alice Admin (Escalated from Bob Helpdesk) |

## Issue Description
User `c.hr` reported an account lockout. Bob Helpdesk was unable to resolve the issue because the "Unlock account" box was grayed out, and he was also unable to tick the "User must change password at next logon" box.

## Troubleshooting Steps
1.  **GPO Check:** Confirmed `LockoutThreshold` was `0`, preventing a formal "Locked" state.
2.  **Permission Audit:** Discovered the `Help-Desk` group lacked `Write lockoutTime` and `Write pwdLastSet` permissions on the HR OU.
3.  **Policy Hardening:** Alice Admin updated the Default Domain Policy to a $15/15/5$ baseline.

## Resolution
**Method:** Delegation of Control & RSAT

1.  **Delegated Permissions:** Granted `Help-Desk` group the rights to read/write `lockoutTime` and `pwdLastSet`.
2.  **Verified Fix:** Bob Helpdesk successfully logged back in, unlocked Carol's account, and forced a password change.
3.  **Testing:** Verified Carol could log in and was prompted to change her password at the workstation.

## Lessons Learned / Notes
* **Key Takeaway:** Functional help desk operations require precise attribute delegation (pwdLastSet) beyond just the generic "Reset Password" task.
* **Attribute Fixed:** `pwdLastSet` (Set to 0 to force change).