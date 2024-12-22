{config, pkgs, ...}:
{
  home.packages = with pkgs; [
    pkgs.mpd pkgs.mpc pkgs.go-musicfox
  ];

  home.file.".config/mpd/" = {
    source = ./mpd;
    recursive = true;
  };

  home.file.".config/ncmpcpp/" = {
    source = ./ncmpcpp;
    recursive = true;
  };
}
