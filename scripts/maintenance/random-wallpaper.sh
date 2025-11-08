#!/bin/bash

# 随机壁纸切换脚本
# 每300秒（5分钟）自动切换壁纸

set -euo pipefail

# 使用环境变量或默认路径
WALLPAPER_DIR="${NIRI_DOT_ASSETS:-$HOME/Niri-Dot/assets}/wallpaper"
INTERVAL=300  # 300秒 = 5分钟

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

print_error() {
    print_message $RED "❌ $1"
}

print_success() {
    print_message $GREEN "✅ $1"
}

print_info() {
    print_message $YELLOW "ℹ️  $1"
}

# 检查依赖
check_dependencies() {
    local missing_deps=()

    if ! command -v swww &> /dev/null; then
        missing_deps+=("swww")
    fi

    if ! command -v find &> /dev/null; then
        missing_deps+=("find")
    fi

    if ! command -v shuf &> /dev/null; then
        missing_deps+=("shuf")
    fi

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_error "缺少依赖: ${missing_deps[*]}"
        print_info "请安装缺少的依赖后重试"
        exit 1
    fi
}

# 检查壁纸目录
check_wallpaper_directory() {
    if [[ ! -d "$WALLPAPER_DIR" ]]; then
        print_error "壁纸目录不存在: $WALLPAPER_DIR"
        print_info "请检查环境变量 NIRI_DOT_ASSETS 或创建壁纸目录"
        exit 1
    fi

    local wallpaper_count=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | wc -l)
    if ((wallpaper_count == 0)); then
        print_error "壁纸目录中未找到图片文件: $WALLPAPER_DIR"
        print_info "请添加 .jpg 或 .png 格式的壁纸文件"
        exit 1
    fi

    print_success "找到 $wallpaper_count 个壁纸文件"
}

# 优雅退出处理
cleanup() {
    print_info "收到退出信号，正在清理..."
    exit 0
}

# 设置信号处理
trap cleanup SIGINT SIGTERM

# 主函数
main() {
    print_info "随机壁纸切换脚本启动"
    print_info "壁纸目录: $WALLPAPER_DIR"
    print_info "切换间隔: ${INTERVAL}秒"

    # 检查依赖
    check_dependencies

    # 检查壁纸目录
    check_wallpaper_directory

    # 检查swww是否运行
    if ! pgrep -x "swww-daemon" > /dev/null; then
        print_info "启动 swww-daemon..."
        if ! swww-daemon; then
            print_error "无法启动 swww-daemon"
            exit 1
        fi
        sleep 2
    fi

    print_success "开始随机壁纸切换，按 Ctrl+C 停止"

    while true; do
        # 随机选择一张壁纸
        local wallpaper
        if ! wallpaper=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | shuf -n 1); then
            print_error "无法读取壁纸文件列表"
            exit 1
        fi

        if [[ -n "$wallpaper" && -f "$wallpaper" ]]; then
            print_info "切换到壁纸: $(basename "$wallpaper")"

            # 使用平滑过渡效果设置壁纸
            if ! swww img "$wallpaper" --transition-type center --transition-fps 60 --transition-step 2; then
                print_error "设置壁纸失败: $wallpaper"
                # 继续运行，不退出
            else
                print_success "壁纸设置成功"
            fi
        else
            print_error "选择的壁纸文件无效: $wallpaper"
        fi

        # 等待指定时间
        sleep $INTERVAL
    done
}

# 运行主函数
main "$@"