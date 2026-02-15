# home/apps/browsers/zen.nix - Zen Browser 配置
{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
