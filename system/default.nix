let
  desktop = [
    ./core/boot.nix
    ./core/default.nix

    ./hardware/graphics.nix
    ./hardware/fwupd.nix

    ./network/default.nix

    ./chinese/fonts.nix
    ./chinese/input-methods.nix
    ./chinese/mirrors.nix
    ./chinese/localization.nix

    ./programs

    ./services
    ./services/ananicy.nix
    ./services/greetd.nix
    ./services/pipewire.nix
    ./services/swww.nix
    ./services/session-selector.nix
    ./services/flatpak.nix
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
