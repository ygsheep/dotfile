
{ pkgs, ... }:

{
  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "cn";
    variant = "";
  };
  # fcitx5 
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk             # alternatively, kdePackages.fcitx5-qt
      fcitx5-chinese-addons  # table input method support
      fcitx5-nord            # a color theme
      fcitx5-rime
      rime-data
      fcitx5-material-color
    ];
  };
  # fcitx5 env
  environment.sessionVariables = {
    GLFW_IM_MODULE = "fcitx";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

}
