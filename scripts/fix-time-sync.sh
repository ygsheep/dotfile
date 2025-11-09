#!/usr/bin/env bash

# 双系统时间同步修复脚本
# 解决 NixOS 和 Windows 11 时间同步问题
# 推荐方案：让 NixOS 使用本地时间，与 Windows 保持一致

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
    echo "█         双系统时间同步修复工具                         █"
    echo "█          (NixOS + Windows 11)                      █"
    echo "████████████████████████████████████████████████"
    echo ""
}

# 检查当前系统
check_system() {
    print_message $BLUE "=== 系统检查 ==="
    echo ""

    if [ -f /etc/nixos/configuration.nix ]; then
        print_message $GREEN "✓ 检测到 NixOS 系统"
        SYSTEM="nixos"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
        print_message $GREEN "✓ 检测到 Windows 系统"
        SYSTEM="windows"
    else
        print_message $RED "✗ 未知的系统类型"
        exit 1
    fi

    print_message $BLUE "当前系统: $SYSTEM"
    echo ""
}

# NixOS 时间同步检查
check_nixos_time() {
    print_message $BLUE "=== NixOS 时间配置检查 ==="
    echo ""

    # 检查硬件时钟设置
    local hwclock_setting=$(timedatectl show --property=RTCInLocalTime --value)
    if [ "$hwclock_setting" = "yes" ]; then
        print_message $GREEN "✓ 硬件时钟已设置为本地时间（与 Windows 兼容）"
    else
        print_message $RED "✗ 硬件时钟使用 UTC 时间"
    fi

    # 检查时区设置
    local timezone=$(timedatectl show --property=Timezone --value)
    print_message $CYAN "时区设置: $timezone"

    # 检查 NTP 同步状态
    local ntp_status=$(timedatectl show --property=NTPSynchronized --value)
    print_message $CYAN "NTP 同步状态: $ntp_status"

    # 检查 chrony 服务状态
    if systemctl is-active --quiet chronyd; then
        print_message $GREEN "✓ Chrony 服务正在运行"
    else
        print_message $RED "✗ Chrony 服务未运行"
    fi

    # 显示当前时间
    print_message $CYAN "当前系统时间:"
    timedatectl status
    echo ""
}

