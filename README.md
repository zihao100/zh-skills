<div align="center">

# 🇨🇳 zh-skills

**面向中文开发者的高质量、开箱即用 AI Agent 技能仓库**

<p align="center">
  <a href="https://github.com/zihao100/zh-skills/actions"><img src="https://img.shields.io/badge/CI-Passing-brightgreen?style=flat-square&logo=githubactions" alt="CI"></a>
  <a href="./LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square" alt="License"></a>
  <a href="./docs/SKILL_SPEC.md"><img src="https://img.shields.io/badge/Spec-Agent%20Skills-orange?style=flat-square" alt="Spec"></a>
  <a href="./CONTRIBUTING.md"><img src="https://img.shields.io/badge/PRs-Welcome-green.svg?style=flat-square" alt="PRs Welcome"></a>
  <a href="./README_EN.md"><img src="https://img.shields.io/badge/English-Documentation-blue?style=flat-square" alt="English Doc"></a>
</p>

<p align="center">
  <b>适配 Google Antigravity · Anthropic Claude Code · Cursor · OpenCode · Codex</b>
</p>

</div>

---

## 📖 项目简介

`zh-skills` 是一个专为中文开发者生态打造的开源 AI Agent 技能仓库与工作流集合。

市面上大多数 Agent 技能主要面向英文语境，缺少对中文技术生态、中文环境工作流的深度适配。`zh-skills` 严格遵循行业通用的 **Agent Skill 工业级规范（YAML Frontmatter + Progressive Disclosure 渐进式加载）**，旨在让你的 AI 编程助手具备开箱即用的专业能力。

### 🌟 核心特色

- 🇨🇳 **专注真实高频痛点**：面向中文环境与本地开发运维痛点定制，提供严谨可靠的自动化工作流。
- ⚡ **渐进式披露与极低 Token 消耗**：元数据按需常驻，正文控制在 500 行以内，复杂规范与执行脚本通过 `references/` 和 `scripts/` 按需调用，杜绝上下文浪费。
- 🛠️ **跨端一键安装工具**：提供灵活的跨平台安装脚本 `install.sh`，支持软链接（实时同步上游更新）或拷贝至 Antigravity、Claude Code 或项目本地。
- 🛡️ **严谨的 CI 自动化校验**：内置 `validate_skills.py` 自动化检测与 GitHub Actions CI，保障每个 Skill 的触发词设计与格式严谨性。

---

## 🗂️ 技能目录索引 (Skills Catalog)

| 技能标识 (ID) | 类别 | 核心能力说明 | 典型触发场景 |
| :--- | :--- | :--- | :--- |
| **[`macos-app-cleaner-zh`](skills/macos-app-cleaner-zh)** | 系统运维 | macOS 应用与命令行工具深度外科手术式卸载与残留清理，杜绝误伤与孤儿文件 | `彻底卸载软件`、`清理 CLI 运行时`、`排查大体积残留` |

> 💡 **欢迎共建**：你可以使用 `./scripts/new_skill.sh <name>` 快速创建新技能并提交 PR！

---

## 🚀 快速开始与安装

### 方式一：一键自动安装（推荐）

克隆本仓库后，使用自带的 `install.sh` 脚本进行安装。支持通过**符号链接 (Symlink)** 方式接入，后续只需 `git pull` 即可自动同步所有最新技能：

```bash
# 1. 克隆仓库
git clone https://github.com/zihao100/zh-skills.git
cd zh-skills

# 2. 安装全部技能至 Google Antigravity (~/.gemini/config/skills)
./scripts/install.sh --target antigravity

# 或安装至 Claude Code 全局环境 (~/.agents/skills)
./scripts/install.sh --target claude

# 或安装至当前项目本地 (.agents/skills)
./scripts/install.sh --target project
```

### 方式二：安装指定技能

若只需安装特定技能：

```bash
./scripts/install.sh macos-app-cleaner-zh
```

### 方式三：复制模式（独立魔改）

若不想使用符号链接，希望将技能文件完整复制至本地进行自主修改：

```bash
./scripts/install.sh --mode copy --target antigravity
```

---

## 💡 使用效果示例

### 示例：使用 `macos-app-cleaner-zh` 深度清理软件
```text
用户: "帮我彻底卸载 QQ 浏览器，检查是否有后台常驻和垃圾残留"
Agent: 正在执行外科手术式排查...
1. 审计进程与开机自启项：未发现活跃常驻守护。
2. 深度扫描磁盘分布：定位到 /Applications/QQBrowser.app 及 ~/Library/Application Support/QQBrowser 等关联残留。
3. 执行两阶段安全清理并进行复查闭环，实现系统级 0 字节残留！
```

---

## 🏗️ 技能开发与规范

技能仓库遵循严格的工业级 Agent 标准：

```
zh-skills/
├── skills/                     # 核心技能目录
│   └── <skill-name>/
│       ├── SKILL.md            # [必填] 技能主入口与 Frontmatter
│       ├── scripts/            # [可选] 确定性辅助可执行脚本
│       ├── references/         # [可选] 大篇幅参考资料与规则库
│       └── assets/             # [可选] 模板、示例等静态资源
├── scripts/                    # 运维与校验工具
│   ├── install.sh              # 一键安装脚本
│   ├── validate_skills.py      # 规范校验器 (CI 使用)
│   └── new_skill.sh            # 快速脚手架工具
└── docs/
    ├── SKILL_SPEC.md           # 详细开发与提示词编写规范
    └── FAQ.md                  # 常见问题与解答
```

### 快速创建新技能

```bash
# 使用脚手架生成规范模板
./scripts/new_skill.sh my-new-skill

# 编辑完成后运行本地语法与格式自检
python3 scripts/validate_skills.py
```

详见完整规范文档：[**docs/SKILL_SPEC.md**](docs/SKILL_SPEC.md)。

---

## 🤝 参与贡献

我们非常期待社区的参与！你可以通过以下方式为 `zh-skills` 添砖加瓦：

1. **贡献新技能**：提交解决实际开发或办公痛点的中文技能；
2. **优化既有技能**：改进提示词触发描述、增加实用脚本或更新参考资料；
3. **反馈与建议**：提出新技能提案或报告问题。

提交前请阅读完整 [**CONTRIBUTING.md**](CONTRIBUTING.md) 贡献指南。

---

## 📄 开源协议

本项目采用 [MIT License](LICENSE) 许可协议，支持个人及商业团队自由使用、修改与二次分发。
