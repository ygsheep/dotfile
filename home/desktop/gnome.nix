{
  config,
  pkgs,
  lib,
  ...
}: {
  # ========== DConf 配置 ==========
  programs.dconf.enable = true;

  dconf.settings = {
    # ========== GNOME Shell 配置 ==========
    "org/gnome/shell" = {
      # 启用扩展
      enabled-extensions = [
        "pop-shell@system76.com" # Pop Shell 平铺窗口管理
      ];

      # 收藏应用（Dock 栏）
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "org.gnome.Console.desktop"
        "godot.desktop"
      ];

      # 禁用活动视图概览（Pop Shell 会处理）
      disable-user-extensions = false;

      # 工作区设置
      dynamic-workspaces = false;
      number-of-workspaces = 4;
    };

    # ========== Pop Shell 配置 ==========
    "org/gnome/shell/extensions/pop-shell" = {
      # 平铺设置
      tile-by-default = true; # 默认平铺新窗口

      # 间隙设置
      smart-gaps = false; # 禁用智能间隙
      gap-inner = lib.hm.gvariant.mkUint32 4; # 内部间隙
      gap-outer = lib.hm.gvariant.mkUint32 4; # 外部间隙

      # 窗口行为
      show-title = true; # 显示窗口标题
      active-hint = true; # 显示活动窗口提示

      # 快捷键行为
      toggle-overview = lib.hm.gvariant.mkUint32 1; # Super+Space
      toggle-stacking = lib.hm.gvariant.mkUint32 2; # Super+S
    };

    # ========== 桌面外观 ==========
    "org/gnome/desktop/interface" = {
      # GTK 主题（暗色）
      gtk-theme = "Adwaita-dark";

      # 图标主题
      icon-theme = "Papirus-Dark";

      # 字体设置
      font-name = "Noto Sans 11";
      document-font-name = "Noto Sans 11";
      monospace-font-name = "Geist Mono Nerd Font Mono 11";

      # 其他界面设置
      show-battery-percentage = true;
      clock-show-weekday = true;
      clock-format = "24h";
      enable-hot-corners = false; # Pop Shell 不需要热角
    };

    # ========== 窗口管理器 ==========
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close"; # 传统按钮布局
      resize-with-right-button = true;
      focus-mode = "click";
      auto-raise = false;
    };

    # ========== Nautilus 文件管理器 ==========
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      search-filter-time-type = "last_modified";
      show-create-link = true;
      sort-directories-first = true;
    };

    # ========== GNOME 终端 ==========
    "org/gnome/Console" = {
      font-name = "Geist Mono Nerd Font Mono 12";
      theme = "dark";
      use-system-font = false;
    };

    # ========== 输入法 (Fcitx5) ==========
    "org/gnome/desktop/input-sources" = {
      sources =
        lib.hm.gvariant.mkArray
        (lib.hm.gvariant.type.variant (lib.hm.gvariant.type.string))
        [(lib.hm.gvariant.mkTuple ["xkb" "cn"])];
      xkb-options = "terminate:ctrl_alt_bksp";
    };

    # ========== 隐藏桌面图标 ==========
    "org/gnome/desktop/background" = {
      show-desktop-icons = false;
    };
  };

  # ========== 用户级包 ==========
  home.packages = with pkgs; [
    # GNOME 额外应用
    gnome-console
    gnome-text-editor

    # 扩展工具
    gnomeExtensions.appindicator # 顶部托盘图标支持
    gnomeExtensions.dash-to-dock # Dock 栏（可选）
  ];

  # ========== 主题配置文件 ==========
  # Gruvbox Dark Hard 颜色方案（用于 GTK 应用）
  xdg.dataFile = {
    "themes/GruvboxDarkHard/gtk-4.0/gtk.css".text = ''
      /* Gruvbox Dark Hard GTK4 主题 */
      @define-color bg_hard #1d2021;
      @define-color bg #282828;
      @define-color bg1 #3c3836;
      @define-color bg2 #504945;
      @define-color bg3 #665c54;
      @define-color bg4 #7c6f64;

      @define-color gray #928374;
      @define-color fg #ebdbb2;
      @define-color fg0 #fbf1c7;
      @define-color fg2 #d5c4a1;
      @define-color fg3 #bdae93;
      @define-color fg4 #a89984;

      @define-color red #cc241d;
      @define-color green #98971a;
      @define-color yellow #d79921;
      @define-color blue #458588;
      @define-color purple #b16286;
      @define-color aqua #689d6a;
      @define-color orange #d65d0e;
      @define-color bright_red #fb4934;
      @define-color bright_green #b8bb26;
      @define-color bright_yellow #fabd2f;
      @define-color bright_blue #83a598;
      @define-color bright_purple #d3869b;
      @define-color bright_aqua #8ec07c;
      @define-color bright_orange #fe8019;

      window {
        background-color: @bg_hard;
        color: @fg;
      }
    '';
  };

  # ========== 环境变量 ==========
  # GNOME 不需要特殊的 Qt 平台主题设置
  # 这解决了 Godot 在 KDE 下的兼容性问题
  home.sessionVariables = {
    # 确保 Qt 应用使用原生外观
    QT_QPA_PLATFORMTHEME = "gtk3";
    # GTK 应用使用暗色主题
    GTK_THEME = "Adwaita-dark";
  };
}
