#!/usr/bin/env bash

# zh-skills 一键安装脚本
# 支持快速安装技能至 Antigravity、Claude Code 或自定义项目环境

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SKILLS_DIR="${REPO_ROOT}/skills"

print_header() {
    echo -e "${BLUE}${BOLD}========================================${NC}"
    echo -e "${BLUE}${BOLD}        zh-skills 技能安装工具          ${NC}"
    echo -e "${BLUE}${BOLD}========================================${NC}\n"
}

show_help() {
    echo "用法: ./scripts/install.sh [选项] [技能名称...]"
    echo ""
    echo "选项:"
    echo "  --target, -t <target>   指定安装目标:"
    echo "                          antigravity : ~/.gemini/config/skills/ (默认)"
    echo "                          claude      : ~/.agents/skills/"
    echo "                          project     : 当前目录下的 .agents/skills/"
    echo "                          <custom>    : 自定义绝对或相对路径"
    echo "  --mode, -m <mode>       安装模式:"
    echo "                          symlink     : 创建符号链接 (推荐，同步更新, 默认)"
    echo "                          copy        : 复制文件"
    echo "  --all, -a               安装全部技能 (默认)"
    echo "  --list, -l              列出仓库中所有可用技能"
    echo "  --help, -h              显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  ./scripts/install.sh                             # 软链接全部技能至 Antigravity"
    echo "  ./scripts/install.sh --target claude             # 软链接全部技能至 Claude Code"
    echo "  ./scripts/install.sh --mode copy git-commit-zh   # 仅复制 git-commit-zh 技能"
    echo "  ./scripts/install.sh --target ./my-project/skills"
}

list_available_skills() {
    echo -e "${BOLD}可用技能列表:${NC}"
    if [ ! -d "${SKILLS_DIR}" ]; then
        echo "  (暂无技能目录)"
        return
    fi
    for skill_path in "${SKILLS_DIR}"/*; do
        if [ -d "${skill_path}" ] && [ -f "${skill_path}/SKILL.md" ]; then
            skill_name="$(basename "${skill_path}")"
            # 提取简短描述
            desc=$(grep -m 1 "^description:" "${skill_path}/SKILL.md" | sed 's/^description:[[:space:]]*//' | tr -d '"' | cut -c 1-60)
            echo -e "  - ${GREEN}${skill_name}${NC}: ${desc}..."
        fi
    done
    echo ""
}

# 默认配置
TARGET_ENV="antigravity"
INSTALL_MODE="symlink"
SPECIFIC_SKILLS=()
INSTALL_ALL=true

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case "$1" in
        --target|-t)
            TARGET_ENV="$2"
            shift 2
            ;;
        --mode|-m)
            INSTALL_MODE="$2"
            shift 2
            ;;
        --all|-a)
            INSTALL_ALL=true
            shift
            ;;
        --list|-l)
            list_available_skills
            exit 0
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        -*)
            echo -e "${RED}未知选项: $1${NC}"
            show_help
            exit 1
            ;;
        *)
            SPECIFIC_SKILLS+=("$1")
            INSTALL_ALL=false
            shift
            ;;
    esac
done

# 解析安装目标路径
DEST_DIR=""
case "${TARGET_ENV}" in
    antigravity)
        DEST_DIR="${HOME}/.gemini/config/skills"
        ;;
    claude)
        DEST_DIR="${HOME}/.agents/skills"
        ;;
    project)
        DEST_DIR="$(pwd)/.agents/skills"
        ;;
    *)
        DEST_DIR="${TARGET_ENV}"
        ;;
esac

print_header

echo -e "📦 技能源目录: ${BOLD}${SKILLS_DIR}${NC}"
echo -e "🎯 目标安装目录: ${BOLD}${DEST_DIR}${NC}"
echo -e "⚙️  安装模式: ${BOLD}${INSTALL_MODE}${NC}\n"

# 确保目标目录存在
mkdir -p "${DEST_DIR}"

# 收集需要安装的技能
SKILLS_TO_INSTALL=()
if [ "$INSTALL_ALL" = true ] && [ ${#SPECIFIC_SKILLS[@]} -eq 0 ]; then
    for skill_path in "${SKILLS_DIR}"/*; do
        if [ -d "${skill_path}" ] && [ -f "${skill_path}/SKILL.md" ]; then
            SKILLS_TO_INSTALL+=("$(basename "${skill_path}")")
        fi
    done
else
    SKILLS_TO_INSTALL=("${SPECIFIC_SKILLS[@]}")
fi

if [ ${#SKILLS_TO_INSTALL[@]} -eq 0 ]; then
    echo -e "${YELLOW}没有找到可安装的技能。${NC}"
    exit 0
fi

SUCCESS_COUNT=0

for skill in "${SKILLS_TO_INSTALL[@]}"; do
    SRC="${SKILLS_DIR}/${skill}"
    DEST="${DEST_DIR}/${skill}"

    if [ ! -d "${SRC}" ] || [ ! -f "${SRC}/SKILL.md" ]; then
        echo -e "  ${RED}✖ 技能不存在或缺少 SKILL.md: ${skill}${NC}"
        continue
    fi

    # 清理已存在的软链接或目录
    if [ -L "${DEST}" ] || [ -e "${DEST}" ]; then
        rm -rf "${DEST}"
    fi

    if [ "${INSTALL_MODE}" = "symlink" ]; then
        ln -s "${SRC}" "${DEST}"
        echo -e "  ${GREEN}✔ [软链接]${NC} ${skill} -> ${DEST}"
    else
        cp -r "${SRC}" "${DEST}"
        echo -e "  ${GREEN}✔ [已复制]${NC} ${skill} -> ${DEST}"
    fi
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
done

echo ""
echo -e "${GREEN}${BOLD}🎉 安装完成！成功安装 ${SUCCESS_COUNT} 个技能至: ${DEST_DIR}${NC}"
echo -e "${BLUE}💡 提示: 重启你的 Agent 会话或启动新任务，即可自动识别并使用已安装技能。${NC}\n"
