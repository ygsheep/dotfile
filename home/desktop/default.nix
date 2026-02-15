{pkgs, ...}: {
  imports = [
    ./wayland
    ./kde.nix # 取消注释以启用 KDE 主题配置
  ];

  home.packages = with pkgs; [
    # 桌面环境相关包
  ];
}
