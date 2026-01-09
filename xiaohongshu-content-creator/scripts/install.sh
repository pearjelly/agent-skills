#!/bin/bash

# xiaohongshu-mcp 安装脚本
# 自动下载并配置 xiaohongshu-mcp 二进制文件

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${SCRIPT_DIR}/bin"
RELEASE_URL="https://github.com/xpzouying/xiaohongshu-mcp/releases/latest"

echo "=========================================="
echo "  xiaohongshu-mcp 安装脚本"
echo "=========================================="

# 检测系统架构
detect_arch() {
    local os=$(uname -s | tr '[:upper:]' '[:lower:]')
    local arch=$(uname -m)

    case "$os" in
        darwin*)
            if [ "$arch" = "arm64" ]; then
                echo "darwin-arm64"
            else
                echo "darwin-amd64"
            fi
            ;;
        linux*)
            echo "linux-amd64"
            ;;
        mingw*|cygwin*|msys*)
            echo "windows-amd64"
            ;;
        *)
            echo "不支持的系统: $os $arch"
            exit 1
            ;;
    esac
}

# 获取最新版本号
get_latest_version() {
    curl -sL -o /dev/null -w "%{url_effective}" "$RELEASE_URL" | sed 's/.*tag\///'
}

# 下载文件
download_file() {
    local url="$1"
    local output="$2"
    local version="$3"

    echo "下载: $url"
    curl -sL "$url" -o "$output"

    if [ $? -ne 0 ] || [ ! -s "$output" ]; then
        echo "下载失败: $url"
        exit 1
    fi
}

# 主安装逻辑
main() {
    local arch=$(detect_arch)
    echo "检测到系统架构: $arch"

    # 创建 bin 目录
    mkdir -p "$BIN_DIR"
    echo "安装目录: $BIN_DIR"

    # 获取最新版本
    echo "获取最新版本..."
    local version=$(get_latest_version)
    echo "最新版本: $version"

    # 下载 xiaohongshu-mcp
    local mcp_url="https://github.com/xpzouying/xiaohongshu-mcp/releases/download/${version}/xiaohongshu-mcp-${arch}"
    local mcp_bin="${BIN_DIR}/xiaohongshu-mcp"
    download_file "$mcp_url" "$mcp_bin" "$version"

    # 下载 xiaohongshu-login
    local login_url="https://github.com/xpzouying/xiaohongshu-mcp/releases/download/${version}/xiaohongshu-login-${arch}"
    local login_bin="${BIN_DIR}/xiaohongshu-login"
    download_file "$login_url" "$login_bin" "$version"

    # 设置执行权限
    chmod +x "$mcp_bin" "$login_bin"
    echo "设置执行权限完成"

    echo ""
    echo "=========================================="
    echo "  安装完成！"
    echo "=========================================="
    echo ""
    echo "下一步操作:"
    echo "1. 登录小红书: ./scripts/login.sh"
    echo "2. 启动 MCP:   ./scripts/start.sh"
    echo "3. 注册到 Claude Code:"
    echo "   claude mcp add --transport http xiaohongshu-mcp http://localhost:18060/mcp"
    echo ""
}

main
