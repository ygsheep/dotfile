{
  imports = [
    # editors
    ../../editors/helix
    ../../editors/zed

    # services
    ../../services/wayland/gammastep.nix
    ../../services/wayland/quickshell.nix
    ../../services/wayland/hypridle.nix

    # media services
    ../../services/media/playerctl.nix

    # software
    ../../software
    ../../software/wayland
    ../../software/wayland/astal-shell.nix
    ../../software/anyrun

    # system services
    ../../services/system/gpg-agent.nix
    ../../services/system/cliphist.nix
    ../../services/system/polkit-agent.nix
    ../../services/system/power-monitor.nix
  ];
}
