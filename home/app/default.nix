{config, pkgs, ... }: 

{
  home.packages = with pkgs; [
    ## vpn proxy
    pkgs.v2raya

    ## 微信
    pkgs.wechat-uos
    pkgs.qq
    pkgs.chromium
    pkgs.obsidian
    pkgs.jetbrains.pycharm-community-bin
  ];

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };

}
