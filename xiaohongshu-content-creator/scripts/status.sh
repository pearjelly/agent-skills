#!/bin/bash

# xiaohongshu-mcp 状态检查脚本
# 检查 MCP 服务运行状态

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${SCRIPT_DIR}/bin"
PID_FILE="${BIN_DIR}/xiaohongshu-mcp.pid"

echo "=========================================="
echo "  xiaohongshu-mcp 状态检查"
echo "=========================================="

# 检查是否安装
MCP_BIN="${BIN_DIR}/xiaohongshu-mcp"
if [ ! -f "$MCP_BIN" ]; then
    echo "状态: 未安装"
    echo "请运行: ./scripts/install.sh"
    exit 1
fi
echo "安装: 已安装"

# 检查进程状态
running=false
pid=""

if [ -f "$PID_FILE" ]; then
    pid=$(cat "$PID_FILE")
    if kill -0 "$pid" 2>/dev/null; then
        running=true
    fi
fi

# 如果 PID 文件没有进程，尝试查找
if [ "$running" = false ]; then
    pid=$(pgrep -f "xiaohongshu-mcp" 2>/dev/null | head -1 || true)
    if [ -n "$pid" ]; then
        running=true
    fi
fi

if [ "$running" = true ]; then
    echo "服务: 运行中 (PID: $pid)"
else
    echo "服务: 未运行"
fi

# 检查 HTTP 端口
echo ""
echo "检查 MCP 端口..."
if curl -s -o /dev/null -w "%{http_code}" "http://localhost:18060/mcp" 2>/dev/null | grep -q "200"; then
    echo "HTTP 服务: 可访问 (http://localhost:18060/mcp)"
else
    echo "HTTP 服务: 不可访问"
fi

echo ""
echo "如需启动服务: ./scripts/start.sh"
