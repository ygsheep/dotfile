{pkgs, ...}: {
  imports = [
    ./cpp.nix
    ./nix.nix
    ./npm.nix
    ./python.nix
    ./jetbrains.nix
  ];
}
