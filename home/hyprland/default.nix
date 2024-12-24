{config, pkgs, ... }: 
{
  home.packages = with pkgs; [
    pipewire
    ## Resource monitoring modules
    libgtop
    ## Copy/Paste utilities
    wl-clipboard cliphist
    ## Compiler for sass/scss
    dart-sass
    ## Brightness module for OSD
    brightnessctl
    ## AGS requirements
    networkmanager

    # pkgs.hyprpanel
    pkgs.ags
    pkgs.hyprpicker
    pkgs.hyprsunset
    pkgs.hypridle
    # pkgs.hyprpanel
    pkgs.waybar
    pkgs.wofi
    pkgs.wofi-emoji 
    pkgs.rofi 
    pkgs.fuzzel
    pkgs.swww
   
   ## Optional
   grim
   grimblast
   pkgs.cava
   pkgs.tty-clock
   pkgs.imv
   pkgs.yazi


   ## vpn proxy
   v2raya
  ];
  wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = true;
    # The hyprland package to use
    package = pkgs.hyprland;
    # Whether to enable XWayland
    xwayland.enable = true;

    # Optional
    # Whether to enable hyprland-session.target on hyprland startup
    # systemd.enable = true;
  };

  home.file.".config/hypr/" = {
    source = ./hypr;
    recursive = true;
  };


}
