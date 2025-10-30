{ pkgs, config, ... }: {
  # Create a session selector for multiple desktop environments
  environment.systemPackages = with pkgs; [
    # Session selector script
    (writeShellScriptBin "session-selector" ''
      #!/bin/bash
      # Session selector for multiple desktop environments

      SESSION_DIR="/run/current-system/sw/share/xsessions"
      WAYLAND_SESSION_DIR="/run/current-system/sw/share/wayland-sessions"

      echo "🖥️  Desktop Environment Selector"
      echo "================================"
      echo ""

      # Check available sessions
      echo "Available sessions:"

      # Check for GNOME (Wayland)
      if [ -f "$WAYLAND_SESSION_DIR/gnome.desktop" ]; then
        echo "1) GNOME (Wayland)"
      fi

      # Check for GNOME (X11)
      if [ -f "$SESSION_DIR/gnome.desktop" ]; then
        echo "2) GNOME (X11)"
      fi

      # Check for Niri
      if command -v niri-session >/dev/null 2>&1; then
        echo "3) Niri (Wayland)"
      fi

      echo ""
      echo "Enter your choice (1-3): "
      read -r choice

      case $choice in
        1)
          if [ -f "$WAYLAND_SESSION_DIR/gnome.desktop" ]; then
            export GNOME_SHELL_SESSION_MODE="wayland"
            exec gnome-session
          else
            echo "GNOME Wayland session not found!"
            exit 1
          fi
          ;;
        2)
          if [ -f "$SESSION_DIR/gnome.desktop" ]; then
            exec gnome-session
          else
            echo "GNOME X11 session not found!"
            exit 1
          fi
          ;;
        3)
          if command -v niri-session >/dev/null 2>&1; then
            exec niri-session
          else
            echo "Niri session not found!"
            exit 1
          fi
          ;;
        *)
          echo "Invalid choice!"
          exit 1
          ;;
      esac
    '')
  ];

  # Create session files for GDM
  environment.etc."wayland-sessions/niri-wayland.desktop".text = ''
    [Desktop Entry]
    Name=Niri (Wayland)
    Comment=Scrollable tiling window manager
    Exec=${pkgs.niri}/bin/niri-session
    Type=Application
    DesktopNames=niri
    Keywords=wm;tiling;wayland;
  '';

  environment.etc."xsessions/niri-x11.desktop".text = ''
    [Desktop Entry]
    Name=Niri (X11)
    Comment=Scrollable tiling window manager
    Exec=${pkgs.niri}/bin/niri-session
    Type=Application
    DesktopNames=niri
    Keywords=wm;tiling;x11;
  '';
}