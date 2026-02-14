{
  pkgs,
  inputs,
  lib,
  ...
}: let
  quickshell = inputs.quickshell.packages.${pkgs.system}.default;
in {
  home.packages = with pkgs;
    [
      quickshell
    ]
    ++ [
      # inputs.mynixpkgs.packages.${pkgs.system}.dgop  # 暂时注释掉，包不存在
      accountsservice
      brightnessctl
      cava
      cliphist
      ddcutil
      # kdePackages.qt6ct  # 暂时注释掉以解决 fcitx5-qt6 构建问题
      khal
      material-symbols
      matugen
      swww
      wl-clipboard
      glib
    ];
}
