{
  pkgs,
  lib,
  config,
  globals,
  ...
}: {
  home.packages = with pkgs; [
    pkgs.nodejs_24
    biome
    vue-language-server
    vscode-langservers-extracted
    nil
    typescript-language-server
    typescript
    zed-editor
    astro-language-server
  ];

  # 创建可写的 Zed 默认配置文件
  home.file.".zed-default-settings.json".text = builtins.readFile (./settings.json);

  # 使用 systemd 服务在首次登录时初始化配置
  systemd.user.services.zed-init = {
    Unit = {
      Description = "Initialize Zed settings";
      After = ["home-manager-${globals.user}.service"];
      Wants = ["home-manager-${globals.user}.service"];
    };
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "zed-init" ''
        settings_dir="${globals.homeDir}/.config/zed"
        settings_file="$settings_dir/settings.json"

        # 只在文件不存在时创建默认配置
        if [ ! -f "$settings_file" ]; then
          mkdir -p "$settings_dir"
          cp "${globals.homeDir}/.zed-default-settings.json" "$settings_file"
          chmod 644 "$settings_file"
          echo "Zed 默认配置已创建: $settings_file"
        fi
      '';
      RemainAfterExit = "yes";
    };
  };

  # Zed Wayland 支持
  systemd.user.services.zed-wayland = {
    Unit = {
      Description = "Zed with Wayland support";
    };
    Service = {
      Environment = [
        "ELECTRON_OZONE_PLATFORM_HINT=auto"
        "GTK_IM_MODULE=fcitx"
      ];
    };
  };

  # 确保 Zed 启动时使用正确的环境变量
  home.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
}
