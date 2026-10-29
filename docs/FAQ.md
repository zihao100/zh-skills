# 常见问题解答 (FAQ)

### Q1: 什么是 Agent Skill（智能体技能）？与普通的 Prompt 有何不同？

**A**: 
- **普通 Prompt**：通常是一次性的提示词片段，缺乏系统化文件结构，难以管理外部辅助资源。
- **Agent Skill**：遵循现代 AI Agent 标准规范的模块化扩展包。它具备标准的元数据声明（YAML Frontmatter）、渐进式披露机制（Progressive Disclosure）、可搭载确定性执行脚本（`scripts/`）与深度参考文档（`references/`）。Agent 会在需要时自发激活对应技能，执行结构化的高阶工作流。

---

### Q2: zh-skills 支持哪些 AI 客户端和环境？

**A**: 
`zh-skills` 完全基于行业通用的 Agent Skill 规范开发，兼容主流 Agent 环境：
- **Google Antigravity**: 全面原生支持（全局目录 `~/.gemini/config/skills/` 或工作区自定义配置）。
- **Anthropic Claude Code**: 全面支持（软链接或拷贝至 `~/.agents/skills/`）。
- **Cursor / Windsurf**: 支持将 `SKILL.md` 内容作为项目规则（`.cursorrules` / `.cursor/rules/`）使用。
- **其他自主智能体 (Custom Agents)**: 任何具备文件读取能力且支持系统提示词注入的 Agent 均可加载。

---

### Q3: 推荐使用“软链接 (Symlink)”还是“复制 (Copy)”安装？

**A**: 
- **推荐软链接 (`--mode symlink`)**：在本地克隆 `zh-skills` 仓库后执行 `./scripts/install.sh`。软链接模式下，当您在 `zh-skills` 目录执行 `git pull` 更新时，所有已安装技能自动无缝升级，无需重新拷贝。
- **复制模式 (`--mode copy`)**：适合在没有符号链接权限的受限系统，或希望对某个技能进行本地魔改、不随上游变更的场景。

---

### Q4: 为什么我的 Agent 在对话中没有自动触发某个技能？

**A**: 
1. **检查是否正确安装**：确认技能目录已成功出现在 `~/.gemini/config/skills/` 或对应 Agent 配置目录下。
2. **重启 Agent 会话**：部分 Agent 客户端在启动初始化时缓存技能列表，请退出终端或重启会话使新技能生效。
3. **欠触发 (Undertriggering)**：模型可能认为当前请求无需专门技能。您可以直接在提问中带入关键词或技能名称，例如：“*请使用 macos-app-cleaner 技能帮我排查残留*”；或参考 [SKILL_SPEC.md](SKILL_SPEC.md) 优化该技能的 `description`。

---

### Q5: 我可以在公司/私有商业项目中使用这些技能吗？

**A**: 
完全可以。本项目基于宽松的 **MIT 许可证** 开源，允许商业使用、修改、分发及团队内部私有化部署。

---

### Q6: 如何贡献一个我自己打造的技能？

**A**: 
非常欢迎！请参考 [CONTRIBUTING.md](../CONTRIBUTING.md)：
1. 运行 `./scripts/new_skill.sh <your-skill-name>` 快速创建骨架；
2. 完善 `SKILL.md` 与相关资源；
3. 运行 `python3 scripts/validate_skills.py` 确保校验 100% 通过；
4. 提交 Pull Request，社区将在 24 小时内进行 Review 与合并。
