{
  config,
  pkgs,
  lib,
  ...
}: {
  # GNOME 42 桌面环境（与 KDE 共存，使用 GDM 显示管理器）
  # GDM 在 system/desktop/kde.nix 中已配置

  services.desktopManager.gnome.enable = true;

  # GNOME 核心服务
  services.gnome = {
    core-apps.enable = true;
    gnome-keyring.enable = true;
  };

  # 系统级包：GNOME 核心应用 + Pop Shell
  environment.systemPackages = with pkgs; [
    # GNOME 扩展和工具
    gnome-tweaks # GNOME 优化工具
    dconf-editor # dconf 配置编辑器

    # Pop Shell 平铺窗口管理（类似 Pop!_OS）
    gnomeExtensions.pop-shell

    # GNOME 核心应用（使用顶层包名）
    nautilus # 文件管理器
    gnome-console # 终端
    gnome-text-editor # 文本编辑器
    gnome-software # 软件中心
    eog # 图片查看器
    evince # PDF 查看器
    file-roller # 压缩工具
    gnome-calculator # 计算器
    gnome-calendar # 日历
    gnome-clocks # 时钟
    gnome-contacts # 联系人
    gnome-maps # 地图
    gnome-music # 音乐
    gnome-weather # 天气
    gnome-logs # 日志查看器
    baobab # 磁盘使用分析
    gnome-disk-utility # 磁盘工具
    gnome-system-monitor # 系统监视器
    seahorse # 密钥管理

    # 通用工具（兼容别名）
    yelp # 帮助浏览器
  ];

  # 排除不需要的 GNOME 应用
  environment.gnome.excludePackages = with pkgs; [
    simple-scan # 扫描工具
    totem # 视频播放器（已有 VLC）
  ];

  # DConf 配置
  programs.dconf.enable = true;

  # GVfs (虚拟文件系统)
  services.gvfs.enable = true;

  # NetworkManager applet
  programs.nm-applet.enable = true;

  # 解决与 KDE Plasma 的 SSH askPassword 冲突
  # 优先使用 seahorse（GNOME）而非 ksshaskpass（KDE）
  programs.ssh.askPassword = lib.mkForce "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
}
