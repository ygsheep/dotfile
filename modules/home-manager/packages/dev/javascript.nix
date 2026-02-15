{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # Node.js 环境
    pkgs.nodejs_24 # Node.js 24 LTS
    bun # 快速的 JavaScript 运行时
    deno # 安全的 TypeScript 运行时

    # 包管理器
    pnpm # 快速、节省磁盘空间的包管理器
    yarn-berry # Yarn 2+ (Berry)
    npm # 默认的 Node.js 包管理器

    # 构建工具
    webpack # 模块打包器
    rollup # 模块打包器
    vite # 现代前端构建工具
    esbuild # 极快的 JavaScript 打包器
    parcel # 零配置构建工具
    turborepo # TypeScript 构建系统

    # TypeScript 支持
    typescript # TypeScript 编译器
    ts-node # 直接运行 TypeScript
    tsx # 快速的 TypeScript 执行器

    # 代码质量
    eslint # JavaScript 代码检查
    prettier # 代码格式化
    eslint_d # ESLint 守护进程

    # 测试工具
    jest # JavaScript 测试框架
    vitest # Vite 原生测试框架
    playwright # 端到端测试
    cypress # 端到端测试框架

    # 开发工具
    nodemon # 文件监控自动重启
    concurrently # 并行运行脚本
    cross-env # 跨平台环境变量设置
    dotenv-cli # 环境变量管理

    # LSP 和开发服务器
    typescript-language-server
    vscode-langservers-extracted
    tailwindcss
    postcss
    autoprefixer
  ];

  # 语言服务器配置
  # NOTE: Auto-install disabled due to network restrictions in China
  # programs.vscode = {
  #   extensions = with pkgs.vscode-extensions; [
  #     ms-vscode.vscode-typescript-next
  #     bradlc.vscode-tailwindcss
  #     esbenp.prettier-vscode
  #     ms-vscode.vscode-eslint
  #     vitejs.vite
  #   ];
  # };

  # 环境变量
  home.sessionVariables = {
    NODE_ENV = "development";
    NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
    PNPM_HOME = "${config.home.homeDirectory}/.local/share/pnpm";
    DENO_INSTALL = "${config.home.homeDirectory}/.local/bin";
    BUN_INSTALL = "${config.home.homeDirectory}/.bun/bin";
  };

  # npm 配置
  home.file.".npmrc".text = ''
    # npm 配置
    prefix = ${config.home.homeDirectory}/.npm-global
    registry = https://registry.npmmirror.com/
    save-exact = true
    fund = false
    audit = false

    # 镜像配置
    disturl = https://npmmirror.com/mirrors/node
    electron_mirror = https://npmmirror.com/mirrors/electron/
    sass_binary_site = https://npmmirror.com/mirrors/node-sass/
    phantomjs_cdnurl = https://npmmirror.com/mirrors/phantomjs/
    chromedriver_cdnurl = https://npmmirror.com/mirrors/chromedriver/
    operadriver_cdnurl = https://npmmirror.com/mirrors/operadriver/
    fse_binary_host_mirror = https://npmmirror.com/mirrors/fsevents/
    node_inspector_cdnurl = https://npmmirror.com/mirrors/node-inspector/
    nodejs_org_mirror = https://npmmirror.com/mirrors/node/
    npm_config_disturl = https://npmmirror.com/dist
  '';

  # pnpm 配置
  home.file.".pnpmrc".text = ''
    # pnpm 配置
    registry = https://registry.npmmirror.com/
    shamefully-hoist = true
    strict-peer-dependencies = false
    save-workspace-protocol = true

    # 存储
    store-dir = ${config.home.homeDirectory}/.pnpm-store
  '';

  # Yarn 配置
  home.file.".yarnrc.yml".text = ''
    # Yarn Berry 配置
    yarnPath: .yarn/releases/yarn-berry.cjs
    enableGlobalCache: false
    globalFolder: ${config.home.homeDirectory}/.yarn/global
    cacheFolder: ${config.home.homeDirectory}/.yarn/cache
    nodeLinker: node-modules

    # 镜像配置
    npmRegistryServer: "https://registry.npmmirror.com/"
  '';

  # TypeScript 配置
  home.file.".config/typescript/tsconfig.base.json".text = ''
    {
      "compilerOptions": {
        "target": "ES2022",
        "module": "ESNext",
        "lib": ["ES2022", "DOM", "DOM.Iterable"],
        "moduleResolution": "bundler",
        "allowImportingTsExtensions": true,
        "allowSyntheticDefaultImports": true,
        "esModuleInterop": true,
        "allowJs": true,
        "checkJs": false,
        "jsx": "react-jsx",
        "strict": true,
        "noUnusedLocals": true,
        "noUnusedParameters": true,
        "noFallthroughCasesInSwitch": true,
        "skipLibCheck": true,
        "forceConsistentCasingInFileNames": true,
        "resolveJsonModule": true,
        "isolatedModules": true,
        "moduleDetection": "force",
        "incremental": true,
        "declaration": true,
        "declarationMap": true,
        "sourceMap": true,
        "removeComments": false,
        "noEmit": false,
        "outDir": "./dist"
      },
      "include": [
        "**/*.ts",
        "**/*.tsx",
        "**/*.js",
        "**/*.jsx"
      ],
      "exclude": [
        "node_modules",
        "dist",
        "build"
      ]
    }
  '';

  # ESLint 配置
  home.file.".config/eslint/.eslintrc.base.js".text = ''
    module.exports = {
      env: {
        browser: true,
        es2022: true,
        node: true,
      },
      extends: [
        'eslint:recommended',
        '@typescript-eslint/recommended',
        'prettier',
      ],
      parser: '@typescript-eslint/parser',
      parserOptions: {
        ecmaVersion: 'latest',
        sourceType: 'module',
      },
      plugins: ['@typescript-eslint'],
      rules: {
        'no-unused-vars': 'off',
        '@typescript-eslint/no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
        '@typescript-eslint/explicit-function-return-type': 'off',
        '@typescript-eslint/explicit-module-boundary-types': 'off',
        '@typescript-eslint/no-explicit-any': 'warn',
        'prefer-const': 'error',
        'no-var': 'error',
      },
    };
  '';

  # Prettier 配置
  home.file.".config/prettier/.prettierrc".text = ''
    {
      "semi": false,
      "trailingComma": "es5",
      "singleQuote": true,
      "printWidth": 80,
      "tabWidth": 2,
      "useTabs": false,
      "bracketSpacing": true,
      "bracketSameLine": false,
      "arrowParens": "avoid",
      "endOfLine": "lf"
    }
  '';

  # 创建全局包目录
  home.file.".npm-global".source = pkgs.lib.mkForce (pkgs.runCommand "npm-global" {} ''
    mkdir -p $out/{bin,lib}
  '');
}
