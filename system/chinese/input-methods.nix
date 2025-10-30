# systems/chinese/input-methods.nix - Fcitx5 + Rime 输入法配置
{ config, pkgs, lib, ... }:

{

  # 手动安装 fcitx5 相关包
  environment.systemPackages = with pkgs; [
    fcitx5
    fcitx5-rime  # Rime 输入法引擎
    fcitx5-gtk   # GTK 支持
    # fcitx5-qt    # Qt 支持
    # fcitx5-configtool
  ];

  # 输入法环境变量
  environment.sessionVariables = {
    GLFW_IM_MODULE = "fcitx";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    # Wayland 专用配置
    INPUT_METHOD = "fcitx";
    # Electron Wayland 支持
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  # 字体支持（确保输入法候选框显示正常）
  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    source-han-sans
    source-han-serif
    wqy_microhei
    wqy_zenhei
    # 增强字体支持
    noto-fonts-emoji
    sarasa-gothic
  ];
}
