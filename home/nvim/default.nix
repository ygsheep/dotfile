{config, pkgs, ...}:
{
  home.packages = with pkgs; [
    neovim 
    git lazygit
    fd fzf ripgrep                     # 文件搜索
    sumneko-lua-language-server stylua # Lua
    cl zig
    wl-clipboard
    python310 pyright
    cargo nodejs_20 yarn
    vcpkg clang libgcc
  ];

  # home.file.".config/nvim/" = {
  #   source = ./config;
  #   recursive = true;
  # };
}
