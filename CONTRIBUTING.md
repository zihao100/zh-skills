# 贡献指南 (Contributing Guide)

感谢你关注并愿意为 `zh-skills` 做出贡献！本项目致力于为全球中文开发者与 AI Agent 用户构建高质量、开箱即用的技能生态。

无论你是提交新的中文技能、优化现有技能的触发准确率、修补文档错别字，还是完善安装工具，我们都非常欢迎你的 Pull Request。

---

## 1. 贡献流程

### 步骤一：Fork 本仓库并克隆到本地
```bash
git clone https://github.com/<your-username>/zh-skills.git
cd zh-skills
```

### 步骤二：创建特性分支
```bash
git checkout -b feat/add-my-awesome-skill
```

### 步骤三：创建并开发技能
推荐使用仓库自带的脚手架工具快速生成标准模板：
```bash
./scripts/new_skill.sh <skill-name>
```
例如：
```bash
./scripts/new_skill.sh docker-compose
```

编辑 `skills/<skill-name>/SKILL.md`，编写技能工作流与示例。若有较长参考文档，放入 `references/` 目录；若有辅助脚本，放入 `scripts/` 目录。

### 步骤四：运行本地规范校验
提交前必须运行校验脚本，确保没有任何规范错误：
```bash
python3 scripts/validate_skills.py
```

### 步骤五：提交代码并发起 Pull Request
```bash
git add .
git commit -m "feat(skill): 新增 <skill-name> 技能"
git push origin feat/add-my-awesome-skill
```
前往 GitHub 仓库发起 Pull Request，并填写 PR 模板。

---

## 2. 技能准入与审核标准

为了保证整个仓库的高品质，所有被合并的技能均需满足以下要求：

1. **解决真痛点**：具备明确的中文场景或研发高频痛点，非简单几句日常聊天的空洞提示。
2. **规范的 Frontmatter**：包含小写的 `name` 与具体、具召唤力的 `description`（说明触发时机）。
3. **渐进式披露 (Progressive Disclosure)**：`SKILL.md` 正文建议控制在 500 行以内；大篇幅内容通过 `references/` 引用。
4. **高质量排版**：严格遵守中文排版规范，汉字与英文/数字之间保留空格，专有名词大小写规范。
5. **严禁包含敏感信息**：不得在代码、注释或示例中包含真实的 API Key、密码、企业内部未经脱敏的数据或他人专有版权内容。

---

## 3. 行为准则 (Code of Conduct)

我们致力于营造一个友善、开放且包容的开源社区。在参与讨论与协作时，请保持专业、互相尊重，聚焦于代码与架构本身。
