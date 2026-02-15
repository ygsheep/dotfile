{pkgs, ...}: {
  # 完全注释掉 Qt 配置来测试
  # qt = {
  #   enable = true;
  #   platformTheme = "gnome";
  #   style = "adwaita-dark";
  # };

  # 使用 Qt5 而不是 Qt6
  # environment.variables = {
  #   QT_QPA_PLATFORMTHEME = "gnome";
  #   QT_STYLE_OVERRIDE = "adwaita-dark";
  # };

  # 确保 Qt5 库可用
  # environment.systemPackages = with pkgs; [
  #   qt5.qtbase
  #   qt5.qttools
  #   qt5.qtsvg
  #   qt5.qtwayland
  #   qt5.qtgraphicaleffects
  #   qt5.qtquickcontrols2
  #   qt5.qtdeclarative
  # ];
}
