{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    # Go 编译器和工具
    go
    gopls
    delve
    gofumpt
    golangci-lint
    templ
    air

    # Protocol Buffers
    protoc
    protoc-gen-go
    protoc-gen-go-grpc

    # 测试工具
    gotestsum
    gomock

    # 性能分析
    gopprof
    go-torch
  ];

  # 语言服务器配置
  programs.vscode = {
    extensions = with pkgs.vscode-extensions; [
      golang.go
    ];
  };

  # 环境变量
  home.sessionVariables = {
    GOPATH = "${config.home.homeDirectory}/go";
    GOBIN = "${config.home.homeDirectory}/go/bin";
    GOCACHE = "${config.home.homeDirectory}/.cache/go-build";
    GOMODCACHE = "${config.home.homeDirectory}/.cache/go-mod";
    GOPROXY = "https://goproxy.cn,direct";
    GOSUMDB = "sum.golang.google.cn";
    GONOPROXY = "";
    GONOSUMDB = "";
  };
}
