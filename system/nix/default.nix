{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./nh.nix
    ./nixpkgs.nix
    ./substituters.nix
  ];

  # we need git for flakes
  environment.systemPackages = [pkgs.git];

  nix = let
    flakeInputs = lib.filterAttrs (_: v: lib.isType "flake" v) inputs;
  in {
    package = pkgs.lix;

    # pin the registry to avoid downloading and evaling a new nixpkgs version every time
    registry = lib.mapAttrs (_: v: {flake = v;}) flakeInputs;

    # set the path for channels compat
    nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = ["nix-command" "flakes"];
      flake-registry = "/etc/nix/registry.json";

      # for direnv GC roots
      keep-derivations = true;
      keep-outputs = true;

      trusted-users = ["root" "@wheel"];
      accept-flake-config = false;

      # 自动清理旧的 generations（当可用空间低于此值时触发）
      min-free = 1024 * 1024 * 1024; # 1GB
      max-free = 5 * 1024 * 1024 * 1024; # 5GB
    };
  };
}
