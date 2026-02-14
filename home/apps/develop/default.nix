{pkgs, ...}:{

  imports = [
    ./cpp.nix
    ./nix.nix
    ./python.nix
    ./gitkraken.nix
    # ./jetbrains.nix  # 暂时禁用
  ];

  home.packages = with pkgs; [
    # 桌面环境相关包
    # jetbrains.clion
    # jetbrains.pycharm-community
  ];
}
