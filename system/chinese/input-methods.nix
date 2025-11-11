# systems/chinese/input-methods.nix - Fcitx5 + Rime 输入法配置
{
  config,
  pkgs,
  lib,
  ...
}: {
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      rime-data
      fcitx5-gtk
      fcitx5-rime
      fcitx5-nord # 主题
    ];
  };

  # 输入法环境变量
  environment.sessionVariables = {
    GLFW_IM_MODULE = "fcitx";
    # GTK_IM_MODULE = "fcitx";
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
    noto-fonts-color-emoji
    sarasa-gothic
  ];
}
