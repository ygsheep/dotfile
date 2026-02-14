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

  # 系统级代理环境变量（已禁用）
  # environment.variables = {
  #   # HTTP 代理
  #   http_proxy = "http://${globals.proxy.host}:${toString globals.proxy.httpPort}";
  #   HTTP_PROXY = "http://${globals.proxy.host}:${toString globals.proxy.httpPort}";
  #   https_proxy = "http://${globals.proxy.host}:${toString globals.proxy.httpsPort}";
  #   HTTPS_PROXY = "http://${globals.proxy.host}:${toString globals.proxy.httpsPort}";
  #
  #   # SOCKS5 代理（备用）
  #   socks_proxy = "socks5://${globals.proxy.host}:${toString globals.proxy.socksPort}";
  #   SOCKS_PROXY = "socks5://${globals.proxy.host}:${toString globals.proxy.socksPort}";
  #
  #   # 不走代理的地址
  #   no_proxy = globals.proxy.noProxy;
  #   NO_PROXY = globals.proxy.noProxy;
  # };

  # 为所有用户会话设置代理（已禁用）
  # environment.sessionVariables = {
  #   http_proxy = "http://${globals.proxy.host}:${toString globals.proxy.httpPort}";
  #   HTTP_PROXY = "http://${globals.proxy.host}:${toString globals.proxy.httpPort}";
  #   https_proxy = "http://${globals.proxy.host}:${toString globals.proxy.httpsPort}";
  #   HTTPS_PROXY = "http://${globals.proxy.host}:${toString globals.proxy.httpsPort}";
  #   no_proxy = globals.proxy.noProxy;
  #   NO_PROXY = globals.proxy.noProxy;
  # };

  services = {
    openssh = {
      enable = true;
      settings.UseDns = true;
    };
  };

  # systemd 服务的代理配置（已禁用）
  # systemd.services = {
  #   # 为 nix-daemon 设置代理
  #   nix-daemon.environment = {
  #     http_proxy = "http://${globals.proxy.host}:${toString globals.proxy.httpPort}";
  #     HTTP_PROXY = "http://${globals.proxy.host}:${toString globals.proxy.httpPort}";
  #     https_proxy = "http://${globals.proxy.host}:${toString globals.proxy.httpsPort}";
  #     HTTPS_PROXY = "http://${globals.proxy.host}:${toString globals.proxy.httpsPort}";
  #     no_proxy = "localhost,${globals.proxy.host},::1,.local,.lan";
  #     NO_PROXY = "localhost,${globals.proxy.host},::1,.local,.lan";
  #   };
  # };

  # Don't wait for network startup
  systemd.services.NetworkManager-wait-online.serviceConfig.ExecStart = ["" "${pkgs.networkmanager}/bin/nm-online -q"];
  environment.etc.hosts.enable = false;

  # 创建代理管理脚本（已禁用）
  # environment.systemPackages = with pkgs; [
  #   (writeShellScriptBin "proxy-on" ''
  #     # 启用代理
  #     export http_proxy="http://${globals.proxy.host}:${toString globals.proxy.httpPort}"
  #     export HTTP_PROXY="http://${globals.proxy.host}:${toString globals.proxy.httpPort}"
  #     export https_proxy="http://${globals.proxy.host}:${toString globals.proxy.httpsPort}"
  #     export HTTPS_PROXY="http://${globals.proxy.host}:${toString globals.proxy.httpsPort}"
  #     export no_proxy="${globals.proxy.noProxy}"
  #     export NO_PROXY="${globals.proxy.noProxy}"
  #
  #     echo "✅ 代理已启用:"
  #     echo "   HTTP 代理: http://${globals.proxy.host}:${toString globals.proxy.httpPort}"
  #     echo "   SOCKS5 代理: socks5://${globals.proxy.host}:${toString globals.proxy.socksPort}"
  #   '')
  #
  #   (writeShellScriptBin "proxy-off" ''
  #     # 禁用代理
  #     unset http_proxy HTTP_PROXY https_proxy HTTPS_PROXY
  #     unset socks_proxy SOCKS_PROXY
  #     unset no_proxy NO_PROXY
  #
  #     echo "❌ 代理已禁用"
  #   '')
  #
  #   (writeShellScriptBin "proxy-status" ''
  #     # 检查代理状态
  #     echo "🔍 当前代理设置:"
  #     echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  #     echo "HTTP_PROXY:  ''${HTTP_PROXY:-未设置}"
  #     echo "HTTPS_PROXY: ''${HTTPS_PROXY:-未设置}"
  #     echo "SOCKS_PROXY: ''${SOCKS_PROXY:-未设置}"
  #     echo "NO_PROXY:    ''${NO_PROXY:-未设置}"
  #     echo ""
  #
  #     # 测试代理连接
  #     echo "🌐 测试代理连接:"
  #     if command -v curl >/dev/null 2>&1; then
  #       if curl -s --connect-timeout 3 --max-time 5 http://www.google.com >/dev/null 2>&1; then
  #         echo "✅ 网络连接正常"
  #       else
  #         echo "❌ 网络连接失败，请检查代理设置"
  #       fi
  #     else
  #       echo "⚠️  curl 未安装，无法测试连接"
  #     fi
  #   '')
  #
  #   (writeShellScriptBin "proxy-test" ''
  #     # 测试代理连接
  #     echo "🧪 测试代理服务器连接..."
  #
  #     # 测试 HTTP 代理
  #     if command -v nc >/dev/null 2>&1; then
  #       if nc -z ${globals.proxy.host} ${toString globals.proxy.httpPort} 2>/dev/null; then
  #         echo "✅ HTTP 代理服务器 (${globals.proxy.host}:${toString globals.proxy.httpPort}) 可达"
  #       else
  #         echo "❌ HTTP 代理服务器 (${globals.proxy.host}:${toString globals.proxy.httpPort}) 不可达"
  #       fi
  #
  #       if nc -z ${globals.proxy.host} ${toString globals.proxy.socksPort} 2>/dev/null; then
  #         echo "✅ SOCKS5 代理服务器 (${globals.proxy.host}:${toString globals.proxy.socksPort}) 可达"
  #       else
  #         echo "❌ SOCKS5 代理服务器 (${globals.proxy.host}:${toString globals.proxy.socksPort}) 不可达"
  #       fi
  #     else
  #       echo "⚠️  netcat 未安装，无法测试端口连接"
  #     fi
  #
  #     # 测试实际网络连接
  #     if command -v curl >/dev/null 2>&1; then
  #       echo ""
  #       echo "🌐 测试通过代理访问外网..."
  #       if curl -s --proxy http://${globals.proxy.host}:${toString globals.proxy.httpPort} --connect-timeout 5 --max-time 10 http://www.google.com >/dev/null 2>&1; then
  #         echo "✅ 通过 HTTP 代理访问外网成功"
  #       else
  #         echo "❌ 通过 HTTP 代理访问外网失败"
  #       fi
  #     fi
  #   '')
  # ];
}
