let
  desktop = [
    ./core/boot.nix
    ./core/default.nix

    ./network

    ./chinese/fonts.nix
    ./chinese/input-methods.nix
    ./chinese/mirrors.nix
    ./chinese/localization.nix

    # Programs（包含 xdg.portal）
    ./programs

    ./services
  ];

  laptop =
    desktop
    ++ [
      ./hardware/bluetooth.nix
      ./services/power.nix
    ];
in {
  inherit desktop laptop;
}
