#!/bin/bash

# xiaohongshu-content-creator 准备脚本
# 检查登录状态并启动 MCP 服务

set -e

# 获取脚本所在目录（支持从任意目录执行）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 如果第一个参数是目录，则使用它；否则使用脚本所在目录
if [ -n "$1" ] && [ -d "$1" ]; then
    WORK_DIR="$1"
else
    WORK_DIR="$SCRIPT_DIR"
fi

BIN_DIR="${WORK_DIR}/bin"
MCP_BIN="${BIN_DIR}/xiaohongshu-mcp"
LOGIN_BIN="${BIN_DIR}/xiaohongshu-login"
PID_FILE="${BIN_DIR}/xiaohongshu-mcp.pid"
COOKIES_FILE="${HOME}/.config/xiaohongshu/cookies.json"

echo "=========================================="
echo "  xiaohongshu-content-creator 准备脚本"
echo "=========================================="

# 检查 MCP 是否已安装
if [ ! -f "$MCP_BIN" ]; then
    echo "错误: xiaohongshu-mcp 未安装，请先运行 ./scripts/install.sh"
    exit 1
fi

# 检查登录二进制是否安装
if [ ! -f "$LOGIN_BIN" ]; then
    echo "错误: xiaohongshu-login 未安装，请先运行 ./scripts/install.sh"
    exit 1
fi

# 检查是否已登录
check_login() {
    if [ -f "$COOKIES_FILE" ] && [ -s "$COOKIES_FILE" ]; then
        return 0
    fi
    return 1
}

# 如果 MCP 已启动，直接返回
if [ -f "$PID_FILE" ]; then
    pid=$(cat "$PID_FILE" 2>/dev/null || echo "")
    if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
        echo "MCP 服务已在运行 (PID: $pid)"
        return 0 2>/dev/null || exit 0
    else
        rm -f "$PID_FILE"
    fi
fi

# 检查登录状态
if ! check_login; then
    echo ""
    echo "检测到未登录小红书，正在启动登录..."
    echo ""
    "$LOGIN_BIN"
    echo ""
fi

# 启动 MCP 服务
echo "启动 xiaohongshu-mcp 服务..."
"$MCP_BIN" &
echo $! > "$PID_FILE"
sleep 2

# 检查是否启动成功
if [ -f "$PID_FILE" ]; then
    pid=$(cat "$PID_FILE")
    if kill -0 "$pid" 2>/dev/null; then
        echo ""
        echo "=========================================="
        echo "  准备完成！"
        echo "=========================================="
        echo "MCP 服务地址: http://localhost:18060/mcp"
    else
        echo "错误: 启动失败"
        rm -f "$PID_FILE"
        exit 1
    fi
else
    echo "错误: 启动失败"
    exit 1
fi
