{
  pkgs,
  config,
  ...
}:
# Wayland config
{
  imports = [
    ./niri
    ./astal
    ./waybar
    ./noctalia
    ./hyprlock.nix
  ];

  home.packages = with pkgs; [
    # screenshot
    grim
    slurp
    (flameshot.override {enableWlrSupport = true;})

    # utils
    wl-clipboard
  ];

  # make stuff work on wayland
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "gtk3";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };

  # Enable Flameshot service
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        # Enable grim adapter for Wayland support
        useGrimAdapter = true;

        # Other useful settings
        disabledTrayIcon = false;
        showStartupLaunchMessage = true;
        autoCloseIdleDaemon = false;
        copyPathAfterSave = true;
        savePath = "${config.home.homeDirectory}/Pictures/Screenshots";
        savePathFixed = false;
      };
    };
  };

  # Ensure screenshots directory exists
  home.file."Pictures/Screenshots/.keep".text = "";
}
