# Multi-Platform Automated Environment Setup

This repository provides a modular, dynamic, and cross-platform setup architecture designed to separate personal and professional development environments seamlessly. 

> **Architecture Note:** The framework is structured to support multiple platforms (currently **Windows**, with Linux/macOS planned) and handles execution flows for both **Administrator / Root** privileges and **Standard User** profiles.

---

## Architecture Overview

```text
.
├── 01_start_configuration/
│   ├── windows/
│   │   ├── admin/       # 👈 Current active setup (Elevated privileges)
│   │   └── standard/    # 👈 Standard user setup (Non-elevated)
│   └── linux/           # 🔜 Future expansion (Root & Non-root)
└── 02_configuration/    # Dynamic config templates (.gitconfig, SSH, etc.)
```

---

## Global Execution Flow

1. **Configure Environment:** Populate your `.env` file from `.env.sample`.
2. **Choose Your Platform & Privilege Level:** Navigate to the corresponding documentation guide depending on your operating system and user permissions.
3. **Run Sequentially:** Execute setup scripts one by one. Do not run them concurrently.
4. **Post-Set (Cleanup):** Run the cleanup script to remove temporary session residue.

---

## Platform Guides

* **Windows (Administrator / Elevated):** See the detailed guide in [`01_start_configuration/windows/admin/README.md`](./01_start_configuration/windows/admin/README.md).
* **Windows (Standard User):** *Coming soon.*
* **Linux / macOS:** *Planned for future releases.*