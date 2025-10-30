{ pkgs, config, lib, ... }:

{
  home.packages = with pkgs; [
    # Nix 开发工具
    alejandra        # Nix 代码格式化工具
    nix-search-tv    # Nix 包搜索工具
    nixd             # Nix 语言服务器
    nil              # Nix 语言服务器（备选）
    nixfmt           # Nix 格式化工具
    nix-prefetch-git # Git 包获取工具
    nix-tree         # Nix 包依赖可视化工具
    statix           # Nix 代码静态分析
    deadnix          # 移除未使用的 Nix 变量
  ];

  # 语言服务器配置
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      bbenoist.nix
    ];
  };

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
      diff "nix" = {
        command = "nix-diff";
      };
    };
  };
}