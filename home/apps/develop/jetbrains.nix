# home/apps/develop/jetbrains.nix - JetBrains IDEs 配置
{pkgs, ...}: {
  home.packages = with pkgs; [
    # JetBrains 新版（已合并社区/商业版）
    jetbrains.idea # IntelliJ IDEA（合并版）
    jetbrains.pycharm # PyCharm
    jetbrains.clion # CLion
    jetbrains.datagrip # DataGrip
    jetbrains.goland # GoLand
    jetbrains.rider # Rider
  ];
}
