{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./rime.nix
  ];

  # Fcitx5 环境变量设置（系统级已设置，这里作为备份）
  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    GLFW_IM_MODULE = "fcitx";
    INPUT_METHOD = "fcitx";
    SDL_IM_MODULE = "fcitx";
    EDITOR = "hx";
  };
}
