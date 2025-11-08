#!/bin/bash

# 配置验证脚本 - 验证 Niri-Dot 配置的完整性和正确性

set -euo pipefail

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

print_header() {
    echo "========================================"
    echo "     Niri-Dot 配置验证脚本"
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

# 检查模块导入
check_module_imports() {
    print_step "检查模块导入..."

    local errors=0

    # 检查 home/default.nix 的导入
    if [[ -f "home/default.nix" ]]; then
        print_step "验证 Home Manager 配置导入..."

        # 检查导入的模块是否存在
        local home_imports=(
            "terminal"
            "editors"
            "programs/input-method"
            "programs/version-control"
        )

        for import in "${home_imports[@]}"; do
            if [[ -d "home/$import" ]]; then
                print_success "模块存在: home/$import"
            else
                print_error "模块缺失: home/$import"
                ((errors++))
            fi
        done
    else
        print_error "未找到 home/default.nix"
        ((errors++))
    fi

    # 检查 system/default.nix 的导入
    if [[ -f "system/default.nix" ]]; then
        print_step "验证系统配置导入..."

        local system_modules=(
            "chinese"
            "core"
            "hardware"
            "network"
            "nix"
            "programs"
            "services"
        )

        for module in "${system_modules[@]}"; do
            if [[ -d "system/$module" ]]; then
                print_success "模块存在: system/$module"
            else
                print_warning "可选模块不存在: system/$module"
            fi
        done
    fi

    return $errors
}

# 检查全局变量一致性
check_global_variables() {
    print_step "检查全局变量一致性..."

    local errors=0

    # 检查 flake.nix 中的全局变量定义
    if ! grep -q "globals.*=" flake.nix; then
        print_error "flake.nix 中未定义 globals"
        ((errors++))
    else
        print_success "发现全局变量定义"
    fi

    # 检查使用 globals 的文件
    local files_using_globals=$(grep -r "globals\." --include="*.nix" . | wc -l)
    print_success "发现 $files_using_globals 处使用全局变量"

    return $errors
}

# 检查资源文件
check_assets() {
    print_step "检查资源文件..."

    local errors=0

    # 检查 assets 目录结构
    local asset_dirs=(
        "wallpaper"
        "fonts"
        "video"
    )

    for dir in "${asset_dirs[@]}"; do
        if [[ -d "assets/$dir" ]]; then
            local file_count=$(find "assets/$dir" -type f | wc -l)
            print_success "assets/$dir 存在，包含 $file_count 个文件"
        else
            print_warning "可选资源目录不存在: assets/$dir"
        fi
    done

    # 检查壁纸文件
    if [[ -d "assets/wallpaper" ]]; then
        local wallpaper_count=$(find "assets/wallpaper" -type f \( -name "*.jpg" -o -name "*.png" \) | wc -l)
        if ((wallpaper_count > 0)); then
            print_success "发现 $wallpaper_count 个壁纸文件"
        else
            print_warning "assets/wallpaper 目录为空"
        fi
    fi

    return $errors
}

# 检查配置文件语法
check_config_syntax() {
    print_step "检查配置文件语法..."

    local errors=0

    # 使用 nix-instantiate 检查所有 .nix 文件
    while IFS= read -r -d '' nix_file; do
        if nix-instantiate --parse "$nix_file" > /dev/null 2>&1; then
            print_success "语法正确: $(basename "$nix_file")"
        else
            print_error "语法错误: $(basename "$nix_file")"
            ((errors++))
        fi
    done < <(find . -name "*.nix" -print0 | grep -v -E '\.git|result')

    return $errors
}

# 检查依赖项版本
check_dependency_versions() {
    print_step "检查依赖项版本..."

    # 检查 nixpkgs 版本
    if grep -q "nixos-unstable" flake.nix; then
        print_success "使用 nixos-unstable 分支"
    else
        print_warning "未使用 nixos-unstable 分支"
    fi

    # 检查关键输入
    local critical_inputs=(
        "nixpkgs"
        "hm"
        "home-manager"
        "niri"
        "noctalia"
    )

    for input in "${critical_inputs[@]}"; do
        if grep -q "$input.*=" flake.nix; then
            print_success "依赖项存在: $input"
        else
            print_warning "依赖项可能缺失: $input"
        fi
    done
}

# 检查配置选项一致性
check_config_consistency() {
    print_step "检查配置选项一致性..."

    local errors=0

    # 检查用户名一致性
    local usernames=($(grep -r "sheep\." --include="*.nix" . | wc -l))
    if ((usernames > 0)); then
        print_warning "发现 $usernames 处硬编码用户名 'sheep'"
        print_warning "建议使用 globals.user"
    fi

    # 检查路径一致性
    local hardcoded_paths=($(grep -r "/home/sheep" --include="*.nix" . | wc -l))
    if ((hardcoded_paths > 0)); then
        print_warning "发现 $hardcoded_paths 处硬编码路径"
        print_warning "建议使用全局变量"
    fi

    return $errors
}

# 生成修复建议
generate_fix_suggestions() {
    print_step "生成修复建议..."

    cat << 'EOF'

🔧 修复建议：

1. 硬编码问题：
   - 将 /home/sheep 替换为 globals.homeDir
   - 将 "sheep" 替换为 globals.user

2. 语法错误：
   - 运行 nix-instantiate --parse filename.nix 检查具体错误
   - 使用 nixfmt 或 alejandra 格式化代码

3. 模块缺失：
   - 检查导入路径是否正确
   - 确保模块文件存在且可读

4. 依赖问题：
   - 更新 flake.lock: nix flake update
   - 检查输入源 URL 是否有效

EOF
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

    local total_errors=0

    # 运行各项验证
    check_module_imports || ((total_errors+=$?))
    check_global_variables || ((total_errors+=$?))
    check_assets || ((total_errors+=$?))
    check_config_syntax || ((total_errors+=$?))
    check_dependency_versions || ((total_errors+=$?))
    check_config_consistency || ((total_errors+=$?))

    echo ""
    echo "========================================"
    if ((total_errors == 0)); then
        print_message $GREEN "🎉 配置验证通过！所有检查都成功。"
    else
        print_message $RED "💥 发现 $total_errors 个问题需要修复。"
        generate_fix_suggestions
    fi
    echo "========================================"

    exit $total_errors
}

# 运行主函数
main "$@"