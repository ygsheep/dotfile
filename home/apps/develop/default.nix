{pkgs, ...}: {
  imports = [
    ./cpp.nix
    ./nix.nix
    ./npm.nix
    ./opencode.nix
    ./python.nix
    ./jetbrains.nix
  ];
}
