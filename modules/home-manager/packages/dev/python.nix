{ pkgs, config, lib, ... }:

{
  home.packages = with pkgs; [
    # Python 环境
    python313       # Python 3.13
    uv              # 现代 Python 包管理器
    poetry          # Python 依赖管理
    pipx            # Python 应用安装工具

    # 开发工具
    black           # 代码格式化
    isort           # 导入排序
    ruff            # 代码检查和格式化
    mypy            # 类型检查
    pyright         # 类型检查（微软）
    bandit          # 安全检查

    # 构建工具
    setuptools      # 包构建
    wheel           # 包分发
    build           # 现代 Python 构建工具

    # 交互式环境
    ipython         # 增强的 Python REPL
    bpython         # 更友好的 Python REPL

    # 虚拟环境
    virtualenv      # 虚拟环境管理

    # 调试工具
    pdb             # Python 调试器
    ipdb            # 增强的调试器

    # 文档生成
    sphinx          # 文档生成工具
    mkdocs          # 现代 Markdown 文档生成
  ];

  # 语言服务器配置
  programs.vscode = {
    extensions = with pkgs.vscode-extensions; [
      ms-python.python
      ms-python.vscode-pylance
      ms-python.black-formatter
      ms-python.isort
      charliermarsh.ruff
    ];
  };

  # 配置环境变量
  home.sessionVariables = {
    PYTHONPATH = "$HOME/.local/lib/python3.13/site-packages:$PYTHONPATH";
    PYTHONSTARTUP = "$HOME/.pythonstartup";
  };

  # Python 启动脚本
  home.file.".pythonstartup".text = ''
    import readline
    import rlcompleter
    import atexit
    import os

    # 启用 Tab 补全
    readline.parse_and_bind("tab: complete")

    # 历史文件
    history_file = os.path.expanduser("~/.python_history")

    def save_history(history=history_file):
        import readline
        try:
            readline.write_history_file(history)
        except:
            pass

    try:
        readline.read_history_file(history_file)
    except:
        pass

    atexit.register(save_history)

    print("Python ${os.sys.version.split()[0]} - 增强模式")
''';
    print("Tab 补全已启用，历史记录已加载。")
  '';

  # pipx 配置目录
  home.file.".local/share/pipx/venvs".source = pkgs.lib.mkForce (pkgs.runCommand "pipx-venvs" {} ''
    mkdir -p $out
  '');

  # UV 配置
  home.file.".config/uv/uv.toml".text = ''
    [tool.uv]
    # UV 配置
    cache-dir = "$HOME/.cache/uv"

    # 开发模式
    dev-dependencies = true

    # 预编译
    compile-bytecode = true
  '';

  # Ruff 配置
  home.file.".config/ruff/ruff.toml".text = ''
    [tool.ruff]
    line-length = 88
    select = [
        "E",  # pycodestyle errors
        "W",  # pycodestyle warnings
        "F",  # pyflakes
        "I",  # isort
        "B",  # flake8-bugbear
        "C4", # flake8-comprehensions
        "UP", # pyupgrade
    ]
    ignore = [
        "E501",  # line too long, handled by black
        "B008",  # do not perform function calls in argument defaults
        "C901",  # too complex
    ]

    [tool.ruff.format]
    quote-style = "double"
    indent-style = "space"
    skip-magic-trailing-comma = false
    line-ending = "auto"

    [tool.ruff.lint.isort]
    known-first-party = ["src"]
    force-single-line = true
  '';
}