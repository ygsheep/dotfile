{pkgs, ...}: {
  imports = [
    ./fonts.nix
    ./home-manager.nix
    ./xdg.nix
    # ./qt.nix
  ];

  programs = {
    # make HM-managed GTK stuff work
    dconf.enable = true;
    seahorse.enable = true;
    adb.enable = true;
  };
  # android-udev-rules has been removed, superseded by built-in systemd uaccess rules
  services.udev.packages = [];
}
