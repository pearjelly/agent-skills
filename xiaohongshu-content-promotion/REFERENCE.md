# 小红书推广技能 - API 参考

## 可用工具

本技能使用 `xiaohongshu-mcp` 提供的 MCP 工具：

### 搜索工具

#### search_feeds

搜索小红书内容。

**参数：**
```typescript
{
  keyword: string;      // 搜索关键词
  filters?: {
    sort_by?: "综合" | "最新" | "最多点赞" | "最多评论" | "最多收藏";
    publish_time?: "不限" | "一天内" | "一周内" | "半年内";
    note_type?: "不限" | "视频" | "图文";
    search_scope?: "不限" | "已看过" | "未看过" | "已关注";
    location?: "不限" | "同城" | "附近";
  };
}
```

**返回：**
```json
{
  "feeds": [
    {
      "id": "feed_id",
      "xsecToken": "访问令牌",
      "noteCard": {
        "displayTitle": "帖子标题",
        "user": { "nickname": "作者名" },
        "interactInfo": {
          "likedCount": "点赞数",
          "collectedCount": "收藏数",
          "commentCount": "评论数"
        }
      }
    }
  ],
  "count": 结果数量
}
```

### 内容获取工具

#### get_feed_detail

获取帖子详情。

**参数：**
```typescript
{
  feed_id: string;
  xsec_token: string;
  load_all_comments?: boolean;
  limit?: number;
  scroll_speed?: "slow" | "normal" | "fast";
  click_more_replies?: boolean;
  reply_limit?: number;
}
```

**返回：**
```json
{
  "data": {
    "note": {
      "noteId": "帖子ID",
      "xsecToken": "访问令牌",
      "title": "标题",
      "desc": "正文内容",
      "user": { "userId": "用户ID", "nickname": "昵称" },
      "interactInfo": { "likedCount": "...", "commentCount": "..." },
      "imageList": [{ "width": 1200, "height": 1600, "urlDefault": "..." }]
    },
    "comments": {
      "list": [...],
      "cursor": "分页游标",
      "hasMore": true/false
    }
  }
}
```

### 互动工具

#### post_comment_to_feed

在帖子下发表评论。

**参数：**
```typescript
{
  feed_id: string;
  xsec_token: string;
  content: string;  // 评论内容
}
```

**返回：**
```json
{
  "success": true,
  "message": "评论发表成功"
}
```

#### like_feed

点赞帖子。

```typescript
{ feed_id: string, xsec_token: string }
```

#### favorite_feed

收藏帖子。

```typescript
{ feed_id: string, xsec_token: string, unfavorite?: boolean }
```

### 登录管理工具

#### get_login_qrcode

获取登录二维码。

**返回：**
```json
{
  "qrcode": "base64图片",
  "expire_time": 有效期(秒)
}
```

#### check_login_status

检查登录状态。

#### delete_cookies

删除 cookies，重置登录状态。

## 数据结构

### 已评论帖子记录格式

```json
{
  "commented_posts": [
    {
      "feed_id": "帖子ID",
      "commented_at": "YYYY-MM-DD",
      "title": "帖子标题",
      "author": "作者昵称"
    }
  ],
  "failed_posts": [
    {
      "feed_id": "帖子ID",
      "reason": "失败原因",
      "title": "帖子标题",
      "author": "作者昵称"
    }
  ],
  "summary": {
    "total_commented": 16,
    "total_failed": 6,
    "last_updated": "2026-01-08"
  }
}
```

### 帖子筛选结果

```typescript
interface PostCandidate {
  id: string;
  xsecToken: string;
  title: string;
  author: string;
  likes: number;
  collects: number;
  comments: number;
  isNew: boolean;  // 是否未评论
}
```

## 错误处理

### 常见错误码

| 错误信息 | 原因 | 处理方式 |
|----------|------|----------|
| "笔记不可访问" | 帖子被删除/设为私密/作者限制了评论 | 跳过该帖子，记录到 failed_posts |
| "xsec_token 无效" | 令牌过期或无效 | 重新获取帖子详情获取新令牌 |
| "评论频繁" | 触发了平台限制 | 暂停片刻后重试 |
| "内容包含敏感词" | 评论内容违规 | 修改评论措辞 |

### 重试策略

1. **临时错误（网络抖动等）**：重试 1-2 次
2. **笔记不可访问**：跳过，不重试
3. **令牌失效**：重新获取详情后重试
