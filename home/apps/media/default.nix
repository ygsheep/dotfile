{pkgs, ...}: {
  imports = [
    # ./obs.nix (网络问题暂关闭)
    ./rnnoise.nix
    ./mpvpaper.nix
  ];

  home.packages = with pkgs; [
    # audio control
    pamixer
    alsa-utils
    easyeffects

    # 3D graphics (网络问题暂关闭)
    # blender
  ];
}
