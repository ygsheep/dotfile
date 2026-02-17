{pkgs, ...}: {
  imports = [
    # ./android.nix
    ./fonts.nix
    ./home-manager.nix
    ./xdg.nix
    # ./qt.nix
  ];

  programs = {
    # make HM-managed GTK stuff work
    dconf.enable = true;
    seahorse.enable = true;
    # adb.enable 已废弃，systemd 258 自动处理 uaccess 规则
  };

  # 添加 android-tools 以提供 adb 命令
  environment.systemPackages = [pkgs.android-tools];

  # android-udev-rules has been removed, superseded by built-in systemd uaccess rules
  services.udev.packages = [];
}
