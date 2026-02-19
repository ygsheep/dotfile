# Godot 游戏引擎开发环境
# 包含 KDE Wayland 兼容性优化
{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    godot_4
    godot_4-export-templates-bin
  ];

  # 导出模板链接
  home.file.".local/share/godot/export_templates/${
    builtins.replaceStrings ["-"] ["."] pkgs.godot_4-export-templates-bin.version
  }".source =
    pkgs.godot_4-export-templates-bin;

  # ========== Godot KDE 兼容性启动脚本 ==========
  # 创建自定义 Godot 启动脚本，解决 KDE Wayland 卡死问题
  home.file.".local/bin/godot4-kde".text = ''
    #!/usr/bin/env bash
    # Godot 4 KDE Wayland 兼容性启动脚本
    # 解决问题：KDE Plasma Wayland 下 OpenGL 上下文冲突导致卡死

    set -euo pipefail

    # ========== 环境变量配置 ==========
    # 禁用 KDE Qt 平台主题（避免冲突）
    unset QT_QPA_PLATFORMTHEME
    unset QT_STYLE_OVERRIDE

    # 强制使用 XWayland 后端（更稳定）
    export GDK_BACKEND=x11
    export QT_QPA_PLATFORM=xcb

    # OpenGL 兼容性优化
    export __GL_THREADED_OPTIMIZATIONS=0
    export __GLX_VENDOR_LIBRARY_NAME=mesa
    export MESA_GL_VERSION_OVERRIDE=4.6
    export EGL_PLATFORM=x11

    # Godot 4 特定设置
    export GODOT_USE_WAYLAND=0  # 禁用 Wayland
    export GODOT_USE_OPENGL3=1  # 使用 OpenGL 3

    # KDE 特定优化
    export KDE_FULL_SESSION=1
    export XDG_SESSION_TYPE=x11
    export WAYLAND_DISPLAY=""

    # ========== 日志配置 ==========
    LOGFILE="$HOME/.local/share/godot/godot-kde.log"
    mkdir -p "$(dirname "$LOGFILE")"

    # ========== 启动 Godot ==========
    echo "[$(date)] Godot 启动 (XWayland 模式)" >> "$LOGFILE"
    echo "环境变量: QT_QPA_PLATFORM=$QT_QPA_PLATFORM, GDK_BACKEND=$GDK_BACKEND" >> "$LOGFILE"

    exec godot4 "$@" 2>&1 | tee -a "$LOGFILE"
  '';

  # 设置脚本可执行权限
  home.activation.godotKdeWrapper = lib.mkAfter ''
    file=${config.home.homeDirectory}/.local/bin/godot4-kde
    if [ -f "$file" ]; then
      chmod +x "$file"
    fi
  '';

  # ========== Helix GDScript 支持 ==========
  programs.helix = {
    languages.language = [
      {
        name = "gdscript";
        auto-format = true;
      }
    ];
  };
}
