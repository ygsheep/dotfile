{pkgs, ...}: {
  imports = [
    ./cpp.nix
    ./nix.nix
    ./npm.nix
    ./python.nix
    ./gitkraken.nix
    ./jetbrains.nix
  ];
}
