# home/programs/input-method/keyd.nix - Keyd 键盘重映射用户配置
{
  config,
  pkgs,
  lib,
  ...
}: {
  # 注意: Keyd 服务已在系统配置 systems/services/desktop.nix 中启用
  # 这里提供用户级别的管理脚本和配置

  # Shell 别名和脚本
  home.file.".local/bin/keyd-reload" = {
    text = ''
      #!/usr/bin/env bash
      # Keyd 重载配置脚本

      echo "🔄 重载 keyd 配置..."

      if systemctl is-active --quiet keyd; then
        sudo systemctl reload keyd
        echo "✅ Keyd 配置重载完成"
      else
        echo "⚠️  Keyd 服务未运行，请先启动服务："
        echo "   sudo systemctl start keyd"
        echo "   sudo systemctl enable keyd"
      fi
    '';
    executable = true;
  };

  home.file.".local/bin/keyd-status" = {
    text = ''
      #!/usr/bin/env bash
      # Keyd 状态检查脚本

      echo "📊 Keyd 状态:"
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

      # 检查服务状态
      if systemctl is-active --quiet keyd; then
        echo "✅ 服务状态: 运行中"
      else
        echo "❌ 服务状态: 未运行"
      fi

      if systemctl is-enabled --quiet keyd; then
        echo "✅ 开机自启: 已启用"
      else
        echo "⚠️  开机自启: 未启用"
      fi

      # 检查配置文件
      if [[ -f "$HOME/.config/keyd/default.conf" ]]; then
        echo "✅ 配置文件: 存在"
        echo "📁 配置路径: $HOME/.config/keyd/default.conf"
      else
        echo "❌ 配置文件: 不存在"
      fi

      # 检查权限
      if groups | grep -q input; then
        echo "✅ 用户权限: 已加入 input 组"
      else
        echo "⚠️  用户权限: 未加入 input 组"
        echo "   运行: sudo usermod -a -G input $USER"
      fi

      echo ""
      echo "💡 使用说明："
      echo "   keyd-reload  - 重载配置"
      echo "   keyd-status  - 查看状态"
    '';
    executable = true;
  };

  # Shell 别名
  home.shellAliases = {
    keyd-reload = "keyd-reload";
    keyd-status = "keyd-status";
  };
}
