# AGENTS.md - 智能体协作与开发指南

欢迎来到 `zh-skills` 仓库。作为协助维护本仓库的 AI Agent，请在进行任何代码修改、技能新增或重构时严格遵循本文件定义的规范。

---

## 1. 仓库定位与架构

`zh-skills` 是一个面向中文开发者与多端 AI Agent 生态（Antigravity、Claude Code、Cursor 等）的开源技能（Skills）仓库。

- `skills/<skill-name>/`: 核心技能目录。每个子目录代表一个独立技能，必须包含 `SKILL.md`。
- `scripts/`: 仓库维护脚本，包括安装工具 `install.sh`、校验工具 `validate_skills.py`、脚手架 `new_skill.sh`。
- `docs/`: 规范文档（`SKILL_SPEC.md`）与常见问题（`FAQ.md`）。
- `.github/`: Issue/PR 模板。

---

## 2. Agent 行为守则与准则

1. **外科手术式修改 (Surgical Changes)**：
   - 保持最小必要改动，绝不引入无关的代码格式污染或随意的重排版。
   - 保留所有既有注释、文档与上下文。

2. **零容忍规范错误**：
   - 在添加或修改任何 `skills/` 下的内容后，**必须**在终端运行并确认校验通过：
     ```bash
     python3 scripts/validate_skills.py
     ```
   - 保证 0 Error，0 Warning。

3. **创建新技能的标准流程**：
   - 技能名称采用 kebab-case 全小写中划线，**末尾不带 `-zh` 后缀**（例如 `k8s-troubleshoot`，不要写成 `k8s-troubleshoot-zh`）。
   - YAML Frontmatter 中的 `name` 必须与所在文件夹名完全一致。
   - `description` 必须详细说明“**何时触发**”与“**核心解决什么问题**”，字数适中并带有明确的触发关键词。
   - 正文篇幅控制在 500 行以内，复杂内容下沉至 `references/` 目录。
   - 中英文、数字之间保留标准半角空格（盘古之白）。

4. **同步更新主文档索引**：
   - 若新增或删除了技能，必须同步在 `README.md` 与 `README_EN.md` 的技能目录清单表格中增加/更新对应的条目、分类与简短介绍。

---

## 3. 常用开发与自检命令

```bash
# 1. 运行全仓技能规范检查
python3 scripts/validate_skills.py

# 2. 模拟本地安装测试
./scripts/install.sh --target ./test-dist --mode copy

# 3. 格式与语法自检
git status
```
