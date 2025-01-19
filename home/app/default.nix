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
    pkgs.jetbrains.idea-community-bin
    pkgs.vscode

    ## java
    pkgs.jdk8
    pkgs.glibc

    ## Qt
    pkgs.qtcreator
    pkgs.llama-cpp

    pkgs.devenv


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
