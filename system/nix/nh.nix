{
  pkgs,
  globals,
  ...
}: {
  # nh default flake - 指向 NixOS 配置目录
  environment.variables.NH_FLAKE = globals.projectDir;

  programs.nh = {
    enable = true;
    # weekly cleanup
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d";
    };
    package = pkgs.nh;
  };
}