# Windows 时间同步检查
check_windows_time() {
    print_message $BLUE "=== Windows 时间配置检查 ==="
    echo ""

    # 检查 UTC 设置
    local utc_setting=$(reg query "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal 2>nul | find "RealTimeIsUniversal" || echo "未设置")

    if [[ "$utc_setting" == *"0x1"* ]]; then
        print_message $GREEN "✓ Windows 配置为使用 UTC 时间"
    else
        print_message $RED "✗ Windows 使用本地时间"
    fi

    # 显示当前时间
    print_message $CYAN "当前系统时间:"
    time /t
    date /t

    # 显示时区
    print_message $CYAN "当前时区:"
    systeminfo | find "Time Zone"
    echo ""
}

# 修复 NixOS 时间设置
fix_nixos_time() {
    print_message $BLUE "=== 修复 NixOS 时间设置 ==="
    echo ""

    print_message $YELLOW "正在配置 NixOS 使用本地时间（与 Windows 兼容）..."

    # 确保硬件时钟使用本地时间
    sudo hwclock --systohc --localtime
    print_message $GREEN "✓ 已设置硬件时钟为本地时间"

    # 重启 chrony 服务
    sudo systemctl restart chronyd
    print_message $GREEN "✓ 已重启 Chrony 服务"

    # 强制同步时间
    sudo chronyc -a makestep
    print_message $GREEN "✓ 已强制同步时间"

    # 显示同步状态
    sudo chronyc tracking

    echo ""
    print_message $CYAN "💡 说明："
    echo "   - NixOS 现在使用本地时间作为硬件时钟"
    echo "   - Windows 无需任何修改"
    echo "   - 两个系统时间将自动保持同步"
    echo ""
}

# 提供 Windows 时间说明
guide_windows_info() {
    print_message $BLUE "=== Windows 时间设置说明 ==="
    echo ""

    print_message $GREEN "✅ Windows 无需任何修改！"
    echo ""

    print_message $CYAN "由于 NixOS 已配置为使用本地时间："
    echo "1. Windows 保持默认设置即可"
    echo "2. 不需要修改注册表"
    echo "3. 不需要运行任何脚本"
    echo ""

    print_message $YELLOW "验证方法："
    echo "1. 重启到 Windows，检查时间是否正确"
    echo "2. 重启到 NixOS，检查时间是否正确"
    echo "3. 两个系统的时间应该自动保持同步"
    echo ""

    print_message $BLUE "💡 工作原理："
    echo "   - Windows 默认使用本地时间作为硬件时钟"
    echo "   - NixOS 现在也配置为使用本地时间"
    echo "   - 两个系统对硬件时钟的解释方式一致"
    echo ""
}

# 验证时间同步
verify_time_sync() {
    print_message $BLUE "=== 验证时间同步 ==="
    echo ""

    if [ "$SYSTEM" = "nixos" ]; then
        print_message $CYAN "检查 NTP 服务器连接..."
        sudo chronyc sources

        print_message $CYAN "检查时间偏差..."
        sudo chronyc tracking

        print_message $CYAN "显示详细时间状态..."
        timedatectl status
    else
        print_message $CYAN "检查 Windows 时间服务..."
        w32tm /query /status

        print_message $CYAN "检查时间源..."
        w32tm /query /source

        print_message $CYAN "强制同步时间..."
        w32tm /resync /force
    fi

    echo ""
}

# 创建时间同步报告
create_time_report() {
    print_message $BLUE "=== 生成时间同步报告 ==="
    echo ""

    local report_file="$HOME/time_sync_report_$(date +%Y%m%d_%H%M%S).txt"

    {
        echo "双系统时间同步报告"
        echo "生成时间: $(date)"
        echo "系统类型: $SYSTEM"
        echo ""

        if [ "$SYSTEM" = "nixos" ]; then
            echo "=== NixOS 时间信息 ==="
            timedatectl status
            echo ""
            echo "=== Chrony 服务状态 ==="
            sudo systemctl status chronyd --no-pager
            echo ""
            echo "=== Chrony 跟踪信息 ==="
            sudo chronyc tracking
        else
            echo "=== Windows 时间信息 ==="
            time /t
            date /t
            echo ""
            echo "=== Windows 时间服务状态 ==="
            w32tm /query /status
            echo ""
            echo "=== UTC 注册表设置 ==="
            reg query "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal
        fi

        echo ""
        echo "=== 建议 ==="
        echo "1. 确保两个系统都使用 UTC 时间作为硬件时钟"
        echo "2. 确保两个系统都启用了网络时间同步"
        echo "3. 重启系统后检查时间是否正确"
        echo "4. 如有问题，重新运行时间同步工具"
    } > "$report_file"

    print_message $GREEN "✓ 时间同步报告已生成: $report_file"
    echo ""
}

# 显示常见问题
show_troubleshooting() {
    print_message $BLUE "=== 常见问题解决 ==="
    echo ""

    print_message $CYAN "问题 1: 重启后时间仍然错误"
    echo "解决: 手动同步网络时间"
    echo "  - NixOS: sudo chronyc -a makestep"
    echo "  - Windows: w32tm /resync /force"
    echo ""

    print_message $CYAN "问题 2: 时间相差几小时"
    echo "解决: 检查时区设置"
    echo "  - NixOS: timedatectl set-timezone Asia/Shanghai"
    echo "  - Windows: 设置 → 时间和语言 → 时区"
    echo ""

    print_message $CYAN "问题 3: NTP 同步失败"
    echo "解决: 检查网络连接和防火墙设置"
    echo "  - 确保 UDP 端口 123 开放"
    echo "  - 尝试更换 NTP 服务器"
    echo ""

    print_message $CYAN "问题 4: Windows 注册表修改无效"
    echo "解决: 确保以管理员身份运行"
    echo "  - 右键脚本 → 以管理员身份运行"
    echo "  - 或使用管理员权限的命令提示符"
    echo ""
}

# 主菜单
main_menu() {
    print_header
    check_system

    if [ "$SYSTEM" = "nixos" ]; then
        check_nixos_time
    else
        check_windows_time
    fi

    print_message $CYAN "请选择操作："
    echo ""
    echo "1) 🔧 修复当前系统时间设置"
    echo "2) 📋 查看详细时间状态"
    echo "3) ✅ 验证时间同步"
    echo "4) 📝 生成时间同步报告"
    echo "5) ❓ 显示常见问题解决"
    if [ "$SYSTEM" = "nixos" ]; then
        echo "6) 📋 显示 Windows 修复指导"
    else
        echo "6) 📋 显示 NixOS 修复指导"
    fi
    echo "0) 🚪 退出"
    echo ""
    read -p "请输入选择 [0-6]: " choice

    case $choice in
        1)
            if [ "$SYSTEM" = "nixos" ]; then
                fix_nixos_time
            else
                print_message $YELLOW "Windows 无需修改，请查看说明"
                guide_windows_info
            fi
            ;;
        2)
            if [ "$SYSTEM" = "nixos" ]; then
                check_nixos_time
            else
                check_windows_time
            fi
            ;;
        3)
            verify_time_sync
            ;;
        4)
            create_time_report
            ;;
        5)
            show_troubleshooting
            ;;
        6)
            if [ "$SYSTEM" = "nixos" ]; then
                guide_windows_info
            else
                print_message $CYAN "NixOS 修复步骤："
                echo "1. 确保 time-sync.nix 配置已导入"
                echo "2. 运行 sudo nixos-rebuild switch"
                echo "3. 重启系统"
                echo "4. 检查时间同步状态"
                echo "5. Windows 端无需任何操作"
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

# 运行主函数
main "$@"