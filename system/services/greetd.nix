{pkgs, config, ...}: {
  # greetd display manager for Niri window manager
  services.greetd = {
    enable = true;
    settings = {
      terminal.vt = 1;
      default_session = {
        command = "${pkgs.cage}/bin/cage -s -- ${pkgs.greetd.tuigreet}/bin/tuigreet --greeting '欢迎来到 Niri Desktop' --cmd ${pkgs.niri}/bin/niri-session";
        user = "greeter";
      };
      initial_session = {
        command = "${pkgs.niri}/bin/niri-session";
        user = "sheep";
      };
    };
  };

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
