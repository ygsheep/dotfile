#!/usr/bin/env bash

# SDDM Astronaut 视频壁纸设置脚本
# 这个脚本帮助你轻松设置视频或 GIF 壁纸

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 配置
THEME_DIR="/usr/share/sddm/themes/sddm-astronaut-theme"
BACKGROUNDS_DIR="$THEME_DIR/Backgrounds"
CONFIG_DIR="$THEME_DIR/Themes"

# 打印带颜色的消息
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

print_header() {
    clear
    echo "████████████████████████████████████████████████████████"
    echo "█                                                      █"
    echo "█         SDDM Astronaut 视频壁纸设置器              █"
    echo "█                                                      █"
    echo "█  为你的登录界面添加动态视频或 GIF 背景             █"
    echo "█                                                      █"
    echo "████████████████████████████████████████████████████████"
    echo ""
}

# 检查权限
check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_message $RED "错误：此脚本需要 root 权限运行"
        print_message $YELLOW "请使用: sudo $0"
        exit 1
    fi
}

# 检查 SDDM Astronaut 主题
check_theme() {
    if [ ! -d "$THEME_DIR" ]; then
        print_message $RED "错误：SDDM Astronaut 主题未安装"
        print_message $YELLOW "请先运行: sudo ./setup-sddm-astronaut.sh"
        exit 1
    fi
    print_message $GREEN "✓ SDDM Astronaut 主题已安装"
}

# 创建必要的目录
create_directories() {
    print_message $BLUE "创建必要的目录..."
    
    mkdir -p "$BACKGROUNDS_DIR"
    mkdir -p "$CONFIG_DIR"
    
    print_message $GREEN "✓ 目录创建完成"
}

# 显示媒体选择菜单
show_media_menu() {
    print_message $CYAN "请选择媒体类型："
    echo ""
    echo "1) 🎬 视频文件 (MP4, WebM, AVI 等)"
    echo "2) 🎨 GIF 动画"
    echo "3) 🖼️ 静态图片"
    echo "4) 📋 使用预设主题"
    echo "5) 🎯 预览现有配置"
    echo "0) 🚪 退出"
    echo ""
    read -p "请输入选择 [1-5]: " choice
}

# 处理视频文件
handle_video() {
    print_message $BLUE "=== 视频壁纸设置 ==="
    echo ""
    
    # 获取视频文件路径
    read -p "请输入视频文件路径: " video_path
    
    if [ ! -f "$video_path" ]; then
        print_message $RED "错误：文件不存在"
        return 1
    fi
    
    # 检查视频格式
    local filename=$(basename "$video_path")
    local extension="${filename##*.}"
    
    case "${extension,,}" in
        mp4|webm|avi|mov|mkv|flv)
            print_message $GREEN "✓ 支持的视频格式: $extension"
            ;;
        *)
            print_message $YELLOW "警告：可能不支持的格式 $extension，但仍会尝试"
            ;;
    esac
    
    # 复制文件
    print_message $BLUE "复制视频文件..."
    cp "$video_path" "$BACKGROUNDS_DIR/"
    chmod 644 "$BACKGROUNDS_DIR/$filename"
    
    # 创建配置
    create_video_config "$filename"
}

# 处理 GIF 文件
handle_gif() {
    print_message $BLUE "=== GIF 动画设置 ==="
    echo ""
    
    # 获取 GIF 文件路径
    read -p "请输入 GIF 文件路径: " gif_path
    
    if [ ! -f "$gif_path" ]; then
        print_message $RED "错误：文件不存在"
        return 1
    fi
    
    # 检查文件格式
    local filename=$(basename "$gif_path")
    local extension="${filename##*.}"
    
    if [[ "${extension,,}" != "gif" ]]; then
        print_message $RED "错误：不是 GIF 文件"
        return 1
    fi
    
    print_message $GREEN "✓ GIF 文件格式正确"
    
    # 复制文件
    print_message $BLUE "复制 GIF 文件..."
    cp "$gif_path" "$BACKGROUNDS_DIR/"
    chmod 644 "$BACKGROUNDS_DIR/$filename"
    
    # 创建配置
    create_gif_config "$filename"
}

