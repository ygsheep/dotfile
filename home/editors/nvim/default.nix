{
  config,
  pkgs,
  ...
}: {
  # 启用 Neovim 程序
  # 只安装软件包，不启用配置管理
  # programs.neovim.enable = false;

  # 安装 Neovim 相关的额外软件
  home.packages = with pkgs; [
    neovim # 单独安装 neovim 软件包
    neovide
    lua
    luajitPackages.luarocks_bootstrap
  ];
}
