{
  config,
  pkgs,
  ...
}: {
  # NPM 全局包安装配置
  home.sessionVariables = {
    # 设置 npm 全局包安装路径到用户目录
    NPM_CONFIG_PREFIX = "${config.xdg.dataHome}/npm";
    NODE_PATH = "${config.xdg.dataHome}/npm/lib/node_modules";
  };

  # 创建 .npmrc 配置文件（在用户主目录）
  home.file.".npmrc".text = ''
    prefix=${config.xdg.dataHome}/npm
    cache=${config.home.homeDirectory}/.npm
    init-module=${config.home.homeDirectory}/.npm-init.js
  '';

  # 确保 npm 目录存在
  home.file."${config.xdg.dataHome}/npm/.gitkeep".text = "";
}