# 处理静态图片
handle_image() {
    print_message $BLUE "=== 静态图片设置 ==="
    echo ""
    
    # 获取图片文件路径
    read -p "请输入图片文件路径: " image_path
    
    if [ ! -f "$image_path" ]; then
        print_message $RED "错误：文件不存在"
        return 1
    fi
    
    # 检查图片格式
    local filename=$(basename "$image_path")
    local extension="${filename##*.}"
    
    case "${extension,,}" in
        jpg|jpeg|png|bmp|webp)
            print_message $GREEN "✓ 支持的图片格式: $extension"
            ;;
        *)
            print_message $YELLOW "警告：可能不支持的格式 $extension"
            ;;
    esac
    
    # 复制文件
    print_message $BLUE "复制图片文件..."
    cp "$image_path" "$BACKGROUNDS_DIR/"
    chmod 644 "$BACKGROUNDS_DIR/$filename"
    
    # 创建配置
    create_image_config "$filename"
}

# 创建视频配置
create_video_config() {
    local filename=$1
    local config_name="custom_video_$(date +%Y%m%d_%H%M%S).conf"
    
    print_message $BLUE "创建视频配置..."
    
    # 获取用户设置
    echo ""
    print_message $CYAN "视频设置选项："
    read -p "播放速度 (0.1-5.0, 默认 1.0): " speed
    read -p "是否裁剪背景 (y/n, 默认 y): " crop
    
    # 设置默认值
    speed=${speed:-1.0}
    crop=${crop:-y}
    
    # 生成配置
    cat > "$CONFIG_DIR/$config_name" << EOF
[General]
# 视频背景配置
Background=Backgrounds/$filename

# 播放速度 (0.1-5.0)
BackgroundSpeed=$speed

# 裁剪模式 (true=填充屏幕, false=适应屏幕)
CropBackground=$([[ $crop =~ ^[Yy]$ ]] && echo "true" || echo "false")

# 水平对齐 (当不裁剪时)
BackgroundHorizontalAlignment=center

# 垂直对齐 (当不裁剪时)
BackgroundVerticalAlignment=center
EOF

    apply_config "$config_name"
    print_message $GREEN "✓ 视频配置创建完成: $config_name"
}

# 创建 GIF 配置
create_gif_config() {
    local filename=$1
    local config_name="custom_gif_$(date +%Y%m%d_%H%M%S).conf"
    
    print_message $BLUE "创建 GIF 配置..."
    
    # 获取用户设置
    echo ""
    print_message $CYAN "GIF 设置选项："
    read -p "播放速度 (0.1-5.0, 默认 1.0): " speed
    read -p "是否裁剪背景 (y/n, 默认 n): " crop
    read -p "是否暂停动画 (y/n, 默认 n): " pause
    
    # 设置默认值
    speed=${speed:-1.0}
    crop=${crop:-n}
    pause=${pause:-n}
    
    # 生成配置
    cat > "$CONFIG_DIR/$config_name" << EOF
[General]
# GIF 动画配置
Background=Backgrounds/$filename

# 播放速度 (0.1-5.0)
BackgroundSpeed=$speed

# 暂停动画 (仅适用于 GIF)
PauseBackground=$([[ $pause =~ ^[Yy]$ ]] && echo "true" || echo "false")

# 裁剪模式 (true=填充屏幕, false=适应屏幕)
CropBackground=$([[ $crop =~ ^[Yy]$ ]] && echo "true" || echo "false")

# 水平对齐 (当不裁剪时)
BackgroundHorizontalAlignment=center

# 垂直对齐 (当不裁剪时)
BackgroundVerticalAlignment=center
EOF

    apply_config "$config_name"
    print_message $GREEN "✓ GIF 配置创建完成: $config_name"
}

# 创建图片配置
create_image_config() {
    local filename=$1
    local config_name="custom_image_$(date +%Y%m%d_%H%M%S).conf"
    
    print_message $BLUE "创建图片配置..."
    
    # 获取用户设置
    echo ""
    print_message $CYAN "图片设置选项："
    read -p "是否裁剪背景 (y/n, 默认 y): " crop
    
    # 设置默认值
    crop=${crop:-y}
    
    # 生成配置
    cat > "$CONFIG_DIR/$config_name" << EOF
[General]
# 静态图片配置
Background=Backgrounds/$filename

# 裁剪模式 (true=填充屏幕, false=适应屏幕)
CropBackground=$([[ $crop =~ ^[Yy]$ ]] && echo "true" || echo "false")

# 水平对齐 (当不裁剪时)
BackgroundHorizontalAlignment=center

# 垂直对齐 (当不裁剪时)
BackgroundVerticalAlignment=center
EOF

    apply_config "$config_name"
    print_message $GREEN "✓ 图片配置创建完成: $config_name"
}

