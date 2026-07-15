{
  pkgs,
  lib,
  config,
  globals,
  ...
}: let
  # VS Code 默认配置
  defaultSettings = builtins.toJSON {
    # General settings
    "workbench.colorTheme" = "One Dark Pro Darker";
    "workbench.iconTheme" = "vscode-jetbrains-icon-theme-2023-dark";
    "workbench.startupEditor" = "none";
    "workbench.editor.enablePreview" = false;
    "workbench.editor.showTabs" = true;
    "workbench.editor.tabCloseButton" = "left";
    "workbench.editor.wrapTabs" = true;

    # Editor settings
    "editor.fontSize" = 16;
    "editor.fontFamily" = "'JetBrains Mono', 'monospace', monospace";
    "editor.lineHeight" = 1.6;
    "editor.tabSize" = 2;
    "editor.insertSpaces" = true;
    "editor.wordWrap" = "on";
    "editor.minimap.enabled" = false;
    "editor.renderWhitespace" = "selection";
    "editor.renderControlCharacters" = false;
    "editor.rulers" = [80 120];
    "editor.bracketPairColorization.enabled" = true;
    "editor.guides.bracketPairs" = true;
    "editor.guides.indentation" = true;
    "editor.cursorBlinking" = "smooth";
    "editor.cursorSmoothCaretAnimation" = "on";

    # Terminal settings
    "terminal.integrated.fontSize" = 13;
    "terminal.integrated.fontFamily" = "'JetBrains Mono', 'monospace'";
    "terminal.integrated.shell.linux" = "${pkgs.bash}/bin/bash";

    # File settings
    "files.autoSave" = "afterDelay";
    "files.autoSaveDelay" = 1000;
    "files.trimTrailingWhitespace" = true;
    "files.insertFinalNewline" = true;
    "files.trimFinalNewlines" = true;

    # Search settings
    "search.exclude" = {
      "**/node_modules" = true;
      "**/bower_components" = true;
      "**/*.code-search" = true;
      "**/result" = true;
      "**/.git" = true;
      "**/dist" = true;
      "**/build" = true;
    };

    # Git settings
    "git.enableSmartCommit" = true;
    "git.autofetch" = true;
    "git.confirmSync" = false;
    "git.showInlineOpenFileAction" = false;

    # Python settings
    "python.defaultInterpreterPath" = "${pkgs.python3}/bin/python3";
    "python.formatting.provider" = "black";
    "python.linting.enabled" = true;
    "python.linting.flake8Enabled" = true;
    "python.linting.pylintEnabled" = false;

    # Rust settings
    "rust-analyzer.checkOnSave.command" = "clippy";
    "rust-analyzer.cargo.loadOutDirsFromCheck" = true;
    "rust-analyzer.procMacro.enable" = true;

    # Nix settings
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "${pkgs.nil}/bin/nil";
    "nix.serverSettings" = {
      "nil" = {
        "formatting" = {
          "command" = ["${pkgs.nixfmt}/bin/nixfmt"];
        };
      };
    };

    # Telemetry
    "telemetry.telemetryLevel" = "off";
    "redhat.telemetry.enabled" = false;
    "extensions.autoUpdate" = false;
    "extensions.autoCheckUpdates" = false;

    # Performance
    "editor.semanticTokenColorCustomizations" = {
      "[Dark Plus]" = {
        "enabled" = true;
      };
    };
    "workbench.tree.renderIndentGuides" = "always";
    "workbench.list.smoothScrolling" = true;
    "editor.smoothScrolling" = true;
  };
in {
  programs.vscode = {
    enable = true;
    # package = pkgs.vscodium;
    mutableExtensionsDir = true;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        jnoortheen.nix-ide
      ];
    };
  };

  # 创建可写的 VS Code 配置文件
  home.file.".vscode-default-settings.json".text = defaultSettings;

  # 使用 systemd 服务在首次登录时初始化配置
  systemd.user.services.vscode-init = {
    Unit = {
      Description = "Initialize VS Code settings";
      After = ["home-manager-young.service"];
      Wants = ["home-manager-young.service"];
    };
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "vscode-init" ''
        settings_dir="${globals.homeDir}/.config/Code/User"
        settings_file="$settings_dir/settings.json"

        # 只在文件不存在时创建默认配置
        if [ ! -f "$settings_file" ]; then
          mkdir -p "$settings_dir"
          cp "${globals.homeDir}/.vscode-default-settings.json" "$settings_file"
          chmod 644 "$settings_file"
          echo "VS Code 默认配置已创建: $settings_file"
        fi
      '';
      RemainAfterExit = "yes";
    };
  };

  # VSCode Wayland 支持
  systemd.user.services.vscode-wayland = {
    Unit = {
      Description = "VSCode with Wayland support";
    };
    Service = {
      Environment = [
        "ELECTRON_OZONE_PLATFORM_HINT=auto"
        "GTK_IM_MODULE=fcitx"
      ];
    };
  };

  # 确保 VSCode 启动时使用正确的环境变量
  home.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
}
