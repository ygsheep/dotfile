{
  config,
  pkgs,
  ...
}: {
  # KDE Plasma 6 桌面环境（与 GNOME 共存，使用 GDM 显示管理器）
  services = {
    xserver.enable = true;

    # 使用 GDM 作为显示管理器（支持 KDE、GNOME、Niri 会话选择）
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    # 启用 KDE Plasma 6 桌面
    desktopManager.plasma6.enable = true;

    # 电源管理
    power-profiles-daemon.enable = true;
  };

  # 设置全局外观为深色主题
  environment.etc."xdg/kdeglobals".text = ''
    [General]
    ColorScheme=GruvboxDarkHard
    Name=Default
    LookAndFeelPackage=com.github.vinceliuice.ChromeOS-dark

    [KDE]
    LookAndFeelPackage=com.github.vinceliuice.ChromeOS-dark

    [WM]
    activeBackground=29,32,33
    activeForeground=235,219,178
    inactiveBackground=60,56,54
    inactiveForeground=189,174,147
  '';

  # KDE 核心应用包 + Niri 会话文件
  environment.systemPackages = with pkgs; [
    # Niri 会话文件（在 GDM 中可用）
    (pkgs.writeTextDir "share/wayland-sessions/niri.desktop" ''
      [Desktop Entry]
      Name=Niri
      Comment=Scrollable tiling window manager
      Exec=${pkgs.niri}/bin/niri-session
      Type=Application
      DesktopNames=niri
      Keywords=wm;tiling;wayland;
    '')
    # KDE 核心应用
    kdePackages.discover # 软件中心
    kdePackages.kcalc # 计算器
    kdePackages.kcharselect # 字符选择工具
    kdePackages.kclock # 时钟应用
    kdePackages.kcolorchooser # 颜色选择器
    kdePackages.kolourpaint # 画图程序
    kdePackages.ksystemlog # 系统日志查看器
    kdiff3 # 文件比较和合并工具
    kdePackages.isoimagewriter # ISO 镜像写入工具
    kdePackages.partitionmanager # 分区管理器

    # 通用工具
    hardinfo2 # 系统信息和基准测试
    vlc # 媒体播放器
    wayland-utils # Wayland 工具集
    wl-clipboard # Wayland 剪贴板工具
  ];

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
