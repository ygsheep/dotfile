let
  desktop = [
    # ./core/boot.nix
    ./core/default.nix

    # ./hardware/graphics.nix
    # ./hardware/fwupd.nix

    ./network/default.nix

    # ./chinese/fonts.nix
    # ./chinese/input-methods.nix
    # ./chinese/mirrors.nix
    # ./chinese/localization.nix

    # 暂时注释掉 programs
    # ./programs

    # ./services
    # ./services/ananicy.nix
    # ./services/greetd.nix
    # ./services/pipewire.nix
    # ./services/swww.nix
    # ./services/session-vars.nix
    # ./services/flatpak.nix

    # 只保留 boot 和 core
    ./core/boot.nix
    ./core/default.nix

    # 暂时注释掉 programs
    # ./programs
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
