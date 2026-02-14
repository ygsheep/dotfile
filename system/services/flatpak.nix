# system/services/flatpak.nix - Flatpak 服务配置
{
  config,
  pkgs,
  lib,
  ...
}: {
  services.flatpak.enable = true;

  # 启用 Flathub 仓库
  systemd.services.flatpak-repo = {
    description = "Add Flathub repository";
    wantedBy = ["multi-user.target"];
    after = ["network-online.target"];
    wants = ["network-online.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo";
    };
  };
}
