#!/usr/bin/env python3
"""
zh-skills 技能规范校验器 (Skill Specification Linter)
校验 skills/ 目录下所有技能是否符合 Agent Skill 工业级规范。
"""

import os
import re
import sys
from pathlib import Path

# ANSI 颜色定义
GREEN = "\033[92m"
YELLOW = "\033[93m"
RED = "\033[91m"
BLUE = "\033[94m"
RESET = "\033[0m"
BOLD = "\033[1m"


def parse_frontmatter(content: str):
    """提取并解析 YAML frontmatter"""
    if not content.startswith("---"):
        return None, "缺少起始的 YAML frontmatter 分界线 (---)"

    parts = content.split("---", 2)
    if len(parts) < 3:
        return None, "YAML frontmatter 未正确闭合 (缺少结束 ---)"

    raw_yaml = parts[1].strip()
    body = parts[2].strip()

    data = {}
    for line in raw_yaml.splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if ":" in line:
            key, val = line.split(":", 1)
            data[key.strip()] = val.strip().strip("'\"")

    return (data, body), None


def validate_skill(skill_dir: Path):
    """校验单个技能文件夹"""
    errors = []
    warnings = []

    skill_name = skill_dir.name
    skill_file = skill_dir / "SKILL.md"

    # 1. 检查 SKILL.md 是否存在
    if not skill_file.is_file():
        errors.append("缺少核心入口文件 `SKILL.md`")
        return errors, warnings

    # 2. 文件夹命名规范检查 (kebab-case 且无需 -zh 后缀)
    if not re.match(r"^[a-z0-9]+(-[a-z0-9]+)*$", skill_name):
        warnings.append(f"文件夹命名建议采用全小写 kebab-case: '{skill_name}'")
    if skill_name.endswith("-zh") or skill_name.endswith("_zh"):
        warnings.append(f"技能名称建议保持纯净通用，末尾不要带有 '-zh' 后缀: '{skill_name}'")

    try:
        content = skill_file.read_text(encoding="utf-8")
    except Exception as e:
        errors.append(f"无法读取 SKILL.md 文件: {e}")
        return errors, warnings

    # 3. 解析 Frontmatter
    res, err = parse_frontmatter(content)
    if err:
        errors.append(err)
        return errors, warnings

    meta, body = res

    # 4. 检查必填元数据
    if "name" not in meta or not meta["name"]:
        errors.append("Frontmatter 中缺少必填字段: `name`")
    elif meta["name"] != skill_name:
        warnings.append(
            f"Frontmatter 中的 name ('{meta['name']}') 与文件夹名称 ('{skill_name}') 不一致"
        )

    if "description" not in meta or not meta["description"]:
        errors.append("Frontmatter 中缺少必填字段: `description`")
    else:
        desc = meta["description"]
        if len(desc) < 30:
            warnings.append(
                f"描述 (description) 过短 ({len(desc)} 字符)。建议补充触发词和适用场景说明以避免 Undertriggering"
            )

    # 5. 检查正文规范
    lines = body.splitlines()
    line_count = len(lines)
    if line_count > 500:
        warnings.append(
            f"SKILL.md 正文行数较长 ({line_count} 行 > 500 行)。推荐通过 references/ 或 scripts/ 目录进行渐进式加载 (Progressive Disclosure)"
        )

    # 6. 检查本地相对引用链接是否存在
    local_links = re.findall(r"\[.*?\]\((?!https?:\/\/|mailto:)(.*?)\)", body)
    for link in local_links:
        # 去除锚点
        clean_link = link.split("#")[0].strip()
        if not clean_link:
            continue
        target_path = skill_dir / clean_link
        if not target_path.exists():
            warnings.append(f"引用的本地文件或资源不存在: '{clean_link}'")

    return errors, warnings


def main():
    repo_root = Path(__file__).resolve().parent.parent
    skills_root = repo_root / "skills"

    print(f"\n{BOLD}{BLUE}========================================{RESET}")
    print(f"{BOLD}{BLUE}    zh-skills 技能规范自动化校验器      {RESET}")
    print(f"{BOLD}{BLUE}========================================{RESET}\n")

    if not skills_root.exists() or not skills_root.is_dir():
        print(f"{RED}错误: 未找到 skills 目录: {skills_root}{RESET}")
        sys.exit(1)

    skill_dirs = [d for d in skills_root.iterdir() if d.is_dir() and not d.name.startswith(".")]

    if not skill_dirs:
        print(f"{YELLOW}提示: skills/ 目录下尚未添加任何技能。{RESET}\n")
        sys.exit(0)

    total_skills = len(skill_dirs)
    passed_skills = 0
    total_errors = 0
    total_warnings = 0

    for s_dir in sorted(skill_dirs, key=lambda x: x.name):
        errors, warnings = validate_skill(s_dir)
        total_errors += len(errors)
        total_warnings += len(warnings)

        if not errors and not warnings:
            print(f"  {GREEN}✔{RESET} {BOLD}{s_dir.name}{RESET}")
            passed_skills += 1
        elif not errors and warnings:
            print(f"  {YELLOW}▲{RESET} {BOLD}{s_dir.name}{RESET}")
            for w in warnings:
                print(f"    {YELLOW}↳ 警告: {w}{RESET}")
            passed_skills += 1
        else:
            print(f"  {RED}✖{RESET} {BOLD}{s_dir.name}{RESET}")
            for e in errors:
                print(f"    {RED}↳ 错误: {e}{RESET}")
            for w in warnings:
                print(f"    {YELLOW}↳ 警告: {w}{RESET}")

    print(f"\n{BOLD}----------------------------------------{RESET}")
    print(
        f"校验完成: 共检测 {total_skills} 个技能, 通过: {passed_skills}/{total_skills}, "
        f"错误: {total_errors}, 警告: {total_warnings}"
    )

    if total_errors > 0:
        print(f"\n{RED}{BOLD}✘ 校验未通过，请修复上述错误后重新提交！{RESET}\n")
        sys.exit(1)
    else:
        print(f"\n{GREEN}{BOLD}✔ 所有技能校验通过，符合规范！{RESET}\n")
        sys.exit(0)


if __name__ == "__main__":
    main()
