{
  pkgs,
  config,
  lib,
  ...
}: {
  # 导入所有开发环境模块
  imports = [
    ./nix.nix
    ./python.nix
    ./rust.nix
    ./javascript.nix
    ./go.nix
  ];

  # 通用开发工具
  home.packages = with pkgs; [
    # 版本控制
    git # Git 版本控制
    git-lfs # Git 大文件支持
    gh # GitHub CLI
    glab # GitLab CLI

    # 编辑器和工具
    vim # Vim 编辑器
    neovim # Neovim 编辑器
    helix # 现代编辑器
    micro # 简单终端编辑器

    # 系统工具
    htop # 进程监控
    btop # 更好的进程监控
    fd # 文件查找
    ripgrep # 文本搜索
    fzf # 模糊查找器
    tree # 目录树
    bat # 更好的 cat
    exa # 更好的 ls

    # 网络工具
    curl # HTTP 客户端
    wget # 文件下载
    httpie # 更好的 HTTP 客户端
    nmap # 网络扫描
    wireshark-cli # 网络分析

    # 开发工具
    tmux # 终端复用器
    zellij # 现代终端复用器
    starship # Shell 提示符
    direnv # 环境变量管理
    just # 命令运行器
    make # 构建工具

    # 容器和虚拟化
    docker # Docker CLI
    docker-compose # Docker Compose
    podman # 无 Docker 守护进程的容器
    qemu # 虚拟化

    # 监控和分析
    strace # 系统调用跟踪
    ltrace # 库函数跟踪
    perf # 性能分析
    valgrind # 内存分析

    # 数据库工具
    sqlite # SQLite 数据库
    postgresql # PostgreSQL 客户端
    mysql-client # MySQL 客户端
    redis # Redis 客户端

    # 云和 DevOps
    kubectl # Kubernetes CLI
    helm # Kubernetes 包管理
    terraform # 基础设施即代码
    ansible # 自动化配置
    nomad # 工作负载调度器

    # 安全工具
    gnupg # GPG 加密
    openssl # SSL/TLS 工具
    sshpass # SSH 密码认证
    keychain # SSH 代理管理

    # 压缩和解压
    zip # ZIP 压缩
    unzip # ZIP 解压
    tar # TAR 工具
    gzip # GZIP 压缩
    p7zip # 7-Zip 压缩

    # 其他工具
    jq # JSON 处理
    yq # YAML 处理
    xmlstarlet # XML 处理
    bc # 计算器
    calc # 科学计算器
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
      docker_context = {
        format = "[$symbol$context]($style) ";
        symbol = "🐳 ";
      };
      kubernetes = {
        format = "[$symbol$context( \\($namespace\\))]($style) ";
        symbol = "☸ ";
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
    stdlib = ''
      # layout definition
      layout_poetry() {
        if [[ ! -f pyproject.toml ]]; then
          log_error 'No pyproject.toml found. Use `poetry new` or `poetry init` to create one first.'
          exit 2
        fi

        local VENV=$(dirname $(poetry run which python))
        export VIRTUAL_ENV=$(echo "$VENV" | rev | cut -d'/' -f2- | rev)
        export POETRY_ACTIVE=1
        PATH_add "$VENV"
      }

      layout_go() {
        export GOPATH="$PWD/go"
        export GOBIN="$GOPATH/bin"
        PATH_add "$GOBIN"
      }

      layout_node() {
        export NODE_VERSION="$(node --version)"
        export NPM_CONFIG_PREFIX="$PWD/.npm-global"
        PATH_add "$NPM_CONFIG_PREFIX/bin"
      }
    '';
  };

  # 配置 fzf
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--border"
      "--preview 'bat --color=always --style=header,grid --line-range :300 {}'"
      "--preview-window 'right:60%'"
    ];
  };

  # 配置 Git
  programs.git = {
    enable = true;
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "!gitk";
      graph = "log --oneline --graph --decorate --all";
      amend = "commit --amend";
      whoops = "commit --amend --no-edit";
    };
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      merge.conflictstyle = "diff3";
      diff.algorithm = "patience";
      core.editor = "hx";
      core.pager = "delta";
      delta = {
        enable = true;
        line-numbers = true;
        side-by-side = true;
        navigate = true;
      };
    };
    ignores = [
      "*~"
      "*.swp"
      "*.swo"
      ".DS_Store"
      "node_modules/"
      ".env"
      ".venv/"
      "target/"
      "dist/"
      "build/"
      "*.log"
    ];
  };

  # 配置 tmux
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    historyLimit = 100000;
    keyMode = "vi";
    sensibleOnTop = true;
    extraConfig = ''
      # 基本设置
      set -g mouse on
      set -g base-index 1
      setw -g pane-base-index 1

      # 重新绑定快捷键
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      # 分割窗口
      bind | split-window -h
      bind - split-window -v

      # 状态栏
      set -g status-position bottom
      set -g status-bg black
      set -g status-fg white
      set -g status-interval 60
      set -g status-left-length 30
      set -g status-left '#[fg=green](#S) #(whoami)'
      set -g status-right '#[fg=yellow]#(cut -d " " -f 1-3 /proc/loadavg)#[default] #[fg=cyan]%Y-%m-%d %H:%M#[default]'

      # 窗格状态栏
      set -g window-status-current-format '#[bg=blue,fg white,bold] #I #W '
      set -g window-status-format '#[bg=black,fg white] #I #W '

      # 复制模式
      setw -g mode-keys vi
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel
    '';
  };

  # 环境变量
  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    PAGER = "less";
    LESS = "-R";
    LANG = "zh_CN.UTF-8";
    LC_ALL = "zh_CN.UTF-8";
    TZ = "Asia/Shanghai";
  };
}
