{
  lib,
  pkgs,
  ...
}:
# limine bootloader config with secure boot disabled
{
  boot.loader = {
    limine = {
      enable = true;
      efiSupport = true;
      style.wallpapers = [pkgs.nixos-artwork.wallpapers.simple-dark-gray-bootloader.gnomeFilePath];
      maxGenerations = 10;
      secureBoot.enable = false;
    };
    systemd-boot.enable = lib.mkForce false;
  };

  # 移除 sbctl 包，因为不需要安全启动
  # environment.systemPackages = [pkgs.sbctl];
}
