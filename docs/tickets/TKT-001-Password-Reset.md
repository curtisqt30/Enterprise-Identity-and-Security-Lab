# Ticket #001: User Unable to Login (Password Forgot)

| Field | Detail |
| :--- | :--- |
| **Status** | Open |
| **Date** | 2026-01-08 |
| **Requestor** | d.finance (Finance Department) |
| **Priority** | Medium |
| **Technician** | Curtis |

## Troubleshooting Steps Taken
1.  **Verified User Identity:** Confirmed request came from the valid user.
2.  **Checked Account Status:** Used Active Directory Users & Computers (ADUC) to check user object `d.finance`.
    * *Result:* Account was NOT locked out.
    * *Result:* Account status was "Enabled".

## Resolution
1.  Reset password to temporary alphanumeric credential.
2.  **Checked:** "User must change password at next logon" to ensure security compliance.
3.  **Unchecked:** "Account is disabled" (verified it remained active).
4.  Communicated temporary password to user via secure channel.
5.  Verified user successfully logged in and changed their password.

## Lessons Learned / Notes
* *Command Line Alternative:* Next time, can use `Set-ADAccountPassword` in PowerShell for faster resolution.
* *Security Note:* If the account had been locked out, I would have checked Event ID 4740 in Wazuh to ensure it wasn't a brute-force attempt before resetting.