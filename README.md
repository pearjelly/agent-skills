# Agent Skills 项目

## 项目概述

这是一个用于存储和管理 AI 技能定义的仓库。每个技能都是一个独立的模块，包含特定的功能和操作流程，可以被 AI 助手调用以执行特定任务。

**项目类型：** 技能定义仓库（非代码项目）

**当前技能：**
- **xiaohongshu-content-creator**：小红书爆款笔记创作技能

## 目录结构

```
agent-skills/
├── xiaohongshu-content-creator/
│   ├── SKILL.md
│   └── scripts/
│       ├── install.sh      # 安装脚本
│       ├── login.sh        # 登录脚本
│       ├── start.sh        # 启动 MCP 服务
│       ├── stop.sh         # 停止 MCP 服务
│       ├── status.sh       # 状态检查脚本
│       └── bin/            # 二进制文件目录（git 忽略）
├── .gitignore
├── README.md
└── IFLOW.md
```

## 关键文件说明

### SKILL.md
每个技能目录下都有一个 `SKILL.md` 文件，定义了该技能的详细信息：

- **技能名称和描述**：技能的标识和功能说明
- **功能概述**：技能提供的主要功能列表
- **使用方式**：如何触发和使用该技能
- **操作流程**：详细的执行步骤
- **必备工具**：技能依赖的工具和 API
- **内容创作模板**：标准化的内容生成模板
- **示例对话**：使用场景示例
- **注意事项**：使用时的重要提醒

## 技能：xiaohongshu-content-creator

### 功能
这是一个完整的**小红书内容创作技能**，帮助用户完成从内容分析到发布的整个流程：

1. 搜索分析热门笔记
2. 总结爆款规律
3. 创作符合规律的内容
4. 发布笔记到小红书

### 核心能力
- **热门内容分析**：通过搜索高赞笔记，分析标题特点、内容结构、话题标签
- **爆款规律总结**：提取悬念式、数字式、情感式等标题模式
- **智能内容创作**：基于分析结果生成符合平台风格的笔记内容
- **多格式发布**：支持图文和视频两种内容格式

### 依赖工具
该技能依赖 `xiaohongshu-mcp` 工具集，包括：
- `list_feeds` - 获取首页动态
- `search_feeds` - 搜索热门内容
- `get_feed_detail` - 获取笔记详情
- `publish_content` - 发布图文
- `publish_with_video` - 发布视频
- `check_login_status` - 检查登录状态

**工具来源：** https://github.com/xpzouying/xiaohongshu-mcp

## 使用方法

### 安装和配置（xiaohongshu-content-creator）

1. **安装工具**
   ```bash
   cd xiaohongshu-content-creator
   ./scripts/install.sh
   ```

2. **登录小红书**
   ```bash
   ./scripts/login.sh
   ```

3. **启动 MCP 服务**
   ```bash
   ./scripts/start.sh
   ```

4. **注册到 Claude Code**
   ```bash
   claude mcp add --transport http xiaohongshu-mcp http://localhost:18060/mcp
   ```

5. **检查服务状态**
   ```bash
   ./scripts/status.sh
   ```

6. **停止服务**
   ```bash
   ./scripts/stop.sh
   ```

### 添加新技能
1. 创建新的技能目录
2. 在目录中创建 `SKILL.md` 文件
3. 按照 SKILL.md 的模板格式定义技能

### 使用现有技能
当用户需要使用某个技能时，可以通过以下方式触发：
- 使用技能名称命令（如 `/xiaohongshu-content-creator`）
- 描述相关需求（如"帮我发个小红书"、"创作一篇关于xxx的笔记"）

## 项目特点

- **模块化设计**：每个技能独立管理，互不影响
- **标准化格式**：所有技能使用统一的 SKILL.md 模板
- **可扩展性**：易于添加新的技能定义
- **文档驱动**：完整的技能说明和使用指南
- **自动化脚本**：提供安装、登录、启动、停止、状态检查等便捷脚本

## 脚本说明

### install.sh
自动检测系统架构并下载最新版本的 xiaohongshu-mcp 二进制文件。支持 macOS (arm64/amd64)、Linux (amd64) 和 Windows (amd64)。

### login.sh
启动浏览器进行小红书登录，认证信息保存在本地。

### start.sh
启动 MCP 服务（无头模式），默认监听端口 18060。

### stop.sh
停止正在运行的 MCP 服务。

### status.sh
检查 xiaohongshu-mcp 的安装状态和运行状态。

## Git 信息

- **远程仓库：** https://github.com/pearjelly/agent-skills.git
- **当前分支：** main
- **最新提交：** fa8c970 自动安装 xiaohonghu-mcp