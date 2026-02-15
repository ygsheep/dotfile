# system/services/v2raya.nix - V2RayA 代理管理服务
{
  pkgs,
  lib,
  config,
  ...
}: {
  services.v2raya = {
    enable = lib.mkDefault true;
    # 使用 Xray 核心替代 V2Ray，支持 XTLS-RPRX-Vision
    cliPackage = lib.mkDefault pkgs.xray;
  };

  # 将 xray 添加到系统包中，使其在 PATH 中可用
  environment.systemPackages = lib.mkAfter [pkgs.xray];

  # 确保 xray 在 v2raya 服务的 PATH 中，使用优先级 100
  systemd.services.v2raya.path = lib.mkOverride 100 [pkgs.xray];
}