# 应用配置
apply_config() {
    local config_name=$1
    
    print_message $BLUE "应用配置..."
    
    # 备份元数据文件
    cp "$THEME_DIR/metadata.desktop" "$THEME_DIR/metadata.desktop.backup.$(date +%Y%m%d_%H%M%S)"
    
    # 更新配置
    sed -i "s|ConfigFile=Themes/.*\.conf|ConfigFile=Themes/$config_name|" "$THEME_DIR/metadata.desktop"
    
    print_message $GREEN "✓ 配置已应用"
}

# 显示预设主题
show_preset_themes() {
    print_message $CYAN "=== 预设主题选择 ==="
    echo ""
    
    local themes=(
        "astronaut:🚀 太空主题"
        "black_hole:🕳️ 黑洞主题"
        "cyberpunk:🌆 赛博朋克"
        "japanese_aesthetic:🌸 日式美学"
        "pixel_sakura:🌸 像素樱花"
        "purple_leaves:🍃 紫色叶子"
        "post-apocalyptic_hacker:🔧 末世黑客"
    )
    
    local i=1
    for theme in "${themes[@]}"; do
        local name="${theme%%:*}"
        local description="${theme##*:}"
        echo "$i) $description ($name)"
        ((i++))
    done
    
    echo "0) 🚪 返回主菜单"
    echo ""
    read -p "请选择主题 [1-7]: " theme_choice
    
    if [[ "$theme_choice" =~ ^[1-7]$ ]]; then
        local selected_theme="${themes[$((theme_choice-1))]%%:*}"
        apply_preset_theme "$selected_theme"
    elif [[ "$theme_choice" == "0" ]]; then
        return
    else
        print_message $RED "无效选择"
    fi
}

# 应用预设主题
apply_preset_theme() {
    local theme_name=$1
    
    print_message $BLUE "应用预设主题: $theme_name"
    
    # 检查主题文件是否存在
    if [ ! -f "$CONFIG_DIR/${theme_name}.conf" ]; then
        print_message $RED "错误：主题配置文件不存在"
        return 1
    fi
    
    # 应用配置
    sed -i "s|ConfigFile=Themes/.*\.conf|ConfigFile=Themes/${theme_name}.conf|" "$THEME_DIR/metadata.desktop"
    
    print_message $GREEN "✓ 预设主题已应用: $theme_name"
}

# 预览当前配置
preview_current() {
    print_message $CYAN "=== 当前配置预览 ==="
    echo ""
    
    # 显示当前主题
    local current_config=$(grep "ConfigFile=" "$THEME_DIR/metadata.desktop" | cut -d'=' -f2)
    print_message $GREEN "当前配置: $current_config"
    
    if [ -f "$THEME_DIR/$current_config" ]; then
        echo ""
        print_message $BLUE "配置内容:"
        cat "$THEME_DIR/$current_config"
    fi
    
    echo ""
    print_message $YELLOW "按回车键继续..."
    read
}

# 重启 SDDM
restart_sddm() {
    print_message $BLUE "重启 SDDM 服务..."
    
    if systemctl is-active --quiet sddm; then
        systemctl restart sddm
        print_message $GREEN "✓ SDDM 服务已重启"
    else
        print_message $YELLOW "SDDM 服务未运行，将在下次启动时生效"
    fi
}

# 显示使用提示
show_tips() {
    echo ""
    print_message $PURPLE "🎯 使用提示："
    echo ""
    echo "1. 🎨 媒体文件已复制到: $BACKGROUNDS_DIR"
    echo "2. ⚙️  配置文件位于: $CONFIG_DIR"
    echo "3. 🔄 要切换背景，重新运行此脚本"
    echo "4. 🖼️  要预览主题: sddm-greeter-qt6 --test-mode --theme $THEME_DIR"
    echo "5. 📖 详细文档: scripts/SDDM-Video-Wallpaper-Guide.md"
    echo ""
    print_message $GREEN "配置完成！重启后查看新的登录界面。"
    echo ""
}

# 主菜单
main_menu() {
    while true; do
        print_header
        show_media_menu
        
        case $choice in
            1)
                handle_video
                restart_sddm
                show_tips
                break
                ;;
            2)
                handle_gif
                restart_sddm
                show_tips
                break
                ;;
            3)
                handle_image
                restart_sddm
                show_tips
                break
                ;;
            4)
                show_preset_themes
                restart_sddm
                show_tips
                break
                ;;
            5)
                preview_current
                ;;
            0)
                print_message $YELLOW "退出程序"
                exit 0
                ;;
            *)
                print_message $RED "无效选择，请重试"
                sleep 1
                ;;
        esac
    done
}

# 主函数
main() {
    check_root
    check_theme
    create_directories
    main_menu
}

# 运行主函数
main "$@"