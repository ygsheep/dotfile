{config, pkgs, ... }: 

{
  home.packages = with pkgs; [
    pkgs.jetbrains.pycharm-community-bin

  ];

}
