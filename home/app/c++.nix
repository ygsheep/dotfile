{config, pkgs, ... }: 

{
  home.packages = with pkgs; [
    pkgs.vcpkg
    pkgs.clang
    pkgs.libgcc
  ];

}
