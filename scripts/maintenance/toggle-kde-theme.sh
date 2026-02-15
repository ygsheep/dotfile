#!/usr/bin/env bash
# KDE 主题切换脚本

set -e

THEME_FILE="home/desktop/default.nix"
THEME_COMMENT="# ./kde.nix  # 取消注释以启用 KDE 主题配置"
THEME_ENABLED='./kde.nix  # 取消注释以启用 KDE 主题配置'

echo "🎨 KDE 主题配置切换"
echo "=================="

if grep -q "^#\s*./kde.nix" "$THEME_FILE"; then
    echo "📌 当前状态: KDE 主题已禁用"
    echo ""
    echo "✅ 启用 KDE 主题配置..."
    sed -i 's|^#\s*\./kde\.nix.*|./kde.nix  # KDE 主题配置|' "$THEME_FILE"
    echo "✨ KDE 主题已启用！"
    echo ""
    echo "📝 下一步:"
    echo "   make switch"
    echo ""
else
    echo "📌 当前状态: KDE 主题已启用"
    echo ""
    echo "❌ 禁用 KDE 主题配置..."
    sed -i 's|^./kde\.nix.*|# ./kde.nix  # 取消注释以启用 KDE 主题配置|' "$THEME_FILE"
    echo "✨ KDE 主题已禁用"
    echo ""
    echo "📝 下一步:"
    echo "   make switch"
    echo ""
fi
