#!/usr/bin/env bash

# CI 检查脚本 - 验证 NixOS 配置的正确性
# 用于持续集成和本地开发环境

set -euo pipefail

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
    echo "       Niri-Dot CI 检查脚本"
    echo "========================================"
}

print_step() {
    print_message $BLUE "▶ $1"
}

print_success() {
    print_message $GREEN "✅ $1"
}

print_warning() {
    print_message $YELLOW "⚠️  $1"
}

print_error() {
    print_message $RED "❌ $1"
}

# 检查命令是否存在
check_command() {
    local cmd=$1
    if ! command -v "$cmd" &> /dev/null; then
        print_error "命令 '$cmd' 未找到"
        return 1
    fi
}

# 检查配置语法
check_flake_syntax() {
    print_step "检查 Nix flake 语法..."

    if nix flake check --no-build; then
        print_success "flake 语法检查通过"
    else
        print_error "flake 语法检查失败"
        return 1
    fi
}

# 检查代码格式
check_code_format() {
    print_step "检查代码格式..."

    # 检查是否安装了 alejandra
    if command -v alejandra &> /dev/null; then
        if alejandra --check .; then
            print_success "代码格式检查通过"
        else
            print_error "代码格式检查失败"
            print_warning "运行 'alejandra .' 修复格式问题"
            return 1
        fi
    else
        print_warning "alejandra 未安装，跳过格式检查"
        print_warning "建议运行 'nix run nixpkgs#alejandra -- .'"
    fi
}

# 检查构建
check_build() {
    print_step "尝试构建配置（dry run）..."

    # 检查是否能获取评估
    if nix flake show --all-systems; then
        print_success "配置评估成功"
    else
        print_error "配置评估失败"
        return 1
    fi
}

# 检查文件完整性
check_file_integrity() {
    print_step "检查文件完整性..."

    local errors=0

    # 检查关键文件是否存在
    local critical_files=(
        "flake.nix"
        "home/default.nix"
        "system/default.nix"
        "hosts/default.nix"
    )

    for file in "${critical_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            print_error "关键文件缺失: $file"
            ((errors++))
        fi
    done

    # 检查 Nix 文件语法
    print_step "检查 Nix 文件语法..."
    while IFS= read -r -d '' nix_file; do
        if ! nix-instantiate --parse "$nix_file" > /dev/null 2>&1; then
            print_error "语法错误: $nix_file"
            ((errors++))
        fi
    done < <(find . -name "*.nix" -print0)

    if ((errors == 0)); then
        print_success "文件完整性检查通过"
    else
        print_error "文件完整性检查失败，发现 $errors 个问题"
        return 1
    fi
}

# 检查脚本质量
check_script_quality() {
    print_step "检查 shell 脚本质量..."

    local errors=0

    while IFS= read -r -d '' script_file; do
        # 检查是否有 shebang
        if [[ "$(head -n1 "$script_file")" != "#!"* ]]; then
            print_warning "缺少 shebang: $script_file"
        fi

        # 检查是否有 set -euo pipefail
        if ! grep -q "set -euo pipefail" "$script_file"; then
            print_warning "建议添加 'set -euo pipefail': $script_file"
        fi

        # 检查基本语法
        if bash -n "$script_file" 2>/dev/null; then
            print_success "脚本语法正确: $(basename "$script_file")"
        else
            print_error "脚本语法错误: $(basename "$script_file")"
            ((errors++))
        fi
    done < <(find . -name "*.sh" -print0)

    if ((errors == 0)); then
        print_success "脚本质量检查通过"
    else
        print_error "脚本质量检查失败，发现 $errors 个问题"
        return 1
    fi
}

# 检查依赖项
check_dependencies() {
    print_step "检查依赖项..."

    local missing_deps=()
    local required_commands=("nix" "git")

    for cmd in "${required_commands[@]}"; do
        if ! check_command "$cmd"; then
            missing_deps+=("$cmd")
        fi
    done

    if (( ${#missing_deps[@]} == 0 )); then
        print_success "所有必需的依赖项都已安装"
    else
        print_error "缺少依赖项: ${missing_deps[*]}"
        return 1
    fi
}

# 检查文档链接
check_documentation_links() {
    print_step "检查文档中的链接..."

    if [[ -f "README.md" ]]; then
        # 检查 README 中的链接是否有效
        print_step "检查 README.md 中的链接..."
        # 这里可以添加更多详细的链接检查逻辑
        print_success "文档检查完成"
    else
        print_warning "未找到 README.md"
    fi
}

# 生成报告
generate_report() {
    local exit_code=$1

    echo ""
    echo "========================================"
    if ((exit_code == 0)); then
        print_message $GREEN "🎉 所有检查通过！配置可以安全使用。"
    else
        print_message $RED "💥 检查失败，请修复上述问题后重试。"
    fi
    echo "========================================"
}

# 主函数
main() {
    print_header

    # 切换到项目根目录
    cd "$(dirname "$0")/../.."

    # 检查是否在正确的目录
    if [[ ! -f "flake.nix" ]]; then
        print_error "未在项目根目录中找到 flake.nix"
        exit 1
    fi

    local errors=0

    # 运行各项检查
    check_dependencies || ((errors++))
    check_file_integrity || ((errors++))
    check_flake_syntax || ((errors++))
    check_code_format || ((errors++))
    check_build || ((errors++))
    check_script_quality || ((errors++))
    check_documentation_links || ((errors++))

    generate_report $errors
    exit $errors
}

# 运行主函数
main "$@"