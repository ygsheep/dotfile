#!/usr/bin/env bash

# Windows 11 UTC 时间设置脚本
# 解决 Windows 与 Linux 双系统时间同步问题

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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
    echo "█         Windows 11 UTC 时间设置工具                     █"
    echo "█                                                      █"
    echo "████████████████████████████████████████████████"
    echo ""
}

# 检查管理员权限
check_admin() {
    print_message $BLUE "=== 检查管理员权限 ==="
    echo ""

    if ! command -v reg &> /dev/null; then
        print_message $RED "✗ 需要 Windows 环境"
        print_message $BLUE "请在 Windows 环境下运行此脚本"
        return 1
    fi

    if ! net session &> /dev/null; then
        print_message $RED "✗ 需要管理员权限"
        print_message $BLUE "请右键点击脚本，选择'以管理员身份运行'"
        return 1
    fi

    print_message $GREEN "✓ 管理员权限检查通过"
    echo ""
}

# 备份注册表
backup_registry() {
    print_message $BLUE "=== 备份注册表 ==="
    echo ""

    local backup_file="$HOME/Desktop/registry_backup_%DATE:~0,10%.reg"

    print_message $YELLOW "备份当前注册表到: $backup_file"

    # 导出时间设置相关的注册表项
    reg export "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" "$backup_file" /y

    print_message $GREEN "✓ 注册表备份完成"
    echo ""
}

# 设置 Windows 使用 UTC 时间
set_utc_time() {
    print_message $BLUE "=== 设置 Windows 使用 UTC 时间 ==="
    echo ""

    print_message $YELLOW "正在修改注册表..."

    # 添加 RealTimeIsUniversal 注册表项
    reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /t REG_DWORD /d 1 /f

    if [ $? -eq 0 ]; then
        print_message $GREEN "✓ 已设置 Windows 使用 UTC 时间"
    else
        print_message $RED "✗ 注册表修改失败"
        return 1
    fi

    echo ""
}

# 显示当前时间设置
show_current_time_settings() {
    print_message $BLUE "=== 当前时间设置 ==="
    echo ""

    # 显示当前时间
    print_message $CYAN "当前系统时间:"
    time /t
    date /t

    echo ""

    # 检查 RealTimeIsUniversal 设置
    local utc_setting=$(reg query "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal 2>nul | find "RealTimeIsUniversal")

    if [ -n "$utc_setting" ]; then
        print_message $GREEN "✓ Windows 已配置为使用 UTC 时间"
        print_message $BLUE "$utc_setting"
    else
        print_message $YELLOW "⚠ Windows 使用本地时间"
    fi

    echo ""

    # 显示时区信息
    print_message $CYAN "当前时区:"
    systeminfo | find "Time Zone"
    echo ""
}

# 重新启动时间服务
restart_time_service() {
    print_message $BLUE "=== 重新启动时间服务 ==="
    echo ""

    print_message $YELLOW "停止 Windows Time 服务..."
    net stop w32time

    print_message $YELLOW "重新启动 Windows Time 服务..."
    net start w32time

    print_message $YELLOW "同步时间..."
    w32tm /resync

    print_message $GREEN "✓ 时间服务重新启动完成"
    echo ""
}

# 验证时间同步
verify_time_sync() {
    print_message $BLUE "=== 验证时间同步 ==="
    echo ""

    print_message $CYAN "强制同步网络时间..."
    w32tm /resync /force

    print_message $CYAN "检查时间服务状态..."
    w32tm /query /status

    print_message $CYAN "检查时间源..."
    w32tm /query /source

    print_message $GREEN "✓ 时间同步验证完成"
    echo ""
}

# 创建撤销脚本
create_undo_script() {
    print_message $BLUE "=== 创建撤销脚本 ==="
    echo ""

    local undo_script="$HOME/Desktop/revert_utc_time.bat"

    cat > "$undo_script" << 'EOF'
@echo off
echo 恢复 Windows 使用本地时间...
reg delete "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /f
echo 重新启动时间服务...
net stop w32time
net start w32time
w32tm /resync
echo Windows 已恢复使用本地时间
pause
EOF

    print_message $GREEN "✓ 撤销脚本已创建: $undo_script"
    echo ""
}

# 恢复本地时间设置
revert_to_local_time() {
    print_message $BLUE "=== 恢复本地时间设置 ==="
    echo ""

    print_message $YELLOW "删除 RealTimeIsUniversal 注册表项..."

    reg delete "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /f

    if [ $? -eq 0 ]; then
        print_message $GREEN "✓ 已恢复 Windows 使用本地时间"
    else
        print_message $YELLOW "⚠ 注册表项可能不存在或已被删除"
    fi

    restart_time_service
    echo ""
}

# 显示说明
show_instructions() {
    print_message $BLUE "=== 使用说明 ==="
    echo ""

    print_message $CYAN "设置完成后："
    echo "1. Windows 和 Linux 现在都使用 UTC 时间作为硬件时钟"
    echo "2. 两个系统的时间将保持同步"
    echo "3. 重启到另一个系统时，时间应该显示正确"
    echo ""

    print_message $CYAN "如果需要恢复："
    echo "1. 运行桌面上的 revert_utc_time.bat 脚本"
    echo "2. 或者选择此脚本中的选项 6"
    echo ""

    print_message $CYAN "注意事项："
    echo "1. 修改注册表后建议重启系统"
    echo "2. 确保两个系统都启用了网络时间同步"
    echo "3. 如果时间仍有偏差，手动同步一次网络时间"
    echo ""
}

# 主菜单
main_menu() {
    print_header
    show_current_time_settings

    print_message $CYAN "请选择操作："
    echo ""
    echo "1) 🔧 设置 Windows 使用 UTC 时间（推荐）"
    echo "2) 📋 查看当前时间设置"
    echo "3) 🔄 重新启动时间服务"
    echo "4) ✅ 验证时间同步"
    echo "5) 📝 创建撤销脚本"
    echo "6) ↩️  恢复使用本地时间"
    echo "0) 🚪 退出"
    echo ""
    read -p "请输入选择 [0-6]: " choice

    case $choice in
        1)
            check_admin
            if [ $? -eq 0 ]; then
                backup_registry
                set_utc_time
                restart_time_service
                verify_time_sync
                create_undo_script
                show_instructions

                print_message $GREEN "✅ UTC 时间设置完成！"
                print_message $BLUE "建议重启系统以确保设置生效"
            fi
            ;;
        2)
            show_current_time_settings
            ;;
        3)
            restart_time_service
            ;;
        4)
            verify_time_sync
            ;;
        5)
            create_undo_script
            ;;
        6)
            check_admin
            if [ $? -eq 0 ]; then
                backup_registry
                revert_to_local_time
                print_message $GREEN "✅ 已恢复为本地时间设置"
            fi
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
    read -p "按回车键继续..."
    main_menu
}

# 主函数
main() {
    main_menu
}

# 检查是否在 Windows 环境
if [[ "$OSTYPE" != "msys" && "$OSTYPE" != "cygwin" && "$OSTYPE" != "win32" ]]; then
    print_message $RED "此脚本需要在 Windows 环境下运行"
    print_message $BLUE "请复制到 Windows 系统中运行"
    exit 1
fi

# 运行主函数
main "$@"