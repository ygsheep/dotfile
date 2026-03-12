# Shell 兼容性配置 - 为不支持 NixOS 路径的应用程序创建传统 shell 路径
{
  config,
  pkgs,
  ...
}: {
  # 创建 /bin/bash 符号链接，供需要传统路径的应用程序使用（如 Warp Terminal）
  system.activationScripts.binBash = ''
    mkdir -p /bin
    ln -sf "${pkgs.bash}/bin/bash" /bin/bash
  '';
}
