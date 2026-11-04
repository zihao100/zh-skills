<div align="center">

# 🇨🇳 zh-skills

**High-Quality, Production-Ready AI Agent Skills for Chinese Engineering & Workflow Ecosystems**

<p align="center">
  <a href="./LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square" alt="License"></a>
  <a href="./docs/SKILL_SPEC.md"><img src="https://img.shields.io/badge/Spec-Agent%20Skills-orange?style=flat-square" alt="Spec"></a>
  <a href="./README.md"><img src="https://img.shields.io/badge/中文文档-简体中文-red?style=flat-square" alt="Chinese Doc"></a>
</p>

<p align="center">
  <b>Compatible with Google Antigravity · Anthropic Claude Code · Cursor · OpenCode · Codex</b>
</p>

</div>

---

## 📖 Overview

`zh-skills` is an open-source, curated collection of AI Agent skills and workflows customized for Chinese developer ecosystems.

Every skill strictly adheres to the **Agent Skills Specification (YAML Frontmatter + Progressive Disclosure)** for maximum triggering accuracy and minimal token overhead.

---

## 🗂️ Skills Catalog

| Skill Identifier | Category | Core Capabilities | Typical Triggers |
| :--- | :--- | :--- | :--- |
| **[`macos-app-cleaner`](skills/macos-app-cleaner)** | System Ops | Surgical uninstallation & orphan file cleaner for macOS desktop apps and CLI toolchain runtimes. | `uninstall app completely`, `clean CLI runtime residue`, `macos app cleaner` |

> 💡 **Adding a skill**: Run `./scripts/new_skill.sh <name>` to scaffold a spec-compliant skill, then verify it with `python3 scripts/validate_skills.py`.

---

## 🚀 Quick Start & Installation

### Option 1: Automatic One-Click Installation (Recommended)

Clone the repository and run `install.sh`. Using **symbolic links (`--mode symlink`)** allows your agent environments to receive upstream updates automatically whenever you `git pull`:

```bash
# 1. Clone repository
git clone https://github.com/zihao100/zh-skills.git
cd zh-skills

# 2. Install all skills to Google Antigravity (~/.gemini/config/skills)
./scripts/install.sh --target antigravity

# Or install to Anthropic Claude Code (~/.agents/skills)
./scripts/install.sh --target claude

# Or install to current project root (.agents/skills)
./scripts/install.sh --target project
```

### Option 2: Install Specific Skills

```bash
./scripts/install.sh macos-app-cleaner
```

### Option 3: Copy Mode (Standalone Modifications)

If you prefer to copy the skill folders rather than symlinking:

```bash
./scripts/install.sh --mode copy --target antigravity
```

---

## 🏗️ Repository Architecture & Standards

```
zh-skills/
├── skills/                     # Core skills directory
│   └── <skill-name>/
│       ├── SKILL.md            # [Required] Entrypoint with YAML frontmatter
│       ├── scripts/            # [Optional] Deterministic helper scripts
│       ├── references/         # [Optional] In-depth reference docs
│       └── assets/             # [Optional] Templates and static assets
├── scripts/                    # Maintenance and validation tools
│   ├── install.sh              # Cross-platform installer
│   ├── validate_skills.py      # Skill specification linter (local check)
│   └── new_skill.sh            # Scaffolding tool
└── docs/
    ├── SKILL_SPEC.md           # Authoring specification
    └── FAQ.md                  # Frequently Asked Questions
```

### Scaffolding a New Skill

```bash
# Scaffold a new skill directory
./scripts/new_skill.sh my-new-skill

# Run specification verification
python3 scripts/validate_skills.py
```

For full details, please refer to [**docs/SKILL_SPEC.md**](docs/SKILL_SPEC.md).

---

## 🤝 Feedback

This is a personally maintained collection. There is no formal community review process and no response-time commitment.

Issues with reproduction steps are welcome. Forks and local modifications are free under the MIT license — the workflow and verification commands in [**CONTRIBUTING.md**](CONTRIBUTING.md) apply to your own copy as well.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
