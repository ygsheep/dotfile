#!/usr/bin/env bash

# 检查项目结构是否正确

set -euo pipefail

echo "🔍 检查 Niri-Dot 项目结构..."

cd "$(dirname "$0")/../.."

# 检查关键目录
required_dirs=(
    "home/cli"
    "home/apps"
    "home/desktop"
    "scripts/setup"
    "scripts/maintenance"
    "scripts/testing"
    "docs"
)

for dir in "${required_dirs[@]}"; do
    if [[ -d "$dir" ]]; then
        echo "✅ 目录存在: $dir"
    else
        echo "❌ 目录缺失: $dir"
        exit 1
    fi
done

# 检查导入路径引用
echo "🔍 检查导入路径..."

old_paths=(
    "software"
    "terminal"
)

new_paths=(
    "apps"
    "cli"
)

echo "检查是否还有旧路径引用..."
old_refs=$(grep -r "software" home/ --include="*.nix" | wc -l)
echo "发现 $old_refs 处 'software' 引用"

terminal_refs=$(grep -r "terminal" home/ --include="*.nix" | grep -v "# terminal" | wc -l)
echo "发现 $terminal_refs 处可能的 'terminal' 导入引用"

echo "✅ 结构检查完成"