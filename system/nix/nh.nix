{ pkgs, ... }: {
  # nh default flake - 指向 Niri-Dot 配置目录
  environment.variables.NH_FLAKE = "/home/sheep/.dotfile";

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
