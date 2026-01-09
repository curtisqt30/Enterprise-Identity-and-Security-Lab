# Ticket #001: User Unable to Login (Password Forgot)

| Field | Detail |
| :--- | :--- |
| **Status** | Closed |
| **Date** | 2026-01-08 |
| **Requestor** | Dave Finance (Finance Department) |
| **Priority** | Medium |
| **Technician** | Curtis |

## Issue Description
User reported they are unable to log in to their workstation. They believe they have forgotten their password after returning from the weekend.

## Troubleshooting Steps Taken
1.  **Verified User Identity:** Confirmed request came from the valid user.
2.  **Tool Selection:** Launched **Active Directory Users & Computers (RSAT)** on admin workstation `CLIENT01`.
3.  **Checked Account Status:**
    * *Result:* Account was **NOT** locked out (checked for "Unlock" status).
    * *Result:* Account status was "Enabled".

## Resolution
1.  Located user object `d.finance` in the `Finance` OU via the RSAT console.
2.  Right-clicked user > **Reset Password**.
3.  **Security Compliance:**
    * Set temporary alphanumeric credential.
    * **Checked:** "User must change password at next logon".
    * **Checked:** "Unlock the user's account" (preventative measure).
4.  Communicated temporary password to user via secure channel.
5.  Verified user successfully logged in and was prompted to change their password immediately.

## Lessons Learned / Notes
* **Best Practice:** Performed all actions remotely from `CLIENT01` using RSAT rather than RDPing into the Domain Controller (`DC01`). This reduces the attack surface on the DC.
* **Security Context:** If the account had been locked out, I would have pivoted to Wazuh to check **Event ID 4740** to verify the source of the lockout before resetting.