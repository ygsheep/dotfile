{pkgs, ...}: {
  home.packages = with pkgs; [
    # Nix 工具
    nixfmt
    nil
    nixpkgs-fmt
    nix-tree
    nix-search

    # 开发工具
    direnv
  ];

  # 编辑器配置
  programs.helix = {
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.alejandra}/bin/alejandra";
      }
    ];
  };

  # Git 配置
  programs.git = {
    attributes = ["*.nix diff=nix"];
    extraConfig = {
      diff."nix".command = "nix-diff";
    };
  };
}
