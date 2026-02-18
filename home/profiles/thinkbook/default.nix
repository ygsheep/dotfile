{
  pkgs,
  lib,
  ...
}: {
  # 继承 desktop profile 的所有配置
  # thinkbook 使用 KDE Plasma 6 + Niri WM
  imports = [../desktop];

  # 覆盖 Niri 显示器缩放配置
  # ThinkBook 内置显示器：2560x1600 @ 120Hz，175% 缩放
  programs.niri.settings.outputs = lib.mkForce {
    "eDP-1" = {
      scale = 1.75;
      position = {
        x = 0;
        y = 0;
      };
    };
    "HDMI-A-1" = {
      mode = {
        width = 2560;
        height = 1600;
        refresh = 120.0;
      };
      scale = 1.75; # 外接显示器也缩放 175%
      position = {
        x = 0;
        y = -1600;
      };
    };
  };

  # HiDPI 2K 显示器 Qt 应用缩放 (2560x1600 @ 120Hz)
  home.sessionVariables = {
    QT_SCALE_FACTOR = "1.75";
  };
}
