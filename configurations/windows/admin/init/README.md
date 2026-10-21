# Windows Administrator Setup Guide

This guide covers the active setup workflow for Windows. The scripts are stored in `configurations\windows\admin\init`; supporting configuration templates and scripts are in the sibling `files` directory.

## Prerequisites

1. Windows 10 or 11 with PowerShell 5.1 or PowerShell 7+.
2. Administrative rights on the target machine.
3. A `.env` file in the repository root, created from `.env.sample` and populated with the required values.

## Sequential execution

Run each script from the repository root, in order. Do not run setup steps concurrently. Run `01_installations_as_admin.ps1` and `03_apply_configurations_as_admin.ps1` in an elevated PowerShell session. Run the remaining scripts as the target user so user-level applications and settings are applied to the correct profile.

```powershell
Set-ExecutionPolicy Unrestricted -Scope Process -Force
.\configurations\windows\admin\init\00_pre_set.ps1
.\configurations\windows\admin\init\01_installations_as_admin.ps1
.\configurations\windows\admin\init\02_installations_not_admin.ps1
.\configurations\windows\admin\init\03_apply_configurations_as_admin.ps1
.\configurations\windows\admin\init\04_apply_configurations_not_admin.ps1
.\configurations\windows\admin\init\05_login.ps1
```

The installation step disables automatic updates for all VS Code extensions by setting `extensions.autoUpdate` to `false` in the current user's VS Code settings. The configuration steps apply the Git templates from `files\configurations`.

## Post-setup cleanup

Run the cleanup script only when you intend to discard local repository changes created during setup:

```powershell
.\configurations\windows\admin\init\99_post_set.ps1
```