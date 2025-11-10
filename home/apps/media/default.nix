{pkgs, ...}: {
  imports = [
    ./obs.nix
    ./rnnoise.nix
    ./mpvpaper.nix
  ];

  home.packages = with pkgs; [
    # audio control
    pamixer
    alsa-utils
    easyeffects
  ];
}
