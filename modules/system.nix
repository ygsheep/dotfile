{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    pkgs.kitty
    pkgs.catppuccin-sddm-corners
    pkgs.firefox
  ];
  services.keyd = {
    enable = true;
    keyboards = {
      # The name is just the name of the configuration file, it does not really matter
      default = {
        ids = [ "*" ]; # what goes into the [id] section, here we select all keyboards
        # Everything but the ID section:
        settings = {
          # The main layer, if you choose to declare it in Nix
          main = {
            capslock = "overload(control, esc)"; # you might need to also enclose the key in quotes if it contains non-alphabetical symbols
            };
          otherlayer = {};
        };
        extraConfig = ''
          # put here any extra-config, e.g. you can copy/paste here directly a configuration, just remove the ids part
        '';
      };
    };
  };
  services.displayManager.sddm = {
     enable = true;
     theme = "catppuccin-sddm-corners";
     wayland.enable = true;
  }; 
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
  };
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.displayManager.gdm.wayland = true;
  services.flatpak.enable = true;
  programs.hyprland.enable = true;
  virtualisation.docker.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # ================ 驱动 =================
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia" "modesetting"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;

    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
