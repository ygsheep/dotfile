{pkgs, config, ...}: {
  # 极简 greetd 配置 - 直接启动 Niri，移除不必要的中间层
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.niri}/bin/niri-session";
        user = "sheep";
      };
    };
  };

  # 注释掉 SDDM 配置，改回使用 Greetd
  /*
  services = {
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
    displayManager.sddm.theme = "breeze";
  };

  environment.etc."sddm.conf".text = ''
    [Theme]
    Current=breeze
  '';

  environment.etc."sddm.conf.d/virtualkbd.conf".text = ''
    [General]
    InputMethod=qtvirtualkeyboard
  '';
  */

  # Set up session variables for Wayland
  environment.sessionVariables = {
    # Variables for Wayland session
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    # Fix for greetd expandable variables
    XDG_SESSION_TYPE = "wayland";
  };
}
