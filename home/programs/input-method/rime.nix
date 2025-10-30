# home/programs/input-method/rime.nix - Rime 输入法用户配置
{ config, pkgs, lib, ... }:

{
  # Rime 配置管理脚本
  home.file.".local/bin/rime-setup" = {
    text = ''
      #!${pkgs.bash}/bin/bash
      # Rime Ice 配置管理脚本

      set -e

      RIME_DIR="$HOME/.local/share/fcitx5/rime"

      show_help() {
        echo "🎯 Rime Ice 配置管理器"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "用法: rime-setup [命令]"
        echo ""
        echo "命令:"
        echo "  install    安装/更新 Rime Ice 配置"
        echo "  deploy     重新部署 Rime 配置"
        echo "  status     查看当前配置状态"
        echo "  backup     备份当前配置"
        echo "  help       显示帮助信息"
        echo ""
        echo "💡 提示: 配置变更后需要重新部署才能生效"
      }

      deploy_rime() {
        echo "🔄 重新部署 Rime 配置..."

        # 尝试使用 Rime 部署工具
        if command -v rime_deployer >/dev/null 2>&1; then
          rime_deployer --build "$RIME_DIR"
          echo "✅ Rime 配置部署完成"
        else
          echo "⚠️  找不到 rime_deployer，请手动重新部署："
          echo "   1. 右键点击输入法托盘图标"
          echo "   2. 选择 '重新部署'"
        fi

        # 重启 fcitx5
        if pgrep fcitx5 >/dev/null; then
          echo "🔄 重启 fcitx5..."
          pkill fcitx5 || true
          sleep 1
          nohup fcitx5 >/dev/null 2>&1 &
        fi
      }

      show_status() {
        echo "📊 Rime 配置状态:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

        if [[ -d "$RIME_DIR" ]]; then
          echo "📁 配置目录: $RIME_DIR"
          echo "📄 配置文件数量: $(find "$RIME_DIR" -name "*.yaml" | wc -l)"

          if [[ -f "$RIME_DIR/rime_ice.schema.yaml" ]]; then
            echo "✅ Rime Ice: 已安装"
          else
            echo "❌ Rime Ice: 未安装"
          fi

          if [[ -f "$RIME_DIR/default.custom.yaml" ]]; then
            echo "✅ 自定义配置: 已配置"
          else
            echo "⚠️  自定义配置: 未配置"
          fi
        else
          echo "❌ Rime 配置目录不存在"
        fi
      }

      backup_config() {
        if [[ -d "$RIME_DIR" ]]; then
          BACKUP_DIR="$RIME_DIR.backup.$(date +%Y%m%d_%H%M%S)"
          echo "💾 备份配置到: $BACKUP_DIR"
          cp -r "$RIME_DIR" "$BACKUP_DIR"
          echo "✅ 备份完成"
        else
          echo "❌ 没有找到配置目录"
        fi
      }

      case "''${1:-help}" in
        "install")
          echo "📦 安装/更新 Rime Ice 配置..."
          
          # 备份现有配置
          if [[ -d "$RIME_DIR" ]]; then
            echo "💾 备份现有配置..."
            backup_config
          fi
          
          # 创建目录
          mkdir -p "$RIME_DIR"
          
          # 克隆 Rime Ice 配置
          echo "📥 下载 Rime Ice 配置..."
          ${pkgs.git}/bin/git clone https://github.com/iDvel/rime-ice.git "$RIME_DIR" --depth 1
          
          echo "✅ Rime Ice 配置安装完成"
          deploy_rime
          ;;
        "deploy")
          deploy_rime
          ;;
        "status")
          show_status
          ;;
        "backup")
          backup_config
          ;;
        "help"|"-h"|"--help")
          show_help
          ;;
        *)
          echo "❓ 未知命令: $1"
          show_help
          exit 1
          ;;
      esac
    '';
    executable = true;
  };

  # Shell 别名
  home.shellAliases = {
    rime = "rime-setup";
    rime-config = "rime-setup deploy"; # 避免与 zsh.nix 中的 rime-deploy 冲突
    rime-status = "rime-setup status";
  };

  # Fcitx5 自动启动服务 (Home Manager)
  systemd.user.services.fcitx5-daemon = {
    Unit = {
      Description = "Fcitx5 input method framework";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.fcitx5}/bin/fcitx5";
      ExecReload = "${pkgs.coreutils}/bin/kill -USR1 $MAINPID";
      Restart = "on-failure";
      RestartSec = "3";
      Environment = [
        "GLFW_IM_MODULE=fcitx"
      ];
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
