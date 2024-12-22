{config, pkgs, ...}:
{
  home.packages = with pkgs; [ pkgs.waybar ];

  home.file.".config/waybar/config" = {
    source = ./config;
  };
  home.file.".config/waybar/style.css" = {
    source = ./style.css;
  };
}
