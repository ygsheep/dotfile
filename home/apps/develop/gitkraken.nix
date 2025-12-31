# home/apps/develop/gitkraken.nix - GitKraken Git GUI 客户端
{pkgs, ...}: {
  home.packages = with pkgs; [
    gitkraken # GitKraken - 跨平台 Git GUI 客户端
  ];
}
