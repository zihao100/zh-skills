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

`zh-skills` 是一个专为中文技术生态定制的开源 AI Agent 技能库与工作流集合。

市面上大多数 Agent 技能主要面向英文语境，缺少对国内研发流程、合规申报与中文写作风格的深度适配。`zh-skills` 严格遵循行业通用的 **Agent Skill 工业级规范（YAML Frontmatter + Progressive Disclosure 渐进式加载）**，旨在让你的 AI 编程助手具备开箱即用的专业能力。

### 🌟 核心特色

- 🇨🇳 **深度本土化场景**：覆盖中国软件著作权申报、中英文规范提交、高质量技术博客排版、专业中文 Code Review 等高频真实场景。
- ⚡ **渐进式披露与极低 Token 消耗**：元数据按需常驻，正文控制在 500 行以内，复杂规范与执行脚本通过 `references/` 和 `scripts/` 按需调用，杜绝上下文浪费。
- 🛠️ **跨端一键安装工具**：提供灵活的跨平台安装脚本 `install.sh`，支持软链接（实时同步上游更新）或拷贝至 Antigravity、Claude Code 或项目本地。
- 🛡️ **严谨的 CI 自动化校验**：内置 `validate_skills.py` 自动化检测与 GitHub Actions CI，保障每个 Skill 的触发词设计与格式严谨性。

---

## 🗂️ 技能目录索引 (Skills Catalog)

| 技能标识 (ID) | 类别 | 核心能力说明 | 典型触发场景 |
| :--- | :--- | :--- | :--- |
| **[`git-commit-zh`](skills/git-commit-zh)** | 研发提效 | 生成符合 Conventional Commits 规范的精准中文提交信息 | `帮我写个 commit`、`生成提交信息`、`git commit` |
| **[`pr-review-zh`](skills/pr-review-zh)** | 研发提效 | 从正确性、安全、性能、架构等 6 大维度输出结构化评审报告与修改 Diff | `review 这个 PR`、`审查分支代码`、`合并前检查` |
| **[`api-design-rest`](skills/api-design-rest)** | 架构设计 | 现代 RESTful API 接口规范设计、HTTP 状态码匹配与统一错误结构 (RFC 7807) | `设计一套订单 API`、`评审接口规范`、`RESTful 设计` |
| **[`software-copyright-helper`](skills/software-copyright-helper)** | 合规申报 | 提取符合中国版权保护中心（CPCC）规范的前后各 30 页源代码与设计说明书大纲 | `准备软著材料`、`软著源代码提取`、`写软著操作手册` |
| **[`tech-blog-zh`](skills/tech-blog-zh)** | 技术写作 | 高质量中文技术博客与架构深度剖析写作，规范排版（盘古之白）与图解优先 | `写一篇架构分析博客`、`深度技术分享`、`公众号文章` |
| **[`changelog-zh`](skills/changelog-zh)** | 发布协同 | 提取 Git 提交记录自动生成面向用户的 Keep a Changelog 规范中文更新日志 | `生成版本更新日志`、`写 Release Notes`、`准备发布公告` |
| **[`macos-app-cleaner-zh`](skills/macos-app-cleaner-zh)** | 系统运维 | macOS 应用与命令行工具深度外科手术式卸载与残留清理，杜绝误伤与孤儿文件 | `彻底卸载软件`、`清理 CLI 运行时`、`排查大体积残留` |

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

若只需安装其中某几个技能：

```bash
./scripts/install.sh git-commit-zh pr-review-zh
```

### 方式三：复制模式（独立魔改）

若不想使用符号链接，希望将技能文件完整复制至本地进行自主修改：

```bash
./scripts/install.sh --mode copy --target antigravity
```

---

## 💡 使用效果示例

### 示例 1：使用 `git-commit-zh` 生成中文提交
```text
用户: "帮我看一下刚才修改的代码，写个 commit message"
Agent: 正在分析工作区变更... 识别到新增购物车批量操作与性能查询优化。

建议提交信息：
feat(cart): 支持购物车批量删除与失效商品一键清空

- 新增批量操作接口 /api/v1/cart/batch-delete
- 引入 Redis Pipeline 批量清理用户缓存，减少网络往返耗时
- 补充单元测试用例，覆盖空列表与不存在商品的异常边界

Closes #108
```

### 示例 2：使用 `pr-review-zh` 审查代码
```text
用户: "请用 pr-review-zh 审查一下我当前的这个分支"
Agent: 正在对分支改动进行 6 维度全量审查...
输出包含【📌 评审结论】、【🚨 严重问题】、【⚠️ 优化建议】与直接可用的【Diff 代码修改方案】。
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
