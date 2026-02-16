{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./browsers/chromium.nix
    ./browsers/firefox.nix
    ./browsers/edge.nix
    ./browsers/zen.nix # Zen Browser (已禁用)

    ./gtk.nix
    ./media
    ./develop
  ];

  home.packages = with pkgs; [
    # apps
    localsend
    wechat-uos

    # messaging
    telegram-desktop
    vesktop

    # misc
    pciutils
    nixos-icons
    ffmpegthumbnailer
    imagemagick
    bun

    fastfetch

    # gnome
    amberol
    (celluloid.override {youtubeSupport = true;})
    dconf-editor
    file-roller
    gnome-control-center
    gnome-text-editor
    loupe
    nautilus
    (papers.override {supportNautilus = true;})
    resources

    inkscape
    # scrcpy

    # swww
    ghostty
    mods
    openvpn

    # lmstudio本地大模型
    lmstudio
  ];
}
