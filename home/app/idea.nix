{config, pkgs, ... }: 

{
  home.packages = with pkgs; [
    pkgs.jetbrains.idea-community-bin

  ## java
    pkgs.jdk8
    pkgs.glibc
  ];

}
