#!/bin/bash

# xiaohongshu-mcp 启动脚本
# 启动 MCP 服务

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${SCRIPT_DIR}/bin"
MCP_BIN="${BIN_DIR}/xiaohongshu-mcp"
PID_FILE="${BIN_DIR}/xiaohongshu-mcp.pid"

echo "=========================================="
echo "  xiaohongshu-mcp 启动脚本"
echo "=========================================="

# 检查是否已安装
if [ ! -f "$MCP_BIN" ]; then
    echo "错误: xiaohongshu-mcp 未安装，请先运行 ./scripts/install.sh"
    exit 1
fi

# 检查是否已启动
if [ -f "$PID_FILE" ]; then
    pid=$(cat "$PID_FILE")
    if kill -0 "$pid" 2>/dev/null; then
        echo "错误: xiaohongshu-mcp 已在运行 (PID: $pid)"
        exit 1
    else
        rm -f "$PID_FILE"
    fi
fi

# 启动 MCP 服务（无头模式）
echo "启动 xiaohongshu-mcp 服务..."
"$MCP_BIN" &

# 保存 PID
echo $! > "$PID_FILE"
sleep 2

# 检查是否启动成功
if kill -0 $(cat "$PID_FILE") 2>/dev/null; then
    echo ""
    echo "=========================================="
    echo "  启动成功！"
    echo "=========================================="
    echo ""
    echo "MCP 服务地址: http://localhost:18060/mcp"
    echo "注册到 Claude Code:"
    echo "  claude mcp add --transport http xiaohongshu-mcp http://localhost:18060/mcp"
    echo ""
else
    echo "错误: 启动失败"
    rm -f "$PID_FILE"
    exit 1
fi
