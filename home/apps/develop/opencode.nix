{
  pkgs,
  globals,
  ...
}: {
  # 启用 xdg 模块（用于 desktop entries）
  xdg.enable = true;
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "text/plain" = "hx.desktop";
  };

  # OpenCode - AI 编码代理
  home.packages = with pkgs; [
    opencode
    opencode-desktop
  ];

  # OpenCode 配置
  home.file.".config/opencode/config.toml".text = ''
    # OpenCode 配置文件
    # 详见: https://github.com/opencode-org/opencode

    [general]
    # 自动检查更新
    auto_update = true

    # 启用遥测（可选）
    telemetry = false

    [ui]
    # 主题设置
    theme = "dark"

    # 字体设置
    font_family = "monospace"

    [editor]
    # 默认编辑器集成
    # 支持: neovim, vscode, helix
    editor = "neovim"

    [ai]
    # AI 模型配置（根据需要设置 API key）
    # api_key = "your-api-key-here"
  '';

  # OpenCode 启动脚本（使用 nix-shell 提供干净环境）
  home.file.".local/bin/opencode-desktop" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # OpenCode Desktop 启动脚本 - 使用 nix-shell

      # 强制使用 X11 后端
      export OC_ALLOW_WAYLAND=0

      # 使用 nix-shell 提供干净环境并启动 OpenCode
      exec nix-shell -p opencode --run "OpenCode $@"
    '';
  };

  # Desktop 快捷方式（使用 globals 避免硬编码）
  home.file.".local/share/applications/OpenCode.desktop".text = ''
    [Desktop Entry]
    Name=OpenCode
    Comment=AI coding agent
    Exec=bash -c 'export PATH="$HOME/.opencode/bin:$HOME/.local/bin:$PATH" && exec opencode-desktop %F'
    Icon=opencode
    Type=Application
    Categories=Development;IDE;
    Terminal=false
  '';
}
