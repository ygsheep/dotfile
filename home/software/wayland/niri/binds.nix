{
  config,
  pkgs,
  ...
}: {
  programs.niri.settings.binds = with config.lib.niri.actions; let
    playerctl = spawn "${pkgs.playerctl}/bin/playerctl";
  in {
    "XF86AudioPlay".action = playerctl "play-pause";
    "XF86AudioStop".action = playerctl "pause";
    "XF86AudioPrev".action = playerctl "previous";
    "XF86AudioNext".action = playerctl "next";

    "XF86AudioMicMute" = {
      allow-when-locked = true;
      action.spawn = [
        "qs"
        "-c"
        "DankMaterialShell"
        "ipc"
        "call"
        "audio"
        "micmute"
      ];
    };




    "Ctrl+Alt+L".action = spawn [
      "qs"
      "-c"
      "DankMaterialShell"
      "ipc"
      "call"
      "lock"
      "lock"
    ];

    "Mod+V".action = spawn [
      "qs"
      "-c"
      "DankMaterialShell"
      "ipc"
      "call"
      "clipboard"
      "toggle"
    ];


    "Mod+M".action = spawn [
      "qs"
      "-c"
      "DankMaterialShell"
      "ipc"
      "call"
      "processlist"
      "toggle"
    ];

    "Alt+Space".action = spawn [
      "qs"
      "-c"
      "DankMaterialShell"
      "ipc"
      "call"
      "spotlight"
      "toggle"
    ];

    "Mod+D".action = spawn [
      "qs"
      "-c"
      "DankMaterialShell"
      "ipc"
      "call"
      "spotlight"
      "toggle"
    ];

    "Print".action.screenshot-screen = {write-to-disk = true;};
    "Mod+Shift+Alt+S".action.screenshot-window = {write-to-disk = true;};
    "Mod+Shift+S".action.screenshot = {show-pointer = false;};
    "Mod+Return".action = spawn "${pkgs.ghostty}/bin/ghostty";
    "Mod+R".action = spawn "${pkgs.anyrun}/bin/anyrun";

    # Noctalia 快捷键
    "Mod+Shift+R".action = spawn [
      "noctalia-shell" "ipc" "call" "appLauncher" "toggle"
    ];

    # Noctalia 控制中心
    "Mod+C".action = spawn [
      "noctalia-shell" "ipc" "call" "controlCenter" "toggle"
    ];

    # Noctalia 锁屏 (替代方案)
    "Mod+Ctrl+L".action = spawn [
      "noctalia-shell" "ipc" "call" "lockScreen" "toggle"
    ];

    # 音量控制
    "XF86AudioRaiseVolume".action = spawn [
      "noctalia-shell" "ipc" "call" "volume" "increase"
    ];

    "XF86AudioLowerVolume".action = spawn [
      "noctalia-shell" "ipc" "call" "volume" "decrease"
    ];

    "XF86AudioMute".action = spawn [
      "noctalia-shell" "ipc" "call" "volume" "muteOutput"
    ];

    # 亮度控制
    "XF86MonBrightnessUp".action = spawn [
      "noctalia-shell" "ipc" "call" "brightness" "increase"
    ];

    "XF86MonBrightnessDown".action = spawn [
      "noctalia-shell" "ipc" "call" "brightness" "decrease"
    ];

    "Mod+Q".action = close-window;
    "Mod+S".action = switch-preset-column-width;
    "Mod+F".action = maximize-column;

    "Mod+1".action = set-column-width "25%";
    "Mod+2".action = set-column-width "50%";
    "Mod+3".action = set-column-width "75%";
    "Mod+4".action = set-column-width "100%";
    # "Mod+Shift+F".action = fullscreen-window;
    "Mod+Shift+F".action = expand-column-to-available-width;
    "Mod+Space".action = toggle-window-floating;
    "Mod+W".action = toggle-column-tabbed-display;

    "Mod+Comma".action = consume-window-into-column;
    "Mod+Period".action = expel-window-from-column;
    "Mod+Tab".action = switch-focus-between-floating-and-tiling;

    "Mod+Minus".action = set-column-width "-10%";
    "Mod+Plus".action = set-column-width "+10%";
    "Mod+Shift+Minus".action = set-window-height "-10%";
    "Mod+Shift+Plus".action = set-window-height "+10%";

    "Mod+H".action = focus-column-left;
    "Mod+L".action = focus-column-right;
    "Mod+J".action = focus-window-or-workspace-down;
    "Mod+K".action = focus-window-or-workspace-up;
    "Mod+Left".action = focus-column-left;
    "Mod+Right".action = focus-column-right;
    "Mod+Down".action = focus-workspace-down;
    "Mod+Up".action = focus-workspace-up;

    "Mod+Shift+H".action = move-column-left;
    "Mod+Shift+L".action = move-column-right;
    "Mod+Shift+K".action = move-column-to-workspace-up;
    "Mod+Shift+J".action = move-column-to-workspace-down;

    "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
    "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
  };
}
