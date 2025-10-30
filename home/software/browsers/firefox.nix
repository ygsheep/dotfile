{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [ ../../../../modules/home-manager/programs/firefox/default.nix ];

  # Firefox Wayland 环境变量
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };
}
