<div align="center">

# 🇨🇳 zh-skills

**High-Quality, Production-Ready AI Agent Skills for Chinese Engineering & Workflow Ecosystems**

<p align="center">
  <a href="https://github.com/zihao100/zh-skills/actions"><img src="https://img.shields.io/badge/CI-Passing-brightgreen?style=flat-square&logo=githubactions" alt="CI"></a>
  <a href="./LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square" alt="License"></a>
  <a href="./docs/SKILL_SPEC.md"><img src="https://img.shields.io/badge/Spec-Agent%20Skills-orange?style=flat-square" alt="Spec"></a>
  <a href="./CONTRIBUTING.md"><img src="https://img.shields.io/badge/PRs-Welcome-green.svg?style=flat-square" alt="PRs Welcome"></a>
  <a href="./README.md"><img src="https://img.shields.io/badge/中文文档-简体中文-red?style=flat-square" alt="Chinese Doc"></a>
</p>

<p align="center">
  <b>Compatible with Google Antigravity · Anthropic Claude Code · Cursor · OpenCode · Codex</b>
</p>

</div>

---

## 📖 Overview

`zh-skills` is an open-source, curated collection of AI Agent skills and workflows customized for Chinese software development, compliance reporting, and technical writing workflows.

While the majority of agent skills on the web are designed exclusively for English-centric contexts, `zh-skills` bridges the gap for Chinese localization, China software copyright regulations (CPCC), conventional commit standards with proper typography, and in-depth architecture review.

Every skill strictly adheres to the **Agent Skills Specification (YAML Frontmatter + Progressive Disclosure)** for maximum triggering accuracy and minimal token overhead.

---

## 🗂️ Skills Catalog

| Skill Identifier | Category | Core Capabilities | Typical Triggers |
| :--- | :--- | :--- | :--- |
| **[`git-commit-zh`](skills/git-commit-zh)** | Engineering | Generates precise, Conventional Commits-compliant Chinese git commit messages. | `write a commit message`, `git commit`, `summarize diff for commit` |
| **[`pr-review-zh`](skills/pr-review-zh)** | Engineering | Deep 6-pillar code review covering correctness, security, performance, architecture, and tests with actionable diffs. | `review this PR`, `audit branch diff`, `pre-merge check` |
| **[`api-design-rest`](skills/api-design-rest)** | Architecture | Modern RESTful API design, URI pluralization, status code alignment, and RFC 7807 error models. | `design an API contract`, `review RESTful standards` |
| **[`software-copyright-helper`](skills/software-copyright-helper)** | Compliance | Extracts first/last 30-page continuous code compliant with CPCC standards, outlines user manuals & design docs. | `software copyright application`, `软著材料整理`, `CPCC code extraction` |
| **[`tech-blog-zh`](skills/tech-blog-zh)** | Writing | High-impact Chinese technical articles and architecture breakdowns with diagrams, pain point hooks, and proper typography. | `write a tech blog`, `architecture breakdown`, `deep dive tutorial` |
| **[`changelog-zh`](skills/changelog-zh)** | Delivery | Analyzes git history to produce user-facing, Keep a Changelog & SemVer-compliant release notes in Chinese. | `generate changelog`, `write release notes` |
| **[`macos-app-cleaner-zh`](skills/macos-app-cleaner-zh)** | System Ops | Surgical uninstallation & orphan file cleaner for macOS desktop apps and CLI toolchain runtimes. | `uninstall app completely`, `clean CLI runtime residue` |

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
./scripts/install.sh git-commit-zh pr-review-zh
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
│   ├── validate_skills.py      # Skill specification linter (used in CI)
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

## 🤝 Contributing

Contributions are warmly welcomed! Please read our [**CONTRIBUTING.md**](CONTRIBUTING.md) guide before submitting a Pull Request.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
