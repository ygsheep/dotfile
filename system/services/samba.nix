{
  config,
  pkgs,
  globals,
  ...
}: let
  # 定义共享目录路径
  sharesBase = "/mnt/资源";
  publicShare = "${sharesBase}/AirVideo";
  privateShare = "${sharesBase}/Private";
in {
  # 启用 Samba 服务
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    # 禁用 nmbd（NetBIOS 名称服务）- 笔记本通常不需要
    enableNmbd = false;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "niri-dot";
        "netbios name" = "niri-dot";
        "security" = "user";
        "use sendfile" = "yes";
        "max protocol" = "smb3";
        "min protocol" = "SMB2";
        # 允许的访问范围 - 根据您的网络环境调整
        "hosts allow" = "192.168. 10. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
        "server role" = "standalone";
        "unix password sync" = "yes";
        "passwd program" = "/usr/bin/passwd %u";
        "pam password change" = "yes";
      };

      # 公开共享目录
      "AirVideo" = {
        "path" = publicShare;
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0664";
        "directory mask" = "0775";
        "force user" = globals.user;
        "force group" = "users";
      };

      # 私有共享目录
      "Telegram Desktop" = {
        "path" = "${sharesBase}/Telegram Desktop";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0664";
        "directory mask" = "0775";
        "force user" = globals.user;
        "force group" = "users";
      };
    };
  };

  # 启用 Samba Web Service Discovery (Windows 网络发现)
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
    hostname = config.networking.hostName;
    domain = "niri-dot";
  };

  # 确保防火墙允许相关端口
  networking.firewall = {
    enable = true;
    allowPing = true;
    # Samba 端口
    allowedTCPPorts = [139 445];
    allowedUDPPorts = [137 138];
    # WSDD 端口 (Web Service Discovery)
    allowedTCPPortRanges = [
      {
        from = 5357;
        to = 5359;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 3702;
        to = 3703;
      }
    ];
  };

  # 创建共享目录
  system.activationScripts = {
    createShares = {
      text = ''
        # 创建基础共享目录
        mkdir -p ${sharesBase}
        chmod 755 ${sharesBase}

        # 创建公开共享目录
        mkdir -p ${publicShare}
        chmod 775 ${publicShare}
        chown ${globals.user}:users ${publicShare}

        # 创建私有共享目录
        mkdir -p ${privateShare}
        chmod 700 ${privateShare}
        chown ${globals.user}:users ${privateShare}
      '';
    };
  };

  # 添加 Samba 相关工具包
  environment.systemPackages = with pkgs; [
    samba # smbpasswd, smbclient 等工具
    cifs-utils # 挂载 CIFS/SMB 共享的工具
  ];

  # 系统用户 Samba 密码设置说明
  # 注意：用户需要手动设置 Samba 密码
  # sudo smbpasswd -a ${globals.user}
}
