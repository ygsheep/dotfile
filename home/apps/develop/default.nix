{pkgs, ...}: {
  imports = [
    ./cpp.nix
    # ./godot.nix (网络问题暂关闭)
    # ./jetbrains.nix (网络问题暂关闭)
    ./nix.nix
    ./npm.nix
    ./opencode.nix
    ./python.nix
  ];
}
