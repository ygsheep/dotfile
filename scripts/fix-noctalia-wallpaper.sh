#!/usr/bin/env bash

# Noctalia 壁纸模糊修复脚本
# 解决 Noctalia shell 壁纸模糊问题

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

print_header() {
    clear
    echo "████████████████████████████████████████████████"
    echo "█                                                      █"
    echo "█         Noctalia 壁纸模糊修复工具                         █"
    echo "█                                                      █"
    echo "████████████████████████████████████████████████"
    echo ""
}

# 检查当前配置
check_current_config() {
    print_message $BLUE "=== 当前 Noctalia 壁纸配置 ==="
    echo ""

    if [ -f ~/.config/noctalia/settings.json ]; then
        print_message $GREEN "✓ 找到配置文件: ~/.config/noctalia/settings.json"

        # 显示相关配置
        echo "当前壁纸配置："
        jq -r '.wallpaper | to_entries[] | "Key: \(.key), Value: \(.value)"' ~/.config/noctalia/settings.json 2>/dev/null || print_message $YELLOW "⚠ 无法解析配置"
        echo ""

        # 显示缩放比例
        local scale=$(jq -r '.general.scaleRatio // "未知"' ~/.config/noctalia/settings.json 2>/dev/null)
        print_message $BLUE "当前缩放比例: $scale"

        # 显示填充模式
        local fillmode=$(jq -r '.wallpaper.fillMode // "未知"' ~/.config/noctalia/settings.json 2>/dev/null)
        print_message $BLUE "当前填充模式: $fillmode"

        # 显示壁纸路径
        local wallpaper=$(jq -r '.wallpaper.defaultWallpaper // "未设置"' ~/.config/noctalia/settings.json 2>/dev/null)
        print_message $BLUE "当前壁纸: $wallpaper"

        # 检查壁纸文件是否存在
        if [ -n "$wallpaper" ] && [ -f "$wallpaper" ]; then
            print_message $GREEN "✓ 壁纸文件存在"

            # 显示壁纸分辨率
            local resolution=$(identify "$wallpaper" 2>/dev/null | awk '{print $3}' || echo "无法获取")
            print_message $BLUE "壁纸分辨率: $resolution"
        else
            print_message $RED "✗ 壁纸文件不存在"
        fi
    else
        print_message $RED "✗ Noctalia 配置文件不存在"
        return 1
    fi
    echo ""
}

# 检查显示器信息
check_display_info() {
    print_message $BLUE "=== 显示器信息 ==="
    echo ""

    # 使用 Wayland 命令获取显示器信息
    if command -v wlr-randr &> /dev/null; then
        print_message $GREEN "使用 wlr-randr 检查显示器:"
        wlr-randr 2>/dev/null | grep -E "(current|Output)" || print_message $YELLOW "⚠ 无法获取显示器信息"
    elif command -v kanshi &> /dev/null; then
        print_message $GREEN "使用 kanshi 检查显示器:"
        kanshi --current 2>/dev/null || print_message $YELLOW "⚠ 无法获取显示器信息"
    else
        print_message $YELLOW "⚠ 没有找到显示器信息工具"
        print_message $BLUE "安装工具: nix-shell -p wlr-randr 或 nix-shell -p kanshi"
    fi

    # 检查环境变量
    print_message $BLUE "当前显示环境变量:"
    echo "WAYLAND_DISPLAY: $WAYLAND_DISPLAY"
    echo "XDG_CURRENT_DESKTOP: $XDG_CURRENT_DESKTOP"
    echo ""
}

# 方案 1: 重置缩放比例
fix_scale_ratio() {
    print_message $BLUE "=== 方案 1: 重置缩放比例 ==="
    echo ""

    local backup_file="$HOME/.config/noctalia/settings.json.backup.$(date +%Y%m%d_%H%M%S)"

    print_message $YELLOW "备份当前配置到: $backup_file"
    cp ~/.config/noctalia/settings.json "$backup_file"

    # 重置缩放比例为 1.0
    jq '.general.scaleRatio = 1.0' ~/.config/noctalia/settings.json > ~/.config/noctalia/settings.json.tmp
    mv ~/.config/noctalia/settings.json.tmp ~/.config/noctalia/settings.json

    print_message $GREEN "✓ 已将缩放比例重置为 1.0"
    echo ""
}

# 方案 2: 修改填充模式
fix_fill_mode() {
    print_message $BLUE "=== 方案 2: 修改填充模式 ==="
    echo ""

    local backup_file="$HOME/.config/noctalia/settings.json.backup.$(date +%Y%m%d_%H%M%S)"

    print_message $YELLOW "备份当前配置到: $backup_file"
    cp ~/.config/noctalia/settings.json "$backup_file"

    # 修改填充模式为 scale
    jq '.wallpaper.fillMode = "scale"' ~/.config/noctalia/settings.json > ~/.config/noctalia/settings.json.tmp
    mv ~/.config/noctalia/settings.json.tmp ~/.config/noctalia/settings.json

    print_message $GREEN "✓ 已将填充模式改为 scale（等比例缩放）"
    echo ""
}

