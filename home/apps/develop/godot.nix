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
