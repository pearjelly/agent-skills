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

# 下载并解压
download_and_extract() {
    local url="$1"
    local output_dir="$2"

    echo "下载: $url"
    local tmp_file="/tmp/xiaohongshu-mcp-$$.tar.gz"
    curl -fSL "$url" -o "$tmp_file"

    if [ $? -ne 0 ] || [ ! -s "$tmp_file" ]; then
        echo "下载失败: $url"
        rm -f "$tmp_file"
        exit 1
    fi

    tar -xzf "$tmp_file" -C "$output_dir"
    rm -f "$tmp_file"
    echo "解压完成"
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

    # 下载并解压 xiaohongshu-mcp
    local mcp_url="https://github.com/xpzouying/xiaohongshu-mcp/releases/download/${version}/xiaohongshu-mcp-${arch}.tar.gz"
    download_and_extract "$mcp_url" "$BIN_DIR"

    # 重命名为简单名称
    if [ -f "${BIN_DIR}/xiaohongshu-mcp-${arch}" ]; then
        mv "${BIN_DIR}/xiaohongshu-mcp-${arch}" "${BIN_DIR}/xiaohongshu-mcp"
    fi

    # 如果有单独的登录工具，也处理
    if [ -f "${BIN_DIR}/xiaohongshu-login-${arch}" ]; then
        mv "${BIN_DIR}/xiaohongshu-login-${arch}" "${BIN_DIR}/xiaohongshu-login"
    fi

    # 设置执行权限
    chmod +x "${BIN_DIR}/xiaohongshu-mcp" "${BIN_DIR}/xiaohongshu-login" 2>/dev/null || true
    echo "设置执行权限完成"

    # 清理可能的符号链接
    rm -f "${BIN_DIR}/xiaohongshu-mcp.sym" 2>/dev/null || true

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