# 方案 3: 优化壁纸分辨率
optimize_wallpaper() {
    print_message $BLUE "=== 方案 3: 优化壁纸分辨率 ==="
    echo ""

    local wallpaper_dir="$HOME/.dotfile/assets/wallpaper"
    local original_wallpaper="$wallpaper_dir/wallhaven-pkwxxm_3840x2160.png"
    local optimized_wallpaper="$wallpaper_dir/wallhaven-pkwxxm_optimized.png"

    if [ -f "$original_wallpaper" ]; then
        print_message $BLUE "优化壁纸分辨率..."

        # 获取显示器分辨率（如果可能）
        local display_width="${1:-1920}"
        local display_height="${2:-1080}"

        print_message $YELLOW "假设显示器分辨率: ${display_width}x${display_height}"

        # 使用 ImageMagick 优化壁纸
        if command -v convert &> /dev/null; then
            convert "$original_wallpaper" -resize "${display_width}x${display_height}^" -quality 95 "$optimized_wallpaper"
            print_message $GREEN "✓ 已创建优化壁纸: $optimized_wallpaper"

            # 更新配置中的壁纸路径
            local backup_file="$HOME/.config/noctalia/settings.json.backup.$(date +%Y%m%d_%H%M%S)"
            cp ~/.config/noctalia/settings.json "$backup_file"

            jq --argjson wallpaper "$optimized_wallpaper" '.wallpaper.defaultWallpaper = $wallpaper' ~/.config/noctalia/settings.json > ~/.config/noctalia/settings.json.tmp
            mv ~/.config/noctalia/settings.json.tmp ~/.config/noctalia/settings.json

            print_message $GREEN "✓ 已更新配置中的壁纸路径"
        else
            print_message $RED "✗ 需要安装 ImageMagick"
            print_message $BLUE "安装命令: nix-shell -p imagemagick"
        fi
    else
        print_message $RED "✗ 原始壁纸文件不存在: $original_wallpaper"
    fi
    echo ""
}

# 方案 4: 禁用模糊效果
disable_blur() {
    print_message $BLUE "=== 方案 4: 禁用模糊效果 ==="
    echo ""

    local backup_file="$HOME/.config/noctalia/settings.json.backup.$(date +%Y%m%d_%H%M%S)"

    print_message $YELLOW "备份当前配置到: $backup_file"
    cp ~/.config/noctalia/settings.json "$backup_file"

    # 检查并禁用模糊相关设置
    if jq -e '.general.enableShadows' ~/.config/noctalia/settings.json &>/dev/null; then
        jq '.general.enableShadows = false' ~/.config/noctalia/settings.json > ~/.config/noctalia/settings.json.tmp
        mv ~/.config/noctalia/settings.json.tmp ~/.config/noctalia/settings.json
        print_message $GREEN "✓ 已禁用阴影效果"
    else
        print_message $BLUE "未找到阴影效果设置"
    fi

    # 检查并调整动画速度
    if jq -e '.general.animationSpeed' ~/.config/noctalia/settings.json &>/dev/null; then
        jq '.general.animationSpeed = 0.5' ~/.config/noctalia/settings.json > ~/.config/noctalia/settings.json.tmp
        mv ~/.config/noctalia/settings.json.tmp ~/.config/noctalia/settings.json
        print_message $GREEN "✓ 已降低动画速度到 0.5"
    else
        print_message $BLUE "未找到动画速度设置"
    fi
    echo ""
}

# 重启 Noctalia 服务
restart_noctalia() {
    print_message $BLUE "=== 重启 Noctalia 服务 ==="
    echo ""

    print_message $YELLOW "重启 Noctalia 服务..."
    systemctl --user restart noctalia-shell

    print_message $GREEN "✓ Noctalia 服务已重启"
    print_message $BLUE "请等待几秒钟让壁纸生效"
    echo ""
}

# 主菜单
main_menu() {
    print_header
    check_current_config
    check_display_info

    print_message $CYAN "请选择修复方案："
    echo ""
    echo "1) 🔧 重置缩放比例为 1.0（推荐）"
    echo "2) 🖼️ 修改填充模式为 scale（等比例）"
    echo "3) 📏 优化壁纸分辨率匹配显示器"
    echo "4) 🚫 禁用模糊和动画效果"
    echo "5) 🔄 应用所有修复"
    echo "6) 📋 仅查看当前配置"
    echo "0) 🚪 退出"
    echo ""
    read -p "请输入选择 [0-6]: " choice

    case $choice in
        1)
            fix_scale_ratio
            restart_noctalia
            ;;
        2)
            fix_fill_mode
            restart_noctalia
            ;;
        3)
            optimize_wallpaper
            restart_noctalia
            ;;
        4)
            disable_blur
            restart_noctalia
            ;;
        5)
            print_message $BLUE "应用所有修复方案..."
            fix_scale_ratio
            fix_fill_mode
            optimize_wallpaper
            disable_blur
            restart_noctalia
            ;;
        6)
            check_current_config
            check_display_info
            ;;
        0)
            print_message $YELLOW "退出程序"
            exit 0
            ;;
        *)
            print_message $RED "无效选择，请重试"
            sleep 1
            main_menu
            ;;
    esac

    echo ""
    print_message $GREEN "修复完成！"
    print_message $BLUE "如果壁纸仍然模糊，请："
    echo "1. 检查壁纸文件的原始分辨率"
    echo "2. 尝试不同的填充模式（scale, fit, center）"
    echo "3. 调整显示器的缩放设置"
    echo "4. 重启 Noctalia 服务: systemctl --user restart noctalia-shell"
}

# 主函数
main() {
    main_menu
}

# 运行主函数
main "$@"