{
  pkgs,
  inputs,
  config,
  globals,
  ...
}: {
  # 使用统一配置文件
  imports = [./unified.nix];
}
