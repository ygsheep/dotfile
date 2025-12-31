# 时间同步配置
# 解决 NixOS 与 Windows 双系统时间同步问题
{
  config,
  lib,
  pkgs,
  ...
}: {
  # 设置硬件时钟使用本地时间（与 Windows 保持一致）
  time.hardwareClockInLocalTime = true;

  # 时区设置（中国标准时间）
  time.timeZone = "Asia/Shanghai";

  # 启用 NTP 时间同步
  services.chrony = {
    enable = true;
    # 配置 NTP 服务器
    servers = [
      "0.pool.ntp.org"
      "1.pool.ntp.org"
      "2.pool.ntp.org"
      "3.pool.ntp.org"
    ];
    # 系统启动时强制同步时间
    extraConfig = ''
      makestep 1.0 3
    '';
  };

  # 确保 systemd-timesyncd 被禁用（与 chrony 冲突）
  systemd.services.systemd-timesyncd.enable = lib.mkForce false;

  # 自动时间同步配置
  environment.variables = {
    # 时区设置
    TZ = "Asia/Shanghai";
  };

  # 开机时等待网络可用后再同步时间
  systemd.targets.time-sync = {
    description = "Time Synchronization";
    after = ["network-online.target"];
    wants = ["network-online.target"];
    wantedBy = ["multi-user.target"];
  };

  # 创建定时同步任务
  systemd.user.timers."sync-time" = {
    description = "Sync time every hour";
    timerConfig = {
      OnCalendar = "hourly";
      Persistent = true;
    };
    wantedBy = ["timers.target"];
  };

  systemd.user.services."sync-time" = {
    description = "Sync time with NTP servers";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.chrony}/bin/chronyc sources --offline";
      ExecStartPost = "${pkgs.systemd}/bin/timedatectl status || true";
    };
  };

  # 添加常用时间同步工具
  environment.systemPackages = with pkgs; [
    chrony # NTP 客户端和服务端
    ntp # NTP 工具
  ];

  # 系统提示
  system.activationScripts.setupTimeSync = ''
    echo "⏰ 时间同步配置完成！"
    echo "✅ 硬件时钟设置为本地时间（与 Windows 兼容）"
    echo "✅ 时区设置为 Asia/Shanghai"
    echo "✅ NTP 服务已启用"
    echo ""
    echo "📊 查看当前时间状态："
    echo "   timedatectl status"
    echo ""
    echo "🔄 如果时间仍然不同步，请运行："
    echo "   sudo systemctl restart chronyd"
    echo "   sudo chronyc sources"
    echo "   sudo chronyc -a makestep"
    echo ""
    echo "📋 查看时间服务状态："
    echo "   systemctl status chronyd"
    echo "   chronyc tracking"
    echo ""
    echo "💡 双系统时间同步说明："
    echo "   - NixOS 已配置为使用本地时间"
    echo "   - Windows 无需修改，保持默认设置"
    echo "   - 两个系统的时间现在将保持同步"
  '';
}
