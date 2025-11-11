{pkgs, ...}:{

  imports = [
    ./cpp.nix
    ./nix.nix
    ./python.nix
  ];

  home.packages = with pkgs; [
    # 桌面环境相关包
    jetbrains.clion
    jetbrains.pycharm-community
  ];
}
