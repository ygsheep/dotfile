{ pkgs, config, lib, ... }:

{
  home.packages = with pkgs; [
    # Rust 核心
    rustc               # Rust 编译器
    cargo               # Rust 包管理器
    rustfmt             # Rust 代码格式化
    rust-analyzer       # Rust 语言服务器

    # 开发工具
    clippy              # Rust 代码检查
    cargo-audit         # 安全审计
    cargo-deny          # 依赖检查
    cargo-expand        # 宏展开工具
    cargo-watch         # 文件监控自动构建
    cargo-edit          # Cargo.toml 编辑工具
    cargo-outdated      # 检查过时依赖

    # 交叉编译
    rustc              # 重新添加以确保交叉编译支持
    rust-platform-support linux.musl;

    # 调试工具
    gdb                 # GDB 调试器
    lldb                # LLDB 调试器
    valgrind            # 内存分析工具

    # 性能分析
    perf                # Linux 性能分析
    flamegraph          # 火焰图生成
  ];

  # 语言服务器配置
  programs.vscode = {
    extensions = with pkgs.vscode-extensions; [
      rust-lang.rust-analyzer
      vadimcn.vscode-lldb
      tamasfe.even-better-toml
    ];
  };

  # 环境变量
  home.sessionVariables = {
    RUST_SRC_PATH = "${pkgs.rustPlatform.rustcSrc}/library";
    CARGO_HOME = "${config.home.homeDirectory}/.cargo";
    RUSTUP_HOME = "${config.home.homeDirectory}/.rustup";
  };

  # Cargo 配置
  home.file.".cargo/config.toml".text = ''
    [source.crates-io]
    replace-with = 'ustc'

    [source.ustc]
    registry = "https://mirrors.ustc.edu.cn/crates.io-index"

    [build]
    # 并行编译
    jobs = 8

    [target.x86_64-unknown-linux-gnu]
    # 链接器优化
    linker = "clang"
    rustflags = [
      "-C", "link-arg=-fuse-ld=lld",
    ]

    [profile.dev]
    # 开发模式优化
    opt-level = 0
    debug = true
    overflow-checks = true
    lto = false
    incremental = true
    codegen-units = 256

    [profile.release]
    # 发布模式优化
    opt-level = 3
    debug = false
    lto = true
    incremental = false
    codegen-units = 1
    panic = "abort"
    strip = true

    [registry]
    # 使用国内镜像
    token = "registry"
  '';

  # Clippy 配置
  home.file.".clippy.toml".text = ''
    # Clippy 配置
    max-trait-bounds = 8
    avoid-breaking-exported-api = true
    msrv = "1.70.0"
  '';

  # Git 钩子配置
  home.file.".cargo/hooks/pre-commit".text = ''
    #!/bin/sh
    # Rust 项目预提交钩子

    echo "运行 Rust 预提交检查..."

    # 格式化检查
    echo "检查代码格式..."
    cargo fmt --all -- --check
    if [ $? -ne 0 ]; then
        echo "代码格式不正确，请运行 'cargo fmt' 修复"
        exit 1
    fi

    # Clippy 检查
    echo "运行 Clippy 检查..."
    cargo clippy --all-targets --all-features -- -D warnings
    if [ $? -ne 0 ]; then
        echo "Clippy 检查失败，请修复警告"
        exit 1
    fi

    # 运行测试
    echo "运行测试..."
    cargo test --all-features
    if [ $? -ne 0 ]; then
        echo "测试失败"
        exit 1
    fi

    echo "所有检查通过！"
    exit 0
  '';

  # 使钩子可执行
  home.file.".cargo/hooks/pre-commit".executable = true;

  # 默认的 Cargo 项目模板
  home.file.".cargo/templates/rust-cli/Cargo.toml".text = ''
    [package]
    name = "{{project-name}}"
    version = "0.1.0"
    edition = "2021"
    authors = ["{{authors}}"]
    description = "{{description}}"
    license = "MIT"

    [dependencies]
    anyhow = "1.0"
    clap = { version = "4.0", features = ["derive"] }
    tracing = "0.1"
    tracing-subscriber = "0.3"

    [dev-dependencies]
    tempfile = "3.0"
    assert_cmd = "2.0"
  '';

  home.file.".cargo/templates/rust-cli/src/main.rs".text = ''
    use clap::Parser;
    use anyhow::Result;
    use tracing::{info, error};

    #[derive(Parser, Debug)]
    #[command(name = "{{project-name}}")]
    #[command(about = "{{description}}", long_about = None)]
    struct Args {
        #[arg(short, long)]
        verbose: bool,
    }

    fn main() -> Result<()> {
        tracing_subscriber::fmt::init();

        let args = Args::parse();

        if args.verbose {
            info!("详细模式已启用");
        }

        info!("Hello from {{project-name}}!");

        Ok(())
    }
  '';
}