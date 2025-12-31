{pkgs, ...}:{

  imports = [
    ./cpp.nix
    ./nix.nix
    ./python.nix
    ./gitkraken.nix
  ];

  home.packages = with pkgs; [
    # 桌面环境相关包
    jetbrains.clion
    jetbrains.pycharm-community
  ];
}
