#!/bin/bash

# xiaohongshu-mcp 停止脚本
# 停止 MCP 服务

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${SCRIPT_DIR}/bin"
PID_FILE="${BIN_DIR}/xiaohongshu-mcp.pid"

echo "=========================================="
echo "  xiaohongshu-mcp 停止脚本"
echo "=========================================="

# 检查 PID 文件
if [ ! -f "$PID_FILE" ]; then
    echo "未找到 PID 文件，尝试查找进程..."

    # 尝试查找进程
    pid=$(pgrep -f "xiaohongshu-mcp" 2>/dev/null || true)

    if [ -z "$pid" ]; then
        echo "xiaohongshu-mcp 未运行"
        exit 0
    fi

    echo "找到进程: $pid"
else
    pid=$(cat "$PID_FILE")

    # 检查进程是否存在
    if ! kill -0 "$pid" 2>/dev/null; then
        echo "进程已不存在，清理 PID 文件"
        rm -f "$PID_FILE"
        exit 0
    fi

    echo "停止进程: $pid"
    kill "$pid"
    rm -f "$PID_FILE"
fi

echo "停止完成"
