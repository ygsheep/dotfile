{config, pkgs, ...}:
{
  home.packages = with pkgs; [ pkgs.rofi ];

  home.file.".config/rofi/launcher_script.sh" = {
    source = ./launcher_script.sh;
  };
  home.file.".config/rofi/theme.rasi" = {
    source = ./themes/simple-tokyonight.rasi;
  };
  home.file.".config/wofi/" = {
    source = ./wofi;
    recursive = true;
  };
}
