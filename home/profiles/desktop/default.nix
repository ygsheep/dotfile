{
  pkgs,
  lib,
  ...
}: {
  imports = [
    # editors
    ../../editors/helix
    ../../editors/zed
    ../../editors/vscode

    # terminal
    ../../cli/terminal/emulators/kitty.nix

    # services
    ../../services/wayland/gammastep.nix
    ../../services/wayland/quickshell.nix
    ../../services/wayland/hypridle.nix

    # media services
    ../../services/media/playerctl.nix

    # apps
    ../../apps
    ../../apps/anyrun

    # system services
    ../../services/system/gpg-agent.nix
    ../../services/system/cliphist.nix
    ../../services/system/polkit-agent.nix
    ../../services/system/power-monitor.nix

    # develop tools
    ../../apps/develop/default.nix
  ];

  # 所有开发环境和工具的包
  home.packages = with pkgs; [
    # development environments - Nix
    alejandra # Nix 代码格式化工具
    nix-search-tv # Nix 包搜索工具
    nixd # Nix 语言服务器
    nil # Nix 语言服务器（备选）
    nixfmt # Nix 格式化工具

    # development environments - Python
    python313 # Python 3.13
    uv # 现代 Python 包管理器
    black # 代码格式化
    isort # 导入排序
    ruff # 代码检查和格式化
    pyright # 类型检查

    # development environments - Rust
    rustc # Rust 编译器
    cargo # Rust 包管理器
    rustfmt # Rust 代码格式化
    rust-analyzer # Rust 语言服务器
    clippy # Rust 代码检查

    # development environments - JavaScript
    pkgs.nodejs_24 # Node.js 24 LTS
    bun # 快速的 JavaScript 运行时
    pnpm # 快速、节省磁盘空间的包管理器
    typescript # TypeScript 编译器

    # development environments - Go
    go # Go 语言环境
    gopls # Go 语言服务器
    golangci-lint # Go 代码检查

    # general development tools and configuration
    git # Git 版本控制
    gh # GitHub CLI
    helix # 现代编辑器
    tmux # 终端复用器
    starship # Shell 提示符
    direnv # 环境变量管理
    fzf # 模糊查找器
    fd # 文件查找
    ripgrep # 文本搜索
    bat # 更好的 cat
  ];

  # 配置 Starship
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    settings = {
      format = lib.mkForce "$all$character";
      character = {
        success_symbol = lib.mkForce "[➜](bold green)";
        error_symbol = lib.mkForce "[✗](bold red) ";
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
