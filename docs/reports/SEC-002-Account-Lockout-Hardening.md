# Security Remediation Report: SEC-001

| Field | Detail |
| :--- | :--- |
| **Type** | Security Misconfiguration / Hardening |
| **Severity** | **High** |
| **Date Detected** | 2026-01-09 |
| **Remediation Date** | 2026-01-09 |
| **Author** | Alice Admin |

## Executive Summary
While investigating a user lockout incident (TKT-002), a critical misconfiguration was identified in the domain's default password policy. The Account Lockout Threshold was set to 0, effectively disabling the lockout mechanism. This left the environment vulnerable to persistent brute-force attacks. The policy has been remediated to meet industry security standards.

## Technical Findings
* **Vulnerability:** The domain-wide Account Lockout Threshold was disabled (`0`), meaning users could attempt an infinite number of incorrect passwords without the account being locked.
* **Impact:** This allowed for unhindered brute-force or dictionary attacks against any user account in the domain, posing a severe risk of unauthorized access and credential theft.
* **Evidence:** PowerShell command `Get-ADDefaultDomainPasswordPolicy` confirmed the threshold was `0`.

## Remediation Actions (The "Change")
1.  **GPO Modification:** Accessed the Default Domain Policy via GPMC on the management workstation (`CLIENT01`).
2.  **Hardening Configuration:** Updated the Account Lockout Policy to the following parameters:
- **Lockout Threshold:** 5 invalid attempts.
- **Lockout Duration:** 15 minutes.
- **Observation Window:** 15 minutes.
3.  **Policy Enforcement:** Forced a domain-wide update using `gpupdate /force` to ensure immediate protection.

## Verification
* **Method:** Re-verified the policy using PowerShell and checked the "Effective Access" for the policy on the domain.
* **Result:** The policy now correctly reflects a threshold of 5 attempts, confirming that brute-force protection is active.

## Status
✅ **remediated**