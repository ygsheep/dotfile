{pkgs, ...}: {
  home.packages = with pkgs; [
    # OpenCode - AI 编码代理
    opencode # 终端版本的 AI 编码代理
    opencode-desktop # 桌面客户端
  ];

  # OpenCode 启动脚本（使用 activation 直接创建可执行文件）
  home.activation.createOpenCodeDesktopScript = ''
        mkdir -p ~/.local/bin
        cat > ~/.local/bin/opencode-desktop << 'SCRIPT'
    #!/usr/bin/env bash
    # OpenCode Desktop 启动脚本 - 设置必要的环境变量

    # 找到 libstdc++ 的路径
    LIBSTDCXX_DIR=$(find /nix/store -maxdepth 1 -name "*gcc*lib" -type d 2>/dev/null | head -1)
    if [ -n "$LIBSTDCXX_DIR" ] && [ -d "$LIBSTDCXX_DIR/lib" ]; then
      export LD_LIBRARY_PATH="$LIBSTDCXX_DIR/lib:$LD_LIBRARY_PATH"
    fi

    # 设置 PATH
    export PATH="$HOME/.opencode/bin:$HOME/.local/bin:$PATH"

    # 启动 OpenCode Desktop
    exec OpenCode "$@"
    SCRIPT
        chmod +x ~/.local/bin/opencode-desktop
  '';

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

  # 桌面快捷方式
  xdg.desktopEntries.OpenCode = {
    name = "OpenCode";
    comment = "The open source AI coding agent";
    exec = "opencode-desktop %F";
    icon = "OpenCode";
    type = "Application";
    categories = ["Development" "IDE"];
    terminal = false;
  };
}
