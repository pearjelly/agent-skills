#!/bin/bash

# xiaohongshu-login 登录脚本
# 通过浏览器登录小红书获取认证

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${SCRIPT_DIR}/bin"
LOGIN_BIN="${BIN_DIR}/xiaohongshu-login"

echo "=========================================="
echo "  xiaohongshu-login 登录脚本"
echo "=========================================="

# 检查是否已安装
if [ ! -f "$LOGIN_BIN" ]; then
    echo "错误: xiaohongshu-login 未安装，请先运行 ./scripts/install.sh"
    exit 1
fi

echo ""
echo "此脚本将启动浏览器进行小红书登录"
echo "登录成功后，认证信息将保存在本地"
echo ""
echo "按 Enter 开始登录..."
read -r

# 启动登录程序（自动打开浏览器）
"$LOGIN_BIN"

echo ""
echo "=========================================="
echo "  登录完成！"
echo "=========================================="
echo ""
echo "现在可以启动 MCP 服务: ./scripts/start.sh"
