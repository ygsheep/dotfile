{
  pkgs,
  globals,
  ...
}: {
  networking = {
    nameservers = ["1.1.1.1" "1.0.0.1"];

    nftables.enable = true;

    networkmanager = {
      enable = true;
      dns = "none";
      wifi.powersave = true;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };

    useDHCP = false;
    dhcpcd.enable = false;
  };

  # 系统级代理环境变量
  environment.variables = {
    # HTTP 代理
    http_proxy = "http://${globals.proxy.host}:${toString globals.proxy.httpPort}";
    HTTP_PROXY = "http://${globals.proxy.host}:${toString globals.proxy.httpPort}";
    https_proxy = "http://${globals.proxy.host}:${toString globals.proxy.httpsPort}";
    HTTPS_PROXY = "http://${globals.proxy.host}:${toString globals.proxy.httpsPort}";

    # SOCKS5 代理（备用）
    socks_proxy = "socks5://${globals.proxy.host}:${toString globals.proxy.socksPort}";
    SOCKS_PROXY = "socks5://${globals.proxy.host}:${toString globals.proxy.socksPort}";

    # 不走代理的地址
    no_proxy = globals.proxy.noProxy;
    NO_PROXY = globals.proxy.noProxy;
  };

  # 为所有用户会话设置代理
  environment.sessionVariables = {
    http_proxy = "http://${globals.proxy.host}:${toString globals.proxy.httpPort}";
    HTTP_PROXY = "http://${globals.proxy.host}:${toString globals.proxy.httpPort}";
    https_proxy = "http://${globals.proxy.host}:${toString globals.proxy.httpsPort}";
    HTTPS_PROXY = "http://${globals.proxy.host}:${toString globals.proxy.httpsPort}";
    no_proxy = globals.proxy.noProxy;
    NO_PROXY = globals.proxy.noProxy;
  };

  # KDE Connect 防火墙规则
  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
  };

  services = {
    openssh = {
      enable = true;
      settings.UseDns = true;
    };
  };

  # systemd 服务的代理配置
  systemd.services = {
    # 为 nix-daemon 设置代理
    nix-daemon.environment = {
      http_proxy = "http://${globals.proxy.host}:${toString globals.proxy.httpPort}";
      HTTP_PROXY = "http://${globals.proxy.host}:${toString globals.proxy.httpPort}";
      https_proxy = "http://${globals.proxy.host}:${toString globals.proxy.httpsPort}";
      HTTPS_PROXY = "http://${globals.proxy.host}:${toString globals.proxy.httpsPort}";
      no_proxy = "localhost,${globals.proxy.host},::1,.local,.lan";
      NO_PROXY = "localhost,${globals.proxy.host},::1,.local,.lan";
    };
  };

  # Don't wait for network startup
  systemd.services.NetworkManager-wait-online.serviceConfig.ExecStart = ["" "${pkgs.networkmanager}/bin/nm-online -q"];
  environment.etc.hosts.enable = false;
}
