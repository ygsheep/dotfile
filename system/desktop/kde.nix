{
  config,
  pkgs,
  ...
}: {
  # KDE Plasma 6 桌面环境
  services = {
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };

    desktopManager.plasma6.enable = true;

    # 电源管理 - KDE 需要 power-profiles-daemon
    power-profiles-daemon.enable = true;
  };

  # 设置全局外观为深色主题
  environment.etc."xdg/kdeglobals".text = ''
    [General]
    ColorScheme=BreezeDark
    LookAndFeelPackage=org.kde.breezedark.desktop

    [KDE]
    LookAndFeelPackage=org.kde.breezedark.desktop
  '';

  # SDDM 配置：添加 /etc/share/wayland-sessions 作为会话目录
  environment.etc."sddm.conf.d/sessions.conf".text = ''
    [Wayland]
    SessionDir=/etc/share/wayland-sessions
  '';

  # 在 /etc/share/wayland-sessions 创建符号链接指向 plasma.desktop
  systemd.tmpfiles.rules = [
    "L+ /etc/share/wayland-sessions/plasma.desktop - - - - /run/current-system/sw/share/wayland-sessions/plasma.desktop"
  ];

  # KDE 核心应用包
  environment.systemPackages = with pkgs; [
    # KDE 核心应用
    kdePackages.discover # 软件中心
    kdePackages.kcalc # 计算器
    kdePackages.kcharselect # 字符选择工具
    kdePackages.kclock # 时钟应用
    kdePackages.kcolorchooser # 颜色选择器
    kdePackages.kolourpaint # 画图程序
    kdePackages.ksystemlog # 系统日志查看器
    kdePackages.sddm-kcm # SDDM 配置模块
    kdiff3 # 文件比较和合并工具
    kdePackages.isoimagewriter # ISO 镜像写入工具
    kdePackages.partitionmanager # 分区管理器

    # 通用工具
    hardinfo2 # 系统信息和基准测试
    vlc # 媒体播放器
    wayland-utils # Wayland 工具集
    wl-clipboard # Wayland 剪贴板工具
  ];

  # 直接在 plasma-workspace 目录中创建 niri.desktop
  # 这样 SDDM 可以同时发现 Plasma 和 Niri 会话
  environment.etc."share/wayland-sessions/niri.desktop".text = ''
    [Desktop Entry]
    Name=Niri
    Comment=Scrollable tiling window manager
    Exec=${pkgs.niri}/bin/niri-session
    Type=Application
    DesktopNames=niri
    Keywords=wm;tiling;wayland;
  '';

  # 排除不需要的 KDE 应用
  environment.plasma6.excludePackages = with pkgs; [
    kdePackages.elisa # 音乐播放器
    kdePackages.kdepim-runtime # Akonadi 资源（邮件相关）
    kdePackages.kmahjongg # 麻将游戏
    kdePackages.kmines # 扫雷游戏
    kdePackages.konversation # IRC 客户端
    kdePackages.kpat # 纸牌游戏
    kdePackages.ksudoku # 数独游戏
    kdePackages.ktorrent # BitTorrent 客户端
  ];
}
