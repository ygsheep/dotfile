{
  config,
  pkgs,
  ...
}: let
  pointer = config.home.pointerCursor;
in {
  programs.niri = with config.lib.stylix.colors; {
    enable = true;
    package = pkgs.niri;
    settings = {
      environment = {
        CLUTTER_BACKEND = "wayland";
        GDK_BACKEND = "wayland,x11";
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        SDL_VIDEODRIVER = "wayland";
        _JAVA_AWT_WM_NONREPARENTING = "1";
      };
      spawn-at-startup = [
        {command = ["wl-paste" "--watch" "cliphist" "store"];}
        {command = ["wl-paste" "--type text" "--watch" "cliphist" "store"];}
        {command = ["fcitx5" "-d" "--replace"];} # 启动 Fcitx5 输入法
        {command = ["qs" "-c" "DankMaterialShell"];}
        {command = ["firefox"];} # 启动 Firefox (会自动到工作区 1)
        {command = ["obsidian"];} # 启动 Obsidian (会自动到工作区 3)
        # {command = ["mpvpaper" "ALL" "~/.dotfile/assets/video/andvari-last-origin.3840x2160.mp4"];}
      ];
      input = {
        keyboard.xkb = {
          layout = "cn"; # 中文键盘布局
          # options 由 keyd 接管，不再设置 XKB 选项以避免冲突
          # Caps Lock 功能：单独按 = Esc，组合键 = Ctrl
        };

        touchpad = {
          click-method = "button-areas";
          dwt = true;
          dwtp = true;
          natural-scroll = true;
          scroll-method = "two-finger";
          tap = true;
          tap-button-map = "left-right-middle";
          middle-emulation = true;
          accel-profile = "adaptive";
        };
        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "90%";
        };
        warp-mouse-to-focus.enable = true;
        workspace-auto-back-and-forth = true;
      };
      screenshot-path = "~/Pictures/Screenshots/Screenshot-from-%Y-%m-%d-%H-%M-%S.png";
      outputs = {
        "eDP-1" = {
          scale = 1.0;
          position = {
            x = 0;
            y = 0;
          };
        };
        "HDMI-A-1" = {
          mode = {
            width = 1920;
            height = 1080;
            refresh = null;
          };
          scale = 1.0;
          position = {
            x = 0;
            y = -1080;
          };
        };
      };

      overview = {
        workspace-shadow.enable = false;
        backdrop-color = "#1e1e2e";
      };
      gestures = {hot-corners.enable = true;};
      cursor = {
        size = 20;
        theme = "${pointer.name}";
      };
      layout = {
        focus-ring.enable = false;
        border = {
          enable = true;
          width = 2;
          active.color = "#1e1e2e";
          inactive.color = "#0c0c12";
        };
        shadow = {
          enable = false;
        };
        preset-column-widths = [
          {proportion = 0.25;}
          {proportion = 0.5;}
          {proportion = 0.75;}
          {proportion = 1.0;}
        ];
        default-column-width = {proportion = 0.5;};

        gaps = 6;
        struts = {
          left = 0;
          right = 0;
          top = 0;
          bottom = 0;
        };

        tab-indicator = {
          hide-when-single-tab = true;
          place-within-column = true;
          position = "left";
          corner-radius = 20.0;
          gap = -12.0;
          gaps-between-tabs = 10.0;
          width = 4.0;
          length.total-proportion = 0.1;
        };
      };

      animations.window-resize.custom-shader = ''
        vec4 resize_color(vec3 coords_curr_geo, vec3 size_curr_geo) {
          vec3 coords_next_geo = niri_curr_geo_to_next_geo * coords_curr_geo;

          vec3 coords_stretch = niri_geo_to_tex_next * coords_curr_geo;
          vec3 coords_crop = niri_geo_to_tex_next * coords_next_geo;

          // We can crop if the current window size is smaller than the next window
          // size. One way to tell is by comparing to 1.0 the X and Y scaling
          // coefficients in the current-to-next transformation matrix.
          bool can_crop_by_x = niri_curr_geo_to_next_geo[0][0] <= 1.0;
          bool can_crop_by_y = niri_curr_geo_to_next_geo[1][1] <= 1.0;

          vec3 coords = coords_stretch;
          if (can_crop_by_x)
              coords.x = coords_crop.x;
          if (can_crop_by_y)
              coords.y = coords_crop.y;

          vec4 color = texture2D(niri_tex_next, coords.st);

          // However, when we crop, we also want to crop out anything outside the
          // current geometry. This is because the area of the shader is unspecified
          // and usually bigger than the current geometry, so if we don't fill pixels
          // outside with transparency, the texture will leak out.
          //
          // When stretching, this is not an issue because the area outside will
          // correspond to client-side decoration shadows, which are already supposed
          // to be outside.
          if (can_crop_by_x && (coords_curr_geo.x < 0.0 || 1.0 < coords_curr_geo.x))
              color = vec4(0.0);
          if (can_crop_by_y && (coords_curr_geo.y < 0.0 || 1.0 < coords_curr_geo.y))
              color = vec4(0.0);

          return color;
        }
      '';
      prefer-no-csd = true;
      hotkey-overlay.skip-at-startup = true;

      # ========== 自定义快捷键 ==========
      binds = with config.lib.niri.actions; {
        # Super+D / Super+/ → 启动 Anyrun 应用启动器
        "Super+D".action.spawn = ["anyrun"];
        "Super+Slash".action.spawn = ["anyrun"];
      };

      # ========== 窗口规则 (类似 i3wm 的 assign/for_window) ==========
      window-rules = [
        # ========== 工作区 1: 浏览器 ==========
        {
          matches = [{app-id = "firefox";}];
          open-on-workspace = "1";
          block-out-from = "screencast";
        }
        {
          matches = [{app-id = "zen";}];
          open-on-workspace = "1";
          block-out-from = "screencast";
        }
        {
          matches = [{app-id = "chromium";}];
          open-on-workspace = "1";
          block-out-from = "screencast";
        }
        {
          matches = [{app-id = "microsoft-edge";}];
          open-on-workspace = "1";
          block-out-from = "screencast";
        }

        # ========== 工作区 2: 终端 + 笔记 ==========
        {
          matches = [{app-id = "kitty";}];
          open-on-workspace = "2";
        }
        {
          matches = [{app-id = "ghostty";}];
          open-on-workspace = "2";
        }
        {
          matches = [{app-id = "obsidian";}];
          open-on-workspace = "2";
        }

        # ========== 工作区 3: 开发 ==========
        {
          matches = [{app-id = "jetbrains-*";}];
          open-on-workspace = "3";
        }
        {
          matches = [{app-id = "code";}];
          open-on-workspace = "3";
        }
        {
          matches = [{app-id = "zed";}];
          open-on-workspace = "3";
        }
        {
          matches = [{app-id = "github-desktop";}];
          open-on-workspace = "3";
        }
        {
          matches = [{app-id = "lazygit";}];
          open-on-workspace = "3";
          open-floating = true;
        }

        # ========== 工作区 4: 创作/3D (原 ws-5) ==========
        {
          matches = [{app-id = "godot";}];
          open-on-workspace = "4";
          block-out-from = "screencast";
        }
        {
          matches = [{app-id = "blender";}];
          open-on-workspace = "4";
        }
        {
          matches = [{app-id = "inkscape";}];
          open-on-workspace = "4";
        }

        # ========== 工作区 5: 通讯 (原 ws-4) ==========
        {
          matches = [{app-id = "wechat";}];
          open-on-workspace = "5";
        }
        {
          matches = [{app-id = "com.wechat.WeChat";}];
          open-on-workspace = "5";
        }
        {
          matches = [{app-id = "telegram-desktop";}];
          open-on-workspace = "5";
        }
        {
          matches = [{app-id = "org.telegram.desktop";}];
          open-on-workspace = "5";
        }
        {
          matches = [{app-id = "discord";}];
          open-on-workspace = "5";
        }
        {
          matches = [{app-id = "vesktop";}];
          open-on-workspace = "5";
        }

        # ========== 工作区 6: 媒体工具 ==========
        {
          matches = [{app-id = "obs";}];
          open-on-workspace = "6";
        }
        {
          matches = [{app-id = "celluloid";}];
          open-on-workspace = "6";
        }
        {
          matches = [{app-id = "amberol";}];
          open-on-workspace = "6";
        }
        {
          matches = [{app-id = "mpv";}];
          open-on-workspace = "6";
          open-floating = true;
        }
        {
          matches = [{app-id = "spotify";}];
          open-on-workspace = "6";
        }

        # ========== 工作区 7: AI/数据 ==========
        {
          matches = [{app-id = "lmstudio";}];
          open-on-workspace = "7";
        }
        {
          matches = [{app-id = "sqlitestudio";}];
          open-on-workspace = "7";
        }

        # ========== 工作区 8: 游戏 ==========
        {
          matches = [{app-id = "steam";}];
          open-on-workspace = "8";
          block-out-from = "screencast";
        }

        # ========== 浮动窗口 ==========
        # 设置对话框
        {
          matches = [
            {
              is-floating = true;
              app-id = "org.gnome.*";
            }
          ];
        }
        {
          matches = [{title = ".*Preferences.*";}];
          open-floating = true;
        }
        {
          matches = [{title = ".*Settings.*";}];
          open-floating = true;
        }
        {
          matches = [{title = ".*设置.*";}];
          open-floating = true;
        }

        # 文件管理器 → 始终浮动
        {
          matches = [{app-id = "org.gnome.Nautilus";}];
          open-floating = true;
        }
        {
          matches = [{app-id = "dolphin";}];
          open-floating = true;
        }
        {
          matches = [{app-id = "org.kde.dolphin";}];
          open-floating = true;
        }

        # PDF 阅读器
        {
          matches = [{app-id = "org.gnome.Evince";}];
          open-floating = true;
        }
        {
          matches = [{app-id = "papers";}];
          open-floating = true;
        }

        # 图片查看器
        {
          matches = [{app-id = "loupe";}];
          open-floating = true;
        }
        {
          matches = [{app-id = "org.gnome.Loupe";}];
          open-floating = true;
        }

        # 文本编辑器 (小工具)
        {
          matches = [{app-id = "gnome-text-editor";}];
          open-floating = true;
        }

        # 配置编辑器
        {
          matches = [{app-id = "dconf-editor";}];
          open-floating = true;
        }

        # 文件传输
        {
          matches = [{app-id = "localsend";}];
          open-floating = true;
        }
      ];
    };
  };
}
