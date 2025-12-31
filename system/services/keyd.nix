# system/services/keyd.nix - Keyd 键盘重映射服务
{
  config,
  pkgs,
  lib,
  globals,
  ...
}: {
  # 启用 keyd 服务
  services.keyd = {
    enable = true;

    # 键盘配置
    keyboards = {
      default = {
        # 检测所有键盘设备
        ids = ["*"];

        # 键盘布局设置
        settings = {
          main = {
            # Caps Lock 配置
            # 单独按下 = Esc
            # 与其他键组合 = Ctrl
            capslock = "overload(control, esc)";

            # 左 Ctrl 作为额外的 Ctrl（可选）
            # leftcontrol = "layer(control)";
          };
        };
      };
    };
  };

  # 确保用户在 input 组中，以访问键盘设备
  users.users.${globals.user}.extraGroups = ["input"];
}
