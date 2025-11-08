#!/usr/bin/env bash

# SDDM Astronaut Theme 安装脚本 for Niri-Dot
# 这个脚本会自动下载和配置 sddm-astronaut-theme

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

print_header() {
    echo "========================================"
    echo "    SDDM Astronaut Theme 安装器"
    echo "           for Niri-Dot"
    echo "========================================"
}

# 检查是否为 root 用户
check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_message $RED "错误：此脚本需要 root 权限运行"
        print_message $YELLOW "请使用: sudo $0"
        exit 1
    fi
}

# 检查 SDDM 是否已安装
check_sddm() {
    if ! command -v sddm &> /dev/null; then
        print_message $RED "错误：SDDM 未安装"
        print_message $YELLOW "请确保 SDDM 已在你的 NixOS 配置中启用"
        exit 1
    fi
    print_message $GREEN "✓ SDDM 已安装"
}

# 安装依赖
install_dependencies() {
    print_message $BLUE "正在检查 Qt6 依赖..."
    
    # 检查必要的 Qt6 包
    local missing_deps=()
    
    for pkg in qtsvg qtvirtualkeyboard qtmultimedia; do
        if ! nix-instantiate --eval --expr 'with import <nixpkgs> {}; builtins.hasAttr "'$pkg'" pkgs.qt6' 2>/dev/null | grep -q "true"; then
            missing_deps+=("$pkg")
        fi
    done
    
    if [ ${#missing_deps[@]} -eq 0 ]; then
        print_message $GREEN "✓ 所有 Qt6 依赖已满足"
    else
        print_message $YELLOW "缺少以下 Qt6 依赖: ${missing_deps[*]}"
        print_message $YELLOW "请确保在你的 NixOS 配置中包含这些包"
    fi
}

# 下载和安装主题
install_theme() {
    print_message $BLUE "正在下载 SDDM Astronaut Theme..."
    
    local theme_dir="/usr/share/sddm/themes/sddm-astronaut-theme"
    
    # 创建主题目录
    mkdir -p "$theme_dir"
    
    # 下载主题
    if command -v curl &> /dev/null; then
        curl -fsSL https://github.com/Keyitdev/sddm-astronaut-theme/archive/refs/heads/master.tar.gz | tar -xz -C "$(dirname "$theme_dir")"
    elif command -v wget &> /dev/null; then
        wget -qO- https://github.com/Keyitdev/sddm-astronaut-theme/archive/refs/heads/master.tar.gz | tar -xz -C "$(dirname "$theme_dir")"
    else
        print_message $RED "错误：需要 curl 或 wget 来下载主题"
        exit 1
    fi
    
    # 移动解压后的文件到正确位置
    if [ -d "$(dirname "$theme_dir")/sddm-astronaut-theme-master" ]; then
        mv "$(dirname "$theme_dir")/sddm-astronaut-theme-master"/* "$theme_dir/"
        rmdir "$(dirname "$theme_dir")/sddm-astronaut-theme-master"
    fi
    
    print_message $GREEN "✓ 主题下载完成"
}

# 安装字体
install_fonts() {
    print_message $BLUE "正在安装主题字体..."
    
    local theme_dir="/usr/share/sddm/themes/sddm-astronaut-theme"
    
    if [ -d "$theme_dir/Fonts" ]; then
        # 复制字体到系统字体目录
        mkdir -p /usr/share/fonts/sddm-astronaut
        cp -r "$theme_dir/Fonts/"* /usr/share/fonts/sddm-astronaut/
        
        # 更新字体缓存
        fc-cache -f -v
        
        print_message $GREEN "✓ 字体安装完成"
    else
        print_message $YELLOW "警告：未找到字体目录，可能需要手动安装字体"
    fi
}

# 配置 SDDM
configure_sddm() {
    print_message $BLUE "正在配置 SDDM..."
    
    # 备份原有配置
    if [ -f /etc/sddm.conf ]; then
        cp /etc/sddm.conf /etc/sddm.conf.backup.$(date +%Y%m%d_%H%M%S)
        print_message $GREEN "✓ 原配置已备份"
    fi
    
    # 创建或更新 SDDM 配置
    cat > /etc/sddm.conf << EOF
[Autologin]
# Relogin after logout
Relogin=false
# Autologin session
Session=

[General]
# Halt command
HaltCommand=/run/current-system/sw/bin/systemctl poweroff
# Reboot command
RebootCommand=/run/current-system/sw/bin/systemctl reboot
# Initial NumLock state
Numlock=none

[Theme]
# Current theme name
Current=sddm-astronaut-theme
# Cursor theme
CursorTheme=
# Font
Font=
# Background color
BackgroundColor=
# Face icon place
FacesDir=
# Theme directory path
ThemeDir=/usr/share/sddm/themes

[Users]
# Hide users
HideUsers=
# Hide shells
HideShells=
# Maximum uid
MaximumUid=60000
# Minimum uid
MinimumUid=1000

[X11]
# Display server command
DisplayCommand=/etc/sddm/Xsetup
# Display server stop command
DisplayStopCommand=/etc/sddm/Xstop
# Minimum VT
MinimumVT=1
# SDDM Xauth path
XauthPath=/run/sddm/xauth

[Wayland]
# Enable Wayland support
Enable=true
# Session command
SessionCommand=/etc/sddm/WaylandSession
# Session directory
SessionDir=/run/current-system/sw/share/wayland-sessions
EOF

    # 创建虚拟键盘配置
    mkdir -p /etc/sddm.conf.d
    cat > /etc/sddm.conf.d/virtualkbd.conf << EOF
[General]
InputMethod=qtvirtualkeyboard
EOF

    print_message $GREEN "✓ SDDM 配置完成"
}

# 设置文件权限
set_permissions() {
    print_message $BLUE "正在设置文件权限..."
    
    local theme_dir="/usr/share/sddm/themes/sddm-astronaut-theme"
    
    # 设置主题目录权限
    chmod -R 755 "$theme_dir"
    
    # 确保脚本文件可执行
    find "$theme_dir" -name "*.sh" -exec chmod +x {} \;
    
    print_message $GREEN "✓ 文件权限设置完成"
}

# 重启 SDDM 服务
restart_sddm() {
    print_message $BLUE "正在重启 SDDM 服务..."
    
    if systemctl is-active --quiet sddm; then
        systemctl restart sddm
        print_message $GREEN "✓ SDDM 服务已重启"
    else
        systemctl enable sddm --now
        print_message $GREEN "✓ SDDM 服务已启用"
    fi
}

# 验证安装
verify_installation() {
    print_message $BLUE "正在验证安装..."
    
    local theme_dir="/usr/share/sddm/themes/sddm-astronaut-theme"
    
    # 检查主题文件
    if [ -f "$theme_dir/metadata.desktop" ] && [ -f "$theme_dir/theme.conf" ]; then
        print_message $GREEN "✓ 主题文件完整"
    else
        print_message $RED "✗ 主题文件不完整"
        return 1
    fi
    
    # 检查 SDDM 配置
    if grep -q "Current=sddm-astronaut-theme" /etc/sddm.conf; then
        print_message $GREEN "✓ SDDM 配置正确"
    else
        print_message $RED "✗ SDDM 配置可能有误"
        return 1
    fi
    
    return 0
}

# 显示使用提示
show_usage_tips() {
    print_message $BLUE "使用提示："
    echo ""
    echo "1. 🎨 主题已配置为 'astronaut' 默认样式"
    echo "   你可以编辑 /usr/share/sddm/themes/sddm-astronaut-theme/metadata.desktop"
    echo "   来更改主题样式（black_hole, cyberpunk, japanese_aesthetic 等）"
    echo ""
    echo "2. ⌨️  虚拟键盘已启用，可在登录界面点击键盘图标使用"
    echo ""
    echo "3. 🔄 如需切换其他主题："
    echo "   sudo nano /etc/sddm.conf"
    echo "   # 修改 Current=your-theme-name"
    echo "   sudo systemctl restart sddm"
    echo ""
    echo "4. 🎯 预览主题（测试模式）："
    echo "   sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/sddm-astronaut-theme/"
    echo ""
    echo "5. 🎨 更多主题样式请参考："
    echo "   https://github.com/Keyitdev/sddm-astronaut-theme"
    echo ""
    print_message $GREEN "安装完成！重启后即可看到新的 SDDM 主题。"
}

# 主函数
main() {
    print_header
    
    check_root
    check_sddm
    install_dependencies
    
    print_message $BLUE "开始安装 SDDM Astronaut Theme..."
    echo ""
    
    install_theme
    install_fonts
    configure_sddm
    set_permissions
    
    if verify_installation; then
        restart_sddm
        show_usage_tips
    else
        print_message $RED "安装验证失败，请检查日志"
        exit 1
    fi
}

# 运行主函数
main "$@"