# Project Objective

The project is a modular, cross-platform development environment provisioning system designed to seamlessly manage and isolate dual Git and SSH identities (Personal and Professional) on a single machine. It utilizes a sequential execution flow, dynamic configuration via a `.env` file, and conditional Git `includeIf` logic to prevent hardcoding sensitive data, ensuring a clean, reproducible, and secure workspace setup.

# Multi-Platform Strategy

Platform implementations are strictly isolated. The system avoids universal scripts with internal OS-checks; instead, it uses dedicated execution paths for each operating system (e.g., Windows natively uses PowerShell; Linux/macOS will use Bash/Zsh). Furthermore, execution logic is subdivided into administrative (root/elevated) and non-administrative (standard user) tiers to respect OS security boundaries.

# Directory Structure Architecture

The repository is structured to maintain a strict separation between executable provisioning scripts and static configuration templates:

```text
.
├── .env.sample                       # Template for dynamic env vars
├── 01_start_configuration/           # Executable setup scripts
│   ├── windows/                      # Windows execution path
│   │   ├── admin/                    # Elevated scripts (PowerShell)
│   │   │   ├── 00_preset.ps1         # Loads .env, generates keys
│   │   │   ├── 01_installations...   # Admin-level packages
│   │   │   ├── 02_installations...   # User-level packages
│   │   │   ├── 04_apply_config...    # Deploys configs to OS paths
│   │   │   └── 99_post_set.ps1       # Cleanup and Git reset
│   │   └── non_admin/                # Standard user scripts
│   └── linux/                        # Linux execution path future (soon)
├── 02_configuration/                 # Centralized config templates
│   ├── .work.gitconfig               # Global Git template
│   └── .personal.gitconfig           # Local Git template
└── README.md                         # Global project documentation
```