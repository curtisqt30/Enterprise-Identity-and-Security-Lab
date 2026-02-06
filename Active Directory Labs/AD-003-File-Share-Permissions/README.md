# Project: AD-003-File-Share-Permissions
**Date:** February 2026
**Platform:** Windows Server 2022 (NTFS & SMB)

## 1. Project Overview
Following the implementation of Group Policy (AD-003), I moved to securing data at rest. This project focused on implementing **Role-Based Access Control (RBAC)** on a corporate file server. The objective was to configure a "Least Privilege" model where general employees have Read-Only access to public data, while sensitive departments (HR) maintain exclusive access to confidential files.

## 2. Architecture & Design
* **Root Share:** `\\dc01\CompanyData`
* **Permission Strategy:**
    * **Share Level:** "Everyone = Full Control" (The "Open Door" approach to avoid conflicting restrictions).
    * **NTFS Level:** "The Real Lock" - Granular permissions applied directly to folders.

## 3. Configuration Details

### Folder A: "Public" (The Read-Only Repository)
* **Goal:** Allow all staff to view templates but prevent modification or deletion.
* **Configuration:**
    * **Inheritance:** Disabled.
    * **Principals:**
        * `CORP\Domain Users`: **Read & Execute** (Allows viewing/running).
        * `CORP\Domain Admins`: **Full Control**.
* **Security Validation:** Verified that `James.Smith` (Sales) could open `Welcome.txt` but received "Access Denied" when attempting to delete or overwrite it.

### Folder B: "HR_Confidential" (The Restricted Zone)
* **Goal:** Strict isolation. Only members of the HR department may enter.
* **Configuration:**
    * **Inheritance:** Disabled (Critical step to remove default "Users" access).
    * **Principals:**
        * `CORP\Domain Users`: **REMOVED**.
        * `CORP\G_HR` (Security Group): **Modify** (Read/Write/Delete).
* **Security Validation:**
    * **Block:** Confirmed that `James.Smith` was denied entry at the folder root.
    * **Allow:** Confirmed that `HR.Admin` could successfully access and modify `Salaries.txt`.

## 4. Key Concepts Demonstrated
* **Least Privilege:** Users were only granted the permissions necessary for their role (Read vs. Modify).
* **Inheritance Blocking:** Breaking the default permission chain to create secure sub-folders.
* **Group-Based Management:** Permissions were assigned to the `G_HR` Security Group, not individual users, ensuring scalability for future hires.