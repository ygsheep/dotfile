{pkgs, ...}: {
  home.packages = with pkgs; [
    # Rust 工具链
    rustc
    cargo
    rust-analyzer
    rustfmt
    clippy

    # 开发工具
    cargo-expand # 宏展开工具
    cargo-watch # 文件监控自动构建
    cargo-edit # Cargo.toml 编辑工具
    cargo-outdated # 检查过时依赖

    # 交叉编译
    rustc # 重新添加以确保交叉编译支持
    pkgs.rustPlatform.rustc.target.linux-musl # musl target

    # 调试工具
    gdb # GDB 调试器
    lldb # LLDB 调试器
    valgrind # 内存检查工具

    # 性能分析
    cargo-flamegraph # 火焰图生成
    cargo-criterion # 基准测试
    hyperfine # 命令行性能测试
  ];

  # VSCode 扩展
  # NOTE: Auto-install disabled due to network restrictions in China
  # programs.vscode = {
  #   extensions = with pkgs.vscode-extensions; [
  #     rust-lang.rust-analyzer
  #     vadimcn.vscode-lldb
  #   ];
  # };
}
