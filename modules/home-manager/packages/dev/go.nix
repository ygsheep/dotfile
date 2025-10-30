{ pkgs, config, lib, ... }:

{
  home.packages = with pkgs; [
    # Go 核心
    go                 # Go 语言环境

    # 开发工具
    gopls              # Go 语言服务器
    golangci-lint      # Go 代码检查
    delve              # Go 调试器
    gofumpt            # Go 代码格式化
    goimports          # 导入整理
    golines            # 长行格式化

    # 工具链
    go-tools           # Go 工具集合
    go-swagger         # Swagger 文档生成
    protobuf           # Protocol Buffers
    protoc-gen-go      # Go protobuf 插件
    protoc-gen-go-grpc # gRPC protobuf 插件

    # 测试工具
    gotestsum          # 测试运行器
    gomock             # Mock 生成器

    # 性能分析
    gopprof            # 性能分析工具
    go-torch           # 火焰图生成
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
  ];

  # 创建 Go 目录结构
  home.file."go/bin/.keep".text = "";
  home.file."go/src/.keep".text = "";
  home.file."go/pkg/.keep".text = "";

  # Go 全局配置
  home.file.".config/go/env".text = ''
    # Go 环境配置
    GOPROXY=https://goproxy.cn,direct
    GOSUMDB=sum.golang.google.cn
    GOCACHE=${config.home.homeDirectory}/.cache/go-build
    GOMODCACHE=${config.home.homeDirectory}/.cache/go-mod

    # 编译优化
    GOFLAGS=-modcacherw
    CGO_ENABLED=1

    # 调试
    GO111MODULE=on
  '';

  # golangci-lint 配置
  home.file.".config/golangci/.golangci.yml".text = ''
    run:
      timeout: 5m
      tests: true
      skip-dirs:
        - vendor
        - testdata
      skip-files:
        - ".*\\.pb\\.go$"

    output:
      format: colored-line-number
      print-issued-lines: true
      print-linter-name: true
      uniq-by-line: true
      sort-results: true

    linters-settings:
      govet:
        check-shadowing: true
        enable-all: true
        disable:
          - fieldalignment # 太严格
      golint:
        min-confidence: 0.8
      gocyclo:
        min-complexity: 15
      maligned:
        suggest-new: true
      dupl:
        threshold: 100
      goconst:
        min-len: 2
        min-occurrences: 2
      misspell:
        locale: US
      lll:
        line-length: 140
      goimports:
        local-prefixes: github.com/yourorg/yourproject
      gocritic:
        enabled-tags:
          - diagnostic
          - experimental
          - opinionated
          - performance
          - style
        disabled-checks:
          - dupImport
          - ifElseChain
          - octalLiteral
          - whyNoLint
          - wrapperFunc

    linters:
      enable:
        - bodyclose
        - deadcode
        - depguard
        - dogsled
        - dupl
        - errcheck
        - funlen
        - gochecknoinits
        - goconst
        - gocritic
        - gocyclo
        - gofmt
        - goimports
        - golint
        - gomnd
        - goprintffuncname
        - gosec
        - gosimple
        - govet
        - ineffassign
        - interfacer
        - lll
        - misspell
        - nakedret
        - rowserrcheck
        - scopelint
        - staticcheck
        - structcheck
        - stylecheck
        - typecheck
        - unconvert
        - unparam
        - unused
        - varcheck
        - whitespace

    issues:
      exclude-rules:
        - path: _test\.go
          linters:
            - gomnd
            - funlen
            - goconst
      max-issues-per-linter: 0
      max-same-issues: 0
      new-from-rev: ""
  '';

  # Git 钩子
  home.file.".config/git/hooks/go-pre-commit".text = ''
    #!/bin/sh
    # Go 项目预提交钩子

    echo "运行 Go 预提交检查..."

    # 格式化检查
    echo "检查代码格式..."
    gofumpt -l .
    if [ $? -ne 0 ]; then
        echo "代码格式不正确，请运行 'gofumpt -w .' 修复"
        exit 1
    fi

    # 导入检查
    echo "检查导入..."
    goimports -l .
    if [ $? -ne 0 ]; then
        echo "导入不正确，请运行 'goimports -w .' 修复"
        exit 1
    fi

    # 代码检查
    echo "运行 golangci-lint..."
    golangci-lint run
    if [ $? -ne 0 ]; then
        echo "代码检查失败"
        exit 1
    fi

    # 运行测试
    echo "运行测试..."
    go test ./...
    if [ $? -ne 0 ]; then
        echo "测试失败"
        exit 1
    fi

    # 构建
    echo "构建项目..."
    go build ./...
    if [ $? -ne 0 ]; then
        echo "构建失败"
        exit 1
    fi

    echo "所有检查通过！"
    exit 0
  '';

  # 使钩子可执行
  home.file.".config/git/hooks/go-pre-commit".executable = true;

  # Go 项目模板
  home.file."go/src/template/go.mod".text = ''
    module github.com/yourusername/projectname

    go 1.21

    require (
      github.com/spf13/cobra v1.7.0
      github.com/spf13/viper v1.16.0
      go.uber.org/zap v1.25.0
    )
  '';

  home.file."go/src/template/cmd/root.go".text = ''
    package cmd

    import (
        "fmt"
        "os"

        "github.com/spf13/cobra"
        "github.com/spf13/viper"
        "go.uber.org/zap"
    )

    var (
        cfgFile string
        logger   *zap.Logger
    )

    var rootCmd = &cobra.Command{
        Use:   "projectname",
        Short: "A brief description of your application",
        Long:  `A longer description that spans multiple lines`,
        Run: func(cmd *cobra.Command, args []string) {
            logger.Info("Application started")
            fmt.Println("Hello from projectname!")
        },
    }

    func Execute() {
        if err := rootCmd.Execute(); err != nil {
            os.Exit(1)
        }
    }

    func init() {
        cobra.OnInitialize(initConfig)
        cobra.OnInitialize(initLogger)

        rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "config file (default is $HOME/.projectname.yaml)")
        viper.BindPFlag("config", rootCmd.PersistentFlags().Lookup("config"))
    }

    func initConfig() {
        if cfgFile != "" {
            viper.SetConfigFile(cfgFile)
        } else {
            home, err := os.UserHomeDir()
            cobra.CheckErr(err)

            viper.AddConfigPath(home)
            viper.AddConfigPath(".")
            viper.SetConfigType("yaml")
            viper.SetConfigName(".projectname")
        }

        viper.AutomaticEnv()

        if err := viper.ReadInConfig(); err == nil {
            fmt.Println("Using config file:", viper.ConfigFileUsed())
        }
    }

    func initLogger() {
        var err error
        logger, err = zap.NewProduction()
        if err != nil {
            panic(err)
        }
    }
  '';
}