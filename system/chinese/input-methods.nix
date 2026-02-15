# systems/chinese/input-methods.nix - Fcitx5 + Rime 输入法配置
{
  config,
  pkgs,
  lib,
  ...
}: {
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      rime-data
      fcitx5-gtk # 包含 GTK2/3/4 支持
      fcitx5-rime
      fcitx5-nord # 主题
    ];
  };

  # 输入法环境变量
  environment.sessionVariables = {
    GLFW_IM_MODULE = "fcitx";
    GTK_IM_MODULE = "fcitx"; # GTK 应用需要（Firefox, VSCode 等）
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

  # 系统级 Fcitx5 默认配置（作为后备配置）
  environment.etc."xdg/fcitx5/profile".text = ''
    [Groups/0]
    # Group Name
    Name=默认
    # Layout
    Default Layout=cn
    # Default Input Method
    DefaultIM=rime

    [Groups/0/Items/0]
    # Name
    Name=keyboard-cn
    # Layout
    Layout=

    [Groups/0/Items/1]
    # Name
    Name=rime
    # Layout
    Layout=

    [GroupOrder]
    0=默认
  '';
}
