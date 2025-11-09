{pkgs, ...}: {
  imports = [
    ./wayland
  ];

  home.packages = with pkgs; [
    # 桌面环境相关包
  ];
}
