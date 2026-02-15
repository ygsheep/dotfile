{pkgs, ...}: {
  imports = [
    ./flatpak.nix # 暂时注释掉，避免路径问题
    ./keyd.nix # Keyd 键盘重映射服务
    # ./v2raya.nix # V2RayA 代理管理服务 - xray 包在当前 nixpkgs 不可用
  ];

  services = {
    printing = {
      enable = true;
      drivers = [pkgs.hplip];
    };

    dbus.implementation = "broker";

    # profile-sync-daemon
    psd = {
      enable = true;
      resyncTimer = "10m";
    };
    irqbalance.enable = true;
  };

  # Use in place of hypridle's before_sleep_cmd, since systemd does not wait for
  # it to complete
  powerManagement = {
    enable = true;
    powerDownCommands = ''
      # Lock all sessions
      loginctl lock-sessions

      # Wait for lockscreen(s) to be up
      sleep 1
    '';
  };
}
