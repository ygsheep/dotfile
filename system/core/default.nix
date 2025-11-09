{lib, ...}: {
  imports = [
    ./security.nix
    ./users.nix
    #./locale.nix
    ./time-sync.nix
    ../nix
    ../programs/nushell.nix
  ];

  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "zh_CN.UTF-8";
      LC_IDENTIFICATION = "zh_CN.UTF-8";
      LC_MEASUREMENT = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
      LC_NAME = "zh_CN.UTF-8";
      LC_NUMERIC = "zh_CN.UTF-8";
      LC_PAPER = "zh_CN.UTF-8";
      LC_TELEPHONE = "zh_CN.UTF-8";
      LC_TIME = "zh_CN.UTF-8";
      LANG = "zh_CN.UTF-8";
      LANGUAGE = "zh_CN:en_US";
      LC_ALL = "zh_CN.UTF-8";
    };

    # 输入法配置 - 暂时禁用以解决构建问题
    # inputMethod = {
    #   enable = true;
    #   type = "fcitx5";
    # };
  };
  
  # don't touch this
  system.stateVersion = lib.mkDefault "25.05";
  system = {
    switch.enable = true;
    rebuild.enableNg = true;
  };

  time.timeZone = lib.mkDefault "Asia/Shanghai";
  time.hardwareClockInLocalTime = lib.mkDefault true;

  # compresses half the ram for use as swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };
}
