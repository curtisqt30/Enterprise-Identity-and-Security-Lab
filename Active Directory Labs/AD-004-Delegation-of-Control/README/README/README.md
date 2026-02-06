# Project: AD-004-Delegation-of-Control
**Date:** February 2026
**Platform:** Windows Server 2022 & RSAT (Windows 10)

## 1. Project Overview
After securing user data (AD-004), I shifted focus to securing the administration layer itself. The goal was to implement a **Least Privilege** model for the IT Help Desk. Instead of granting "Domain Admin" rights to support staff (a major security risk), I utilized the **Delegation of Control Wizard** to grant *only* the specific permissions required to reset passwords and unlock accounts.

## 2. Configuration Details

### Delegation A: Password Resets
* **Target Scope:** `OU=Employees` (Applies to all staff).
* **Principal:** `CORP\G_IT` (IT Security Group).
* **Permissions Grant:**
    * Used the "Delegate common tasks" wizard to assign **"Reset user passwords and force password change at next logon."**

### Delegation B: Account Unlocks (The Advanced Fix)
* **Problem:** The standard wizard grants password reset rights but *fails* to grant "Unlock" rights, causing an "Insufficient Access" error when IT staff attempted to unlock a user.
* **Resolution:** Manually edited the ACL (Access Control List) on the OU.
* **Specific Rights Granted:**
    * Object Type: **User Objects**
    * Property: **Write lockoutTime** (Allowed the IT group to clear the lockout attribute).

## 3. Tooling & Verification
* **Remote Administration:** Installed **RSAT (Remote Server Administration Tools)** on `Client01` using PowerShell (`Add-WindowsCapability ... Rsat.ActiveDirectory.DS-LDS.Tools`). This allowed IT staff to manage AD from a Windows 10 workstation rather than logging into the Domain Controller.
* **Validation Tests:**
    * **Success:** Logged in as `IT.Guy` (Standard User) and successfully reset the password for `James.Smith`.
    * **Success:** Successfully unlocked `James.Smith` after the permission fix.
    * **Denial:** Attempted to **Delete** `James.Smith` and was correctly blocked with "Access Denied."

## 4. Verification Command
* **Proof of Delegation:**
    ```powershell
    dsacls "OU=Employees,DC=corp,DC=local" | Select-String "G_IT" -Context 0,3
    ```
    * *Output confirmed:* `Reset Password` and `WRITE PROPERTY (lockoutTime)`.

![Output](./output.png)
