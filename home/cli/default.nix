{pkgs, ...}: {
  imports = [
    ./terminal
  ];

  home.packages = with pkgs; [
    # CLI 工具
    bat
    eza
    fd
    ripgrep
    fzf
    jq
    curl
    wget
    git
    lazygit
  ];
}
