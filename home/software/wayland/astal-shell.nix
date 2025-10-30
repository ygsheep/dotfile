{ inputs, pkgs, config, lib, ... }:
let
  inherit (config.lib.stylix) colors;
in {
  imports = [ inputs.astal-shell.homeManagerModules.default ];

  services.astal-shell = {
    enable = true;

    # Configure display margins
    displays = {
      "DP-1" = [250 80];
      "HDMI-A-1" = [400 120];
    };

    # Configure theme matching your current setup
    theme = {
      background = {
        primary = "rgba(30, 30, 46, 1.0)";
        secondary = "rgba(24, 24, 37, 1.0)";
      };
      text = {
        primary = "rgba(205, 214, 244, 1.0)";
        secondary = "rgba(186, 194, 222, 0.7)";
        focused = "rgba(255, 255, 255, 1.0)";
        unfocused = "rgba(255, 255, 255, 0.6)";
      };
      accent = {
        primary = "rgba(${lib.removePrefix "#" colors.base0E}, 0.8)";
        secondary = "rgba(${lib.removePrefix "#" colors.base0E}, 0.6)";
        border = "rgba(${lib.removePrefix "#" colors.base0E}, 0.4)";
        overlay = "rgba(${lib.removePrefix "#" colors.base0E}, 0.2)";
      };
      status = {
        success = "rgba(76, 175, 80, 0.8)";
        warning = "rgba(255, 193, 7, 0.8)";
        error = "rgba(244, 67, 54, 0.8)";
      };
      opacity = {
        high = 1.0;
        medium = 0.8;
        low = 0.6;
      };
      font = {
        sizes = {
          small = "0.8em";
          normal = "1em";
          large = "1.2em";
        };
        weights = {
          normal = "normal";
          bold = "bold";
        };
      };
      spacing = {
        small = "4px";
        medium = "8px";
        large = "16px";
      };
      borderRadius = {
        small = "2px";
        medium = "4px";
        large = "9999px";
      };
    };

    # Use the package from nixpkgs
    package = pkgs.astal-shell;
  };

  # Additional configuration files
  home.file.".config/astal-shell/displays.json".text = ''
    {
      "DP-1": [250, 80],
      "HDMI-A-1": [400, 120]
    }
  '';

  home.file.".config/astal-shell/theme.json".text = ''
    {
      "colors": {
        "background": {
          "primary": "rgba(30, 30, 46, 1.0)",
          "secondary": "rgba(24, 24, 37, 1.0)"
        },
        "text": {
          "primary": "rgba(205, 214, 244, 1.0)",
          "secondary": "rgba(186, 194, 222, 0.7)",
          "focused": "rgba(255, 255, 255, 1.0)",
          "unfocused": "rgba(255, 255, 255, 0.6)"
        },
        "accent": {
          "primary": "rgba(${lib.removePrefix "#" colors.base0E}, 0.8)",
          "secondary": "rgba(${lib.removePrefix "#" colors.base0E}, 0.6)",
          "border": "rgba(${lib.removePrefix "#" colors.base0E}, 0.4)",
          "overlay": "rgba(${lib.removePrefix "#" colors.base0E}, 0.2)"
        },
        "status": {
          "success": "rgba(76, 175, 80, 0.8)",
          "warning": "rgba(255, 193, 7, 0.8)",
          "error": "rgba(244, 67, 54, 0.8)"
        }
      },
      "opacity": {
        "high": 1.0,
        "medium": 0.8,
        "low": 0.6
      },
      "font": {
        "sizes": {
          "small": "0.8em",
          "normal": "1em",
          "large": "1.2em"
        },
        "weights": {
          "normal": "normal",
          "bold": "bold"
        }
      },
      "spacing": {
        "small": "4px",
        "medium": "8px",
        "large": "16px"
      },
      "borderRadius": {
        "small": "2px",
        "medium": "4px",
        "large": "9999px"
      }
    }
  '';
}