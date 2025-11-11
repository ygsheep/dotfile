{
  config,
  pkgs,
  ...
}: {
  # 启用 Neovim 程序
  programs.neovim = {
    enable = true;
  };

  # 安装 Neovim 相关的额外软件
  home.packages = with pkgs; [
    neovide
    lua
    luajitPackages.luarocks_bootstrap
  ];
}
