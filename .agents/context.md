# Project Objective

This project provisions development environments and keeps personal and professional Git and SSH identities separate. The current implementation supports a sequential Windows setup, configured through a root `.env` file and templates under the Windows configuration tree.

# Multi-Platform Strategy

Keep platform implementations isolated: Windows uses PowerShell, while future Linux/macOS implementations should use platform-appropriate scripts. The current supported workflow is Windows with Administrator privileges; standard-user and other-platform workflows are planned.

# Directory Structure

Executable setup scripts, supporting files, and configuration templates are organized together by platform and profile:

```text
.
├── .env.sample
├── configurations/
│   └── windows/
│       └── admin/
│           ├── files/
│           │   ├── configurations/   # Git and PowerShell templates
│           │   └── scripts/          # Supporting setup scripts
│           └── init/
│               ├── functions/       # Shared PowerShell functions
│               └── *.ps1            # Sequential setup steps
└── README.md
```

Run the scripts in `configurations/windows/admin/init` in sequence, using paths relative to the repository root. The installation step also disables automatic updates for all VS Code extensions.