{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.vscode = {
    enable = true;
    # package = pkgs.vscodium;
    profiles.default = {
      extensions = [];

      userSettings = {
        # General settings
        "workbench.colorTheme" = "Dracula";
        "workbench.iconTheme" = "vscode-jetbrains-icon-theme-2023-dark";
        "workbench.startupEditor" = "none";
        "workbench.editor.enablePreview" = false;
        "workbench.editor.showTabs" = true;
        "workbench.editor.tabCloseButton" = "left";
        "workbench.editor.wrapTabs" = true;

        # Editor settings
        "editor.fontSize" = 14;
        "editor.fontFamily" = lib.mkForce "'JetBrains Mono', 'monospace', monospace";
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
