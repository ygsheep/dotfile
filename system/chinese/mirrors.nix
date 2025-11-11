# systems/chinese/mirrors.nix - 中国大陆镜像源配置
{
  config,
  pkgs,
  lib,
  ...
}: {
  # Nix 构建缓存和镜像
  nix.settings = {
    # 二进制缓存替代源（中国大陆优化）
    substituters = [
      # 国内镜像源
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"

      # 官方源作为后备
      "https://cache.nixos.org/"
    ];

    # 对应的公钥
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];

    # 连接优化
    connect-timeout = 60;
    stalled-download-timeout = 300;

    # 并发设置
    max-jobs = "auto";
    max-substitution-jobs = 8;

    # 下载重试
    download-attempts = 3;
  };
}
