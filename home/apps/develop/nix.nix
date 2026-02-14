{ pkgs, ... }:
{
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

  # VSCode 扩展
  # NOTE: Auto-install disabled due to network restrictions in China
  # programs.vscode = {
  #   extensions = with pkgs.vscode-extensions; [
  #     jnoortheen.nix-ide
  #     bbenoist.nix
  #   ];
  # };

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
    attributes = [ "*.nix diff=nix" ];
    extraConfig = {
      diff."nix".command = "nix-diff";
    };
  };
}