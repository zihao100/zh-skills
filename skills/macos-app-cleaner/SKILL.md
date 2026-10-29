---
name: macos-app-cleaner
description: 专为 macOS 打造的应用与命令行软件深度清理技能。全域覆盖桌面 GUI 应用（.app）与终端 CLI 工具（Agent 运行时），深度挖掘沙盒隔离、应用支持库、开机自启常驻项及 IDE 宿主内部隐藏副本，严格遵循工程源码与私钥资产隔离护栏，实现 0 残留且安全可靠的两阶段清理与二次复查闭环。
---

# macos-app-cleaner - macOS 应用与 CLI 深度清理技能

## 核心目标

在 macOS 环境下，针对目标软件执行外科手术式的彻底卸载与残留排查。不仅支持常规的桌面图形应用（GUI `.app`），更深度支持各类终端命令行软件（CLI、AI Agent 运行时、语言包全局工具）。通过多维排查、隐藏副本挖掘、工程代码防误伤护栏与复查验证闭环，实现真正意义上的 **0 字节系统级残留**。

## 触发场景

- 用户要求彻底卸载或删除某款 macOS 软件（如：“帮我彻底卸载 QQ 浏览器”、“删除微信支付证书工具”）
- 用户要求清理某个终端命令行工具、CLI 智能体或开发运行时（如：“把 cursor-agent 删干净”、“排查哪个命令指向了它”）
- 软件已手动拖入废纸篓，但怀疑在 `~/Library`、沙盒目录或后台留有陈年垃圾与大体积缓存
- 磁盘“系统数据”或“其他”莫名暴增，需要深度定位并清理已删除软件留下的孤儿残留（Orphaned Files）

---

## 软件类型排查矩阵

| 类型 | 典型形态 | 核心排查要点 |
| :--- | :--- | :--- |
| **桌面图形应用 (GUI)** | `/Applications/*.app`<br>`~/Applications/*.app` | 检查 App 运行状态、沙盒 Containers、Application Support、Caches、系统偏好设置 plist |
| **终端命令行工具 (CLI)** | `$PATH` 下的可执行文件与符号链接 | 检查 `~/.local/bin`、`/usr/local/bin`、版本管理运行库 `~/.local/share/`、命令遮挡关系（`which -a`） |
| **宿主扩展/内嵌工具** | VS Code / Cursor 等 IDE 的内部插件 | 检查 `~/Library/Application Support/<Host>/User/globalStorage/` 中的内嵌版本与执行日志 |
| **临时工具/证书生成器** | 绿色独立 DMG / 一次性生成工具 | 检查 `~/Downloads/` 下工具解压的凭证、历史压缩包及私钥导出文件夹 |

---

## 核心工作流与操作规程

### 第一步：运行状态与常驻服务审计（优先灭活）

在执行任何删除前，必须确保目标软件未在后台运行，防止删除中文件被占用或即刻重建：

1. **排查并终止活动进程**：
   ```bash
   ps aux | grep -i "<TargetName>" | grep -v grep
   ```
   *若存在活跃进程，优先提示或按 PID 正常终止。*

2. **审计开机自启项与守护服务**：
   ```bash
   ls -la ~/Library/LaunchAgents /Library/LaunchAgents /Library/LaunchDaemons 2>/dev/null | grep -i "<TargetName>"
   ```
   *若发现 `.plist` 守护文件，必须先执行 `launchctl unload <plist路径>` 卸载服务，再删除文件。*

---

### 第二步：全域定位本体与可执行入口

1. **定位 GUI 软件本体**：
   - 检查 `/Applications/<AppName>.app` 及 `~/Applications/<AppName>.app`
2. **定位 CLI 终端入口与版本库**：
   - 排查 `$PATH` 链接与遮挡：`which -a <command>`（检查移除后是否有同名工具显现）
   - 检查常见的用户层可执行目录：`~/.local/bin/`、`/usr/local/bin/`、`/opt/homebrew/bin/`
   - 检查工具的物理版本库：`~/.local/share/<ToolName>/`（经常占用数百 MB）

---

### 第三步：全盘深度扫描与隐藏副本挖掘

针对应用的英文名、Bundle Identifier（例如 `com.tencent.QQBrowser`）及常见中文别名展开全盘扫描，并使用 `du -sh` 统计可释放体积：

1. **用户资源库核心路径 (`~/Library/`)**：
   - **用户数据与扩展**：`~/Library/Application Support/<AppName>`
   - **离线与网页缓存**：`~/Library/Caches/<BundleID>` 或 `<AppName>`
   - **偏好设置配置文件**：`~/Library/Preferences/<BundleID>.plist`
   - **窗口与崩溃状态快照**：`~/Library/Saved Application State/<BundleID>.savedState`
   - **沙盒容器隔离区**：`~/Library/Containers/<BundleID>`、`~/Library/Group Containers/<GroupID>`
   - **网络会话与日志**：`~/Library/HTTPStorages/<BundleID>`、`~/Library/WebKit/<BundleID>`、`~/Library/Logs/<AppName>`

2. **宿主软件深层内嵌存储（常规工具盲区）**：
   - 排查 Electron / IDE 的全局插件私有缓存：
     `~/Library/Application Support/{Cursor,Code}/User/globalStorage/*<TargetName>*`
   - 检查编辑器内部日志目录中的历史会话调试包。

