# Multi-Platform Automated Environment Setup

This repository provides a modular setup for provisioning development environments and keeping personal and professional Git identities separate. The active implementation targets Windows and uses PowerShell scripts, a `.env` file, and configuration templates. Linux and macOS support are planned.

## Repository structure

```text
.
├── configurations/
│   └── windows/
│       └── admin/
│           ├── files/
│           │   ├── configurations/   # Git and PowerShell configuration templates
│           │   └── scripts/          # Supporting scripts, including VS Code settings
│           └── init/                 # Sequential Windows setup scripts and functions
├── .env.sample
└── README.md
```

## Setup workflow

1. Copy `.env.sample` to `.env` in the repository root and provide the required personal and work values.
2. Open PowerShell in the repository root.
3. Run the scripts in `configurations\windows\admin\init` sequentially, using the privilege level described in the [Windows Administrator Setup Guide](configurations/windows/admin/init/README.md).
4. The installation step disables automatic updates for all VS Code extensions.
5. Run the post-set cleanup only when you are ready to discard local changes produced during setup.

Windows Administrator setup is the only currently implemented platform/profile. Standard-user Windows, Linux, and macOS workflows are planned.
