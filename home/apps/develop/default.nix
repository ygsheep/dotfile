{pkgs, ...}: {
  imports = [
    ./cpp.nix
    ./godot.nix
    ./jetbrains.nix
    ./nix.nix
    ./npm.nix
    ./opencode.nix
    ./python.nix
  ];
}