3. **用户根目录隐藏配置区**：
   - 检查 `~/.<ToolName>`（重点核对是否存有历史会话数据库、配置或计划文档）
   - 检查 `~/.config/<ToolName>`

4. **下载与临时文件区**：
   - 检查 `~/Downloads/*<TargetName>*`（工具生成导出的数据、解压包、DMG 镜像）
   - 检查 `/tmp/*<TargetName>*` 与 `/var/tmp/*<TargetName>*`

---

### 第四步：安全护栏与白名单过滤（铁律）

> [!CAUTION]
> **绝对禁止未审先删！在向用户汇报前必须严格过滤以下资产：**

1. **用户工程代码与工作空间隔离**：
   - 全盘搜索结果必须使用 `grep -v` 显式排除 `~/Documents/`、`~/Desktop/`、`~/Projects/`、`~/work-code/` 等用户源码目录。
   - 严禁误删工程项目中包含同名关键字的测试用例、SDK 包或开发文档。
2. **高敏感密钥与凭证安全提示**：
   - 发现 `.pem`、`.p12`、`cert.zip`、`id_rsa`、私钥或包含 API Key 的配置文件时，**必须在清单中单独标红并附带安全警告**，提示用户确认线上服务是否仍依赖该凭证。
3. **个人社交与系统原生数据保护**：
   - 严格区分软件本体残留与微信/QQ等社交客户端内接收到的历史聊天附件（如 `com.tencent.xinWeChat/Data/Documents/xwechat_files/...`）。

---

### 第五步：清单汇总与两阶段清理

1. **结构化向用户呈现清理报告**：
   - 清晰列出发现的所有文件/文件夹绝对路径。
   - 标注每一项的大小（如 `413 MB`、`224 MB`）与总计预计释放的空间。
   - 划分为：**【可安全清理项】**（纯运行缓存、废弃数据库）与 **【需人工确认项】**（历史计划文档、证书等）。
2. **在获得用户明确授权后，执行物理清除**：
   ```bash
   rm -rf <ConfirmedPaths>
   ```

---

### 第六步：交叉复查与验证闭环（确保 0 残留）

清理完成后，必须主动运行全套验证命令，输出最终确认报告：

1. **Spotlight 索引二次检索**：
   ```bash
   mdfind 'kMDItemFSName == "*<TargetName>*"c' 2>/dev/null | grep -v "/Documents/"
   ```
2. **命令有效性复查**：
   ```bash
   which -a <TargetCommand> 2>&1
   ```
3. **输出闭环结论**：明确向用户反馈已释放的总空间及系统当前状态。

---

## 必须检查的关键目录清单速查表

| 层级 | 检查目录路径 | 重点排查内容 |
| :--- | :--- | :--- |
| **入口与常驻** | `/Applications/*.app`、`~/Applications/*.app` | GUI 应用本体 |
| | `~/.local/bin/`、`/usr/local/bin/`、`/opt/homebrew/bin/` | CLI 可执行程序与软链接符号 |
| | `~/Library/LaunchAgents/`、`/Library/LaunchAgents/`、`/Library/LaunchDaemons/` | 开机自启项与后台常驻守护服务 |
| **应用支持库** | `~/Library/Application Support/<AppName>` | 核心应用数据、扩展插件、内部离线库 |
| | `~/Library/Caches/<BundleID 或 AppName>` | 网络与本地大体积缓存 |
| | `~/Library/Preferences/<BundleID>.plist` | 系统偏好设置参数与配置项 |
| | `~/Library/Saved Application State/<BundleID>.savedState` | 应用退出前的窗口与页面状态快照 |
| | `~/Library/Containers/<BundleID>` | macOS App 沙盒隔离运行目录 |
| | `~/Library/Group Containers/<GroupID>` | 跨应用共享数据容器 |
| | `~/Library/HTTPStorages/<BundleID>`、`WebKit/`、`Logs/` | 网络请求临时存储与运行错误日志 |
| **用户与环境** | `~/.<ToolName>/`、`~/.config/<ToolName>/` | 隐藏主配置目录、本地 SQLite 数据库 |
| | `~/.local/share/<ToolName>/` | 命令行工具实际二进制版本库（体积通常较大） |
| | `~/Downloads/` | 工具导出的私钥/证书文件、解压目录、DMG 镜像 |
| **深层盲区** | `~/Library/Application Support/{Cursor,Code}/User/globalStorage/` | IDE 宿主内部偷偷缓存的 Worker 或运行时副本 |

---

## 质量自检清单

- [ ] 是否在删除前排查并停止了后台常驻进程与自启守护（LaunchAgents）
- [ ] 是否检查了 CLI 符号链接、命令遮挡（`which -a`）与实际版本库（`~/.local/share/`）
- [ ] 是否挖掘了宿主 IDE / Electron 的全局内部缓存（globalStorage）
- [ ] 是否检查了 `~/Downloads/` 目录下工具导出的产物或解压包
- [ ] 是否绝对排除了用户工作目录中的开发源码（Documents/Projects）
- [ ] 是否对私钥、证书及敏感凭证进行了高危警告提示
- [ ] 是否在执行删除后完成了 Spotlight 与文件系统的二次复查验证
