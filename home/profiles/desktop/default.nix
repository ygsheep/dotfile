{
  imports = [
    # editors
    ../../editors/helix
    ../../editors/zed

    # services
    ../../services/wayland/gammastep.nix
    ../../services/wayland/quickshell.nix
    ../../services/wayland/hypridle.nix

    # media services
    ../../services/media/playerctl.nix

    # software
    ../../software
    ../../software/wayland
    ../../software/wayland/astal-shell.nix
    ../../software/anyrun

    # development environments - Nix
  {
    home.packages = with pkgs; [
      alejandra        # Nix 代码格式化工具
      nix-search-tv    # Nix 包搜索工具
      nixd             # Nix 语言服务器
      nil              # Nix 语言服务器（备选）
      nixfmt           # Nix 格式化工具
    ];
  }

  # development environments - Python
  {
    home.packages = with pkgs; [
      python313       # Python 3.13
      uv              # 现代 Python 包管理器
      black           # 代码格式化
      isort           # 导入排序
      ruff            # 代码检查和格式化
      pyright         # 类型检查
    ];
  }

  # development environments - Rust
  {
    home.packages = with pkgs; [
      rustc           # Rust 编译器
      cargo           # Rust 包管理器
      rustfmt         # Rust 代码格式化
      rust-analyzer   # Rust 语言服务器
      clippy          # Rust 代码检查
    ];
  }

  # development environments - JavaScript
  {
    home.packages = with pkgs; [
      nodejs_latest   # 最新版本的 Node.js
      bun             # 快速的 JavaScript 运行时
      pnpm            # 快速、节省磁盘空间的包管理器
      typescript      # TypeScript 编译器
    ];
  }

  # development environments - Go
  {
    home.packages = with pkgs; [
      go              # Go 语言环境
      gopls           # Go 语言服务器
      golangci-lint   # Go 代码检查
    ];
  }

  # general development tools and configuration
  {
    home.packages = with pkgs; [
      git             # Git 版本控制
      gh              # GitHub CLI
      helix           # 现代编辑器
      tmux            # 终端复用器
      starship        # Shell 提示符
      direnv          # 环境变量管理
      fzf             # 模糊查找器
      fd              # 文件查找
      ripgrep         # 文本搜索
      bat             # 更好的 cat
    ];

    # 配置 Starship
    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      settings = {
        format = "$all$character";
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
        git_branch = {
          format = "[$symbol$branch]($style) ";
          symbol = "🌱 ";
        };
        git_status = {
          format = "([\\[$all_status$ahead_behind\\]]($style) )";
          staged = "●";
          modified = "✚";
          untracked = "?";
          ahead = "⇡";
          behind = "⇣";
          diverged = "⇕";
        };
        nodejs = {
          format = "[$symbol($version )]($style)";
          symbol = "⬢ ";
        };
        python = {
          format = "[$symbol$pyenv_prefix($version )($virtualenv )]($style)";
          symbol = "🐍 ";
        };
        rust = {
          format = "[$symbol($version )]($style)";
          symbol = "🦀 ";
        };
        golang = {
          format = "[$symbol($version )]($style)";
          symbol = "🐹 ";
        };
      };
    };

    # 配置 direnv
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
    };
  }

    # system services
    ../../services/system/gpg-agent.nix
    ../../services/system/cliphist.nix
    ../../services/system/polkit-agent.nix
    ../../services/system/power-monitor.nix
  ];
}
