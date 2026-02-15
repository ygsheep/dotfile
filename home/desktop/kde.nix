# KDE Plasma 主题配置
# Papirus-Dark 图标 + Orchis 窗口主题 + Gruvbox 配色
{pkgs, ...}: {
  home.packages = with pkgs; [
    # ========== 图标主题 ==========
    papirus-icon-theme # 现代扁平化图标
    whitesur-icon-theme # macOS 风格备选

    # ========== 窗口主题 ==========
    orchis-theme # 现代 GTK/Qt 窗口主题

    # ========== 光标主题 ==========
    bibata-cursors # 你当前在用 ✓

    # ========== Fcitx5 KDE 集成 ==========
    kdePackages.fcitx5-qt # Qt5/Qt6 输入法支持
    qt6Packages.fcitx5-configtool # Fcitx5 图形配置工具

    # ========== KDE 组件 ==========
    kdePackages.breeze # 默认 Breeze 主题
    kdePackages.breeze-gtk # Breeze GTK 引擎
    kdePackages.qt6ct # Qt6 配置工具

    # ========== KDE 实用应用 ==========
    kdePackages.dolphin # 文件管理器
    kdePackages.okular # PDF 阅读器
    kdePackages.gwenview # 图片查看器
    kdePackages.ark # 压缩工具
    kdePackages.kate # 文本编辑器
    kdePackages.konsole # 终端
    kdePackages.spectacle # 截图工具

    # ========== KDE 系统工具 ==========
    kdePackages.kde-gtk-config # GTK 配置集成
    kdePackages.systemsettings # 系统设置
    kdePackages.kdeconnect-kde # KDE Connect 设备连接
  ];

  # ========== KDE Connect 服务 ==========
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  # ========== Qt 配置 ==========
  # 注意：完整 KDE Plasma 环境下不需要手动配置 Qt
  qt = {
    enable = true;
    platformTheme = "kde";
  };

  # ========== 主题配置文件 ==========
  xdg.configFile = {
    # KDE 全局主题配置
    "kdeglobals".text = ''
       [General]
       ColorScheme=GruvboxDarkHard
       Name=Default
       XftAntialias=true
       XftHintStyle=hintmedium
       XftSubPixel=none

       [KDE]
       SingleClick=true
       ShowDeleteCommand=false
      LookAndFeelPackage=org.kde.breezedark.desktop

       [Icons]
       Theme=Papirus-Dark

       [WM]
       activeFont=Noto Sans,10,-1,5,50,0,0,0,0,0
       inactiveFont=Noto Sans,10,-1,5,50,0,0,0,0,0
    '';

    # Breeze 窗口装饰配置
    "blossomrc".text = ''
      [Common]
      BorderSize=3
      DrawBorderOnMaximizedWindows=false
      EnableBlurBehind=true
      ShadowStrength=50

      [Windeco]
      ButtonSize=50
      BorderSize=3
    '';
  };

  # ========== 环境变量 ==========
  home.sessionVariables = {
    # KDE 应用使用 Breeze
    QT_QPA_PLATFORMTHEME = "kde";
    # GTK 应用使用 Orchis
    GTK_THEME = "Orchis-dark";
  };
}
