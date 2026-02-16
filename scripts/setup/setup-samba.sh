#!/bin/bash

# NixOS Samba 设置脚本
# 用于配置 Samba 用户和密码

set -euo pipefail

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查是否为 root 用户
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "此脚本需要 root 权限运行"
        echo "请使用: sudo $0"
        exit 1
    fi
}

# 检查 Samba 是否已安装
check_samba() {
    if ! command -v smbpasswd &> /dev/null; then
        log_error "Samba 工具未找到，请确保 Samba 服务已正确安装"
        exit 1
    fi
}

# 获取用户名
get_user() {
    local user="${1:-sheep}"
    read -p "请输入 Samba 用户名 [默认: $user]: " input_user
    if [[ -n "$input_user" ]]; then
        echo "$input_user"
    else
        echo "$user"
    fi
}

# 设置 Samba 密码
set_samba_password() {
    local user="$1"

    log_info "为用户 '$user' 设置 Samba 密码"

    # 检查用户是否存在
    if ! id "$user" &> /dev/null; then
        log_error "用户 '$user' 不存在"
        exit 1
    fi

    # 检查是否已经有 Samba 密码
    if pdbedit -L | grep -q "^$user:"; then
        log_warning "用户 '$user' 已有 Samba 密码"
        read -p "是否要更改密码？(y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "跳过密码设置"
            return 0
        fi
    fi

    # 设置密码
    if smbpasswd -a "$user"; then
        log_success "Samba 密码设置成功"
    else
        log_error "Samba 密码设置失败"
        exit 1
    fi
}

# 显示配置信息
show_config() {
    local user="$1"

    echo
    log_info "Samba 配置信息："
    echo "=================="
    echo "服务器名称: niri-dot"
    echo "工作组: WORKGROUP"
    echo "共享目录:"
    echo "  - 公开共享: /mnt/Shares/Public (无需密码)"
    echo "  - 私有共享: /mnt/Shares/Private (需要密码)"
    echo "  - TimeMachine: /mnt/Shares/TimeMachine (需要密码)"
    echo "Samba 用户: $user"
    echo
    echo "网络访问地址:"
    echo "  Windows: \\\\niri-dot\\public"
    echo "  或: \\\\192.168.x.x\\public (使用服务器 IP)"
    echo
    log_info "防火墙端口已开放:"
    echo "  - TCP: 139, 445, 5357-5359"
    echo "  - UDP: 137, 138, 3702-3703"
    echo
}

# 验证服务状态
verify_services() {
    log_info "检查 Samba 服务状态..."

    if systemctl is-active --quiet smb; then
        log_success "SMB 服务运行正常"
    else
        log_warning "SMB 服务未运行，使用 'sudo systemctl restart smb' 启动"
    fi

    if systemctl is-active --quiet nmb; then
        log_success "NMB 服务运行正常"
    else
        log_warning "NMB 服务未运行，使用 'sudo systemctl restart nmb' 启动"
    fi

    if systemctl is-active --quiet wsdd; then
        log_success "WSDD 服务运行正常"
    else
        log_warning "WSDD 服务未运行，使用 'sudo systemctl restart wsdd' 启动"
    fi
}

# 主要函数
main() {
    log_info "Niri-Dot Samba 设置向导"
    echo "============================"

    check_root
    check_samba

    # 获取用户名
    user=$(get_user "$1")

    # 设置密码
    set_samba_password "$user"

    # 重启服务
    log_info "重启 Samba 相关服务..."
    systemctl restart smb nmb wsdd 2>/dev/null || true

    # 验证服务
    verify_services

    # 显示配置信息
    show_config "$user"

    log_success "Samba 配置完成！"
    echo
    echo "注意事项："
    echo "1. 确保防火墙允许相关端口访问"
    echo "2. 如果在其他设备上无法访问，请检查网络设置"
    echo "3. 可以使用 'testparm' 命令验证 Samba 配置"
    echo "4. 使用 'smbclient -L //localhost' 测试共享列表"
}

# 显示使用说明
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        echo "用法: $0 [username]"
        echo
        echo "设置 Samba 用户和密码"
        echo
        echo "参数:"
        echo "  username  Samba 用户名 (默认: sheep)"
        echo
        echo "选项:"
        echo "  -h, --help  显示此帮助信息"
        echo
        echo "示例:"
        echo "  $0              # 使用默认用户名"
        echo "  $0 myuser       # 指定用户名"
        exit 0
    fi

    main "$@"
fi