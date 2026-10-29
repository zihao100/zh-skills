#!/usr/bin/env bash

# zh-skills 技能脚手架生成工具
# 用于快速创建一个符合规范的 Agent Skill 目录与模板

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SKILLS_DIR="${REPO_ROOT}/skills"

SKILL_NAME="$1"

if [ -z "${SKILL_NAME}" ]; then
    echo -e "${YELLOW}请输入技能英文标识 (建议 kebab-case，如: api-doc-gen):${NC}"
    read -r SKILL_NAME
fi

# 检查命名规范
if [[ ! "${SKILL_NAME}" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    echo -e "${RED}错误: 技能名称必须为小写字母、数字与中划线组合 (kebab-case)，例如: code-review-zh${NC}"
    exit 1
fi

TARGET_DIR="${SKILLS_DIR}/${SKILL_NAME}"

if [ -d "${TARGET_DIR}" ]; then
    echo -e "${RED}错误: 技能目录已存在: ${TARGET_DIR}${NC}"
    exit 1
fi

echo -e "请输入技能简短描述 (包括触发时机与核心功能，必填):"
read -r SKILL_DESC

if [ -z "${SKILL_DESC}" ]; then
    SKILL_DESC="在用户需要相关功能时触发。提供专业的处理工作流与高质量输出。"
fi

mkdir -p "${TARGET_DIR}/references"
mkdir -p "${TARGET_DIR}/scripts"

cat <<EOF > "${TARGET_DIR}/SKILL.md"
---
name: ${SKILL_NAME}
description: ${SKILL_DESC}
---

# ${SKILL_NAME}

## 概述与核心目标

简明扼要说明该技能解决的问题、输入与输出。

## 触发场景

- 用户明确要求使用该技能或执行相关动作
- 相关的中文关键词或意图触发

## 工作流与操作步骤

### 第一步：输入收集与上下文分析
- 确认用户的具体目标
- 检查所需前置条件与文件

### 第二步：核心处理逻辑
1. 步骤一说明...
2. 步骤二说明...

### 第三步：结果校验与结构化交付
- 输出最终结果
- 提供后续建议或验证方式

## 规范与质量自检清单

- [ ] 符合代码与文档规范
- [ ] 中英文排版规范，专有名词准确
- [ ] 边界条件与异常处理已覆盖

## 渐进式资源引用 (可选)

当内容复杂或有大篇幅参考文档时，请将其放置于 \`references/\` 目录：
- 详细参考规范：详见 [references/spec.md](references/spec.md)
EOF

cat <<EOF > "${TARGET_DIR}/references/.gitkeep"
EOF

cat <<EOF > "${TARGET_DIR}/scripts/.gitkeep"
EOF

echo -e "\n${GREEN}${BOLD}✔ 技能脚手架创建成功！${NC}"
echo -e "📁 路径: ${TARGET_DIR}"
echo -e "📝 入口: ${TARGET_DIR}/SKILL.md"
echo -e "\n${BLUE}接下来您可以:${NC}"
echo -e "  1. 编辑 ${TARGET_DIR}/SKILL.md 完善技能指引"
echo -e "  2. 运行 ${BOLD}python3 scripts/validate_skills.py${NC} 校验格式规范\n"
