# Agent Skills 项目

## 项目概述

这是一个用于存储和管理 AI 技能定义的仓库。每个技能都是一个独立的模块，包含特定的功能和操作流程，可以被 AI 助手调用以执行特定任务。

**项目类型：** 技能定义仓库（非代码项目）

**当前技能：**
- **xiaohongshu-content-creator**：小红书爆款笔记创作技能
- **xiaohongshu-content-promotion**：小红书内容推广技能

## 目录结构

```
agent-skills/
├── xiaohongshu-content-creator/
│   ├── SKILL.md
│   └── scripts/
│       ├── install.sh      # 安装脚本
│       ├── login.sh        # 登录脚本
│       ├── prepare.sh      # 准备脚本（自动登录并启动 MCP）
│       ├── start.sh        # 启动 MCP 服务
│       ├── stop.sh         # 停止 MCP 服务
│       ├── status.sh       # 状态检查脚本
│       └── bin/            # 二进制文件目录（git 忽略）
├── xiaohongshu-content-promotion/
│   ├── SKILL.md            # 技能定义文件
│   ├── EXAMPLES.md         # 使用示例
│   └── REFERENCE.md        # API 参考文档
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
这是一个完整的**小红书爆款笔记创作技能**，通过深度分析热门内容，总结爆款规律，创作符合平台风格的高质量笔记：

1. 搜索并深度分析热门笔记（获取前3-5篇高赞笔记的完整内容）
2. 系统总结爆款规律（标题公式、开头钩子、内容结构、emoji使用、结尾互动等）
3. 基于分析结果创作内容（严格遵循发现的规律）
4. 发布笔记到小红书

### 核心能力
- **深度内容分析**：必须获取前3-5篇高赞笔记的详细内容（包括正文、图片/视频、评论），而非仅搜索标题
- **数据驱动创作**：基于真实数据分析标题公式、开头钩子、内容结构、emoji使用习惯、结尾互动方式
- **规律总结展示**：在创作前向用户展示完整的爆款规律分析结果，等待确认后继续
- **严格遵循规律**：创作内容必须套用发现的标题公式、模仿内容结构、参考段落节奏和emoji使用习惯
- **多格式发布**：支持图文和视频两种内容格式

### 核心原则
- **绝对禁止**不获取详细内容就直接创作
- 必须用 `get_feed_detail` 分析至少3篇高赞笔记
- 分析结果必须展示给用户看
- 创作内容必须严格遵循发现的规律
- 不要凭感觉创作，要用数据驱动

### 依赖工具
该技能依赖 `xiaohongshu-mcp` 工具集，包括：
- `check_login_status` - 检查登录状态
- `search_feeds` - 搜索热门内容（第一步）
- `get_feed_detail` - 获取笔记详情（关键步骤！必须获取前3-5篇高赞笔记的详细内容）
- `publish_content` - 发布图文
- `publish_with_video` - 发布视频

**工具来源：** https://github.com/xpzouying/xiaohongshu-mcp

## 技能：xiaohongshu-content-promotion

### 功能
这是一个**小红书内容推广技能**，通过在相关热门帖子下发布有针对性的评论，引导用户了解和使用推广的产品或服务。

1. 搜索相关热门帖子
2. 筛选未评论的高质量帖子
3. 根据帖子内容撰写个性化评论
4. 发布评论并记录结果

### 核心能力
- **精准搜索**：通过关键词和筛选条件找到目标用户聚集的内容
- **智能筛选**：过滤已评论帖子，避免重复推广
- **个性化评论**：根据帖子内容和场景撰写自然、有价值的评论
- **记录管理**：自动记录已评论和失败的帖子，便于追踪效果

### 使用场景
- 推广微信小程序、APP、产品服务等
- 在目标用户聚集的内容下方进行软性推广
- 需要在评论区进行精准营销的场景

### 依赖工具
该技能依赖 `xiaohongshu-mcp` 工具集，包括：
- `search_feeds` - 搜索热门内容
- `get_feed_detail` - 获取帖子详情
- `post_comment_to_feed` - 发表评论
- `like_feed` - 点赞帖子
- `favorite_feed` - 收藏帖子
- `check_login_status` - 检查登录状态

**工具来源：** https://github.com/xpzouying/xiaohongshu-mcp

### 文档资源
- **SKILL.md**：技能定义和详细操作流程
- **EXAMPLES.md**：实际使用示例和最佳实践
- **REFERENCE.md**：API 工具参考和数据结构说明

## 使用方法

### 安装和配置（xiaohongshu-content-creator）

1. **安装工具**
   ```bash
   cd xiaohongshu-content-creator
   ./scripts/install.sh
   ```

2. **首次准备（登录并启动 MCP）**
   ```bash
   cd ~/.claude/skills/xiaohongshu-content-creator && ./scripts/prepare.sh
   ```
   此脚本会自动检查登录状态，未登录则启动登录流程，然后启动 MCP 服务。

3. **注册到 Claude Code**
   ```bash
   claude mcp add --transport http xiaohongshu-mcp http://localhost:18060/mcp
   ```

4. **检查服务状态**
   ```bash
   ./scripts/status.sh
   ```

5. **停止服务**
   ```bash
   ./scripts/stop.sh
   ```

### 使用 xiaohongshu-content-promotion

该技能需要先完成 xiaohongshu-mcp 的安装和配置（参考上述步骤），然后：

1. **准备推广信息**
   - 确定要推广的产品/服务名称和特点
   - 准备已评论记录文件（JSON 格式，避免重复评论）

2. **搜索相关帖子**
   - 使用 `search_feeds` 工具搜索与产品相关的热门内容
   - 设置合适的筛选条件（如"最多收藏"、"半年内"）

3. **筛选和评论**
   - 读取已评论记录，过滤掉已处理的帖子
   - 根据帖子内容撰写个性化评论
   - 使用 `post_comment_to_feed` 发表评论

4. **更新记录**
   - 将新评论的帖子信息添加到记录文件
   - 记录失败的帖子及原因

详细流程请参考 `xiaohongshu-content-promotion/SKILL.md`。

### 添加新技能
1. 创建新的技能目录
2. 在目录中创建 `SKILL.md` 文件
3. 按照 SKILL.md 的模板格式定义技能

### 使用现有技能
当用户需要使用某个技能时，可以通过以下方式触发：
- 使用技能名称命令（如 `/xiaohongshu-content-creator`）
- 描述相关需求（如"帮我发个小红书"、"创作一篇关于xxx的笔记"、"在小红书上推广xxx产品"）

## 项目特点

- **模块化设计**：每个技能独立管理，互不影响
- **标准化格式**：所有技能使用统一的 SKILL.md 模板
- **可扩展性**：易于添加新的技能定义
- **文档驱动**：完整的技能说明和使用指南
- **自动化脚本**：提供安装、登录、启动、停止、状态检查等便捷脚本
- **多场景覆盖**：涵盖内容创作和内容推广两大场景
- **详细示例**：提供实际使用案例和 API 参考文档
- **数据驱动**：xiaohongshu-content-creator 技能强调深度分析和数据驱动，通过获取高赞笔记的详细内容来总结爆款规律，确保创作质量

## 脚本说明

### prepare.sh
一键准备脚本，自动检查登录状态并启动 MCP 服务：
- 检查是否已登录，未登录则启动登录流程
- 启动 xiaohongshu-mcp 服务
- 首次使用前请先运行此脚本

```bash
cd ~/.claude/skills/xiaohongshu-content-creator && ./scripts/prepare.sh
```

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
- **最新提交：** 2272e71 更新项目文档