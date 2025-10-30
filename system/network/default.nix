{pkgs, ...}: {
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
    http_proxy = "http://192.168.8.8:20171";
    HTTP_PROXY = "http://192.168.8.8:20171";
    https_proxy = "http://192.168.8.8:20172";
    HTTPS_PROXY = "http://192.168.8.8:20172";

    # SOCKS5 代理（备用）
    socks_proxy = "socks5://192.168.8.8:20170";
    SOCKS_PROXY = "socks5://192.168.8.8:20170";

    # 不走代理的地址
    no_proxy = "localhost,192.168.8.8,::1,.local,.lan,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12";
    NO_PROXY = "localhost,192.168.8.8,::1,.local,.lan,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12";
  };

  # 为所有用户会话设置代理
  environment.sessionVariables = {
    http_proxy = "http://192.168.8.8:20171";
    HTTP_PROXY = "http://192.168.8.8:20171";
    https_proxy = "http://192.168.8.8:20172";
    HTTPS_PROXY = "http://192.168.8.8:20172";
    no_proxy = "localhost,192.168.8.8,::1,.local,.lan,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12";
    NO_PROXY = "localhost,192.168.8.8,::1,.local,.lan,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12";
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
      http_proxy = "http://192.168.8.8:20171";
      HTTP_PROXY = "http://192.168.8.8:20171";
      https_proxy = "http://192.168.8.8:20172";
      HTTPS_PROXY = "http://192.168.8.8:20172";
      no_proxy = "localhost,192.168.8.8,::1,.local,.lan";
      NO_PROXY = "localhost,192.168.8.8,::1,.local,.lan";
    };
  };

  # Don't wait for network startup
  systemd.services.NetworkManager-wait-online.serviceConfig.ExecStart = ["" "${pkgs.networkmanager}/bin/nm-online -q"];
  environment.etc.hosts.enable = false;

  # 创建代理管理脚本
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "proxy-on" ''
      # 启用代理
      export http_proxy="http://192.168.8.8:20171"
      export HTTP_PROXY="http://192.168.8.8:20171"
      export https_proxy="http://192.168.8.8:20172"
      export HTTPS_PROXY="http://192.168.8.8:20172"
      export no_proxy="localhost,192.168.8.8,::1,.local,.lan,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12"
      export NO_PROXY="localhost,192.168.8.8,::1,.local,.lan,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12"

      echo "✅ 代理已启用:"
      echo "   HTTP 代理: http://192.168.8.8:20171"
      echo "   SOCKS5 代理: socks5://192.168.8.8:20170"
    '')

    (writeShellScriptBin "proxy-off" ''
      # 禁用代理
      unset http_proxy HTTP_PROXY https_proxy HTTPS_PROXY
      unset socks_proxy SOCKS_PROXY
      unset no_proxy NO_PROXY

      echo "❌ 代理已禁用"
    '')

    (writeShellScriptBin "proxy-status" ''
      # 检查代理状态
      echo "🔍 当前代理设置:"
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo "HTTP_PROXY:  ''${HTTP_PROXY:-未设置}"
      echo "HTTPS_PROXY: ''${HTTPS_PROXY:-未设置}"
      echo "SOCKS_PROXY: ''${SOCKS_PROXY:-未设置}"
      echo "NO_PROXY:    ''${NO_PROXY:-未设置}"
      echo ""

      # 测试代理连接
      echo "🌐 测试代理连接:"
      if command -v curl >/dev/null 2>&1; then
        if curl -s --connect-timeout 3 --max-time 5 http://www.google.com >/dev/null 2>&1; then
          echo "✅ 网络连接正常"
        else
          echo "❌ 网络连接失败，请检查代理设置"
        fi
      else
        echo "⚠️  curl 未安装，无法测试连接"
      fi
    '')

    (writeShellScriptBin "proxy-test" ''
      # 测试代理连接
      echo "🧪 测试代理服务器连接..."

      # 测试 HTTP 代理
      if command -v nc >/dev/null 2>&1; then
        if nc -z 192.168.8.8 20171 2>/dev/null; then
          echo "✅ HTTP 代理服务器 (192.168.8.8:20171) 可达"
        else
          echo "❌ HTTP 代理服务器 (192.168.8.8:20171) 不可达"
        fi

        if nc -z 192.168.8.8 20170 2>/dev/null; then
          echo "✅ SOCKS5 代理服务器 (192.168.8.8:20170) 可达"
        else
          echo "❌ SOCKS5 代理服务器 (192.168.8.8:20170) 不可达"
        fi
      else
        echo "⚠️  netcat 未安装，无法测试端口连接"
      fi

      # 测试实际网络连接
      if command -v curl >/dev/null 2>&1; then
        echo ""
        echo "🌐 测试通过代理访问外网..."
        if curl -s --proxy http://192.168.8.8:20171 --connect-timeout 5 --max-time 10 http://www.google.com >/dev/null 2>&1; then
          echo "✅ 通过 HTTP 代理访问外网成功"
        else
          echo "❌ 通过 HTTP 代理访问外网失败"
        fi
      fi
    '')
  ];
}
