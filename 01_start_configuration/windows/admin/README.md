# Windows Administrator Setup Guide

This guide covers the execution workflow for setting up your environment on **Windows with Administrator privileges**. 

---

## Prerequisites

1. Windows 10 / 11 with PowerShell 5.1 or PowerShell 7+.
2. Git for Windows installed.
3. Administrative rights on the target machine.

---

## Sequential Execution Flow

⚠️ **IMPORTANT:** Run these scripts **one by one sequentially**. Each step depends on the variables and state established by the previous one.

### Step 1: Configure the Environment File
Ensure your `.env` file is located in the root directory and populated:
```env
PERSONAL_ORG="personal"
PERSONAL_EMAIL="your_personal_email@example.com"
PERSONAL_FULLNAME="Your Personal Name"

WORK_ORG="work"
WORK_EMAIL="your_work_email@company.com"
WORK_FULLNAME="Your Professional Name"
```

### Step 2: Run the Preset Script
Open PowerShell **as Administrator** in the root directory and run the preset to load variables and generate SSH keys:
```powershell
Set-ExecutionPolicy Unrestricted -Scope Process -Force
.\01_start_configuration\windows\admin\00_pre_set.ps1
```

### Step 3: Run Admin Installations
Execute administrative software installations and system-level packages:
```powershell
.\01_start_configuration\windows\admin\01_installations_as_admin.ps1
```

### Step 4: Run Non-Admin Installations
Execute user-level package and utility installations:
```powershell
.\01_start_configuration\windows\admin\02_installations_not_admin.ps1
```

### Step 5: Apply Configurations & Git Setup
Apply global configurations, conditional `includeIf` rules, and deploy dynamic `.gitconfig` profiles:
```powershell
.\01_start_configuration\windows\admin\04_apply_configurations.ps1
```

---

## Post-Set (Cleanup)

To clean up temporary session artifacts and variables from your repository workspace after setup, run:
```powershell
.\01_start_configuration\windows\admin\99_post_set.ps1
```