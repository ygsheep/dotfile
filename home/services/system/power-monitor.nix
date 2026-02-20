{
  pkgs,
  lib,
  ...
}: let
  script = pkgs.writeShellScript "power_monitor.sh" ''
    set -euo pipefail

    log() {
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >&2
    }

    get_battery_path() {
      local bat_path
      bat_path=$(echo /sys/class/power_supply/BAT*)
      if [[ ! -d "$bat_path" ]]; then
        log "No battery found"
        exit 1
      fi
      echo "$bat_path"
    }

    readonly BAT="$(get_battery_path)"
    readonly BAT_STATUS="$BAT/status"
    readonly BAT_CAP="$BAT/capacity"
    readonly LOW_BAT_PERCENT=20

    readonly AC_PROFILE="performance"
    readonly BAT_PROFILE="balanced"
    readonly LOW_BAT_PROFILE="power-saver"

    for file in "$BAT_STATUS" "$BAT_CAP"; do
      if [[ ! -f "$file" ]]; then
        log "Required file not found: $file"
        exit 1
      fi
    done

    if ! command -v powerprofilesctl >/dev/null 2>&1; then
      log "powerprofilesctl not found"
      exit 1
    fi

    if [[ -n "''${STARTUP_WAIT:-}" ]]; then
      sleep "$STARTUP_WAIT"
    fi

    get_power_profile() {
      local status capacity
      status=$(cat "$BAT_STATUS")
      capacity=$(cat "$BAT_CAP")

      if [[ "$status" == "Discharging" ]]; then
        if [[ "$capacity" -gt $LOW_BAT_PERCENT ]]; then
          echo "$BAT_PROFILE"
        else
          echo "$LOW_BAT_PROFILE"
        fi
      else
        echo "$AC_PROFILE"
      fi
    }

    apply_profile() {
      local profile=$1
      log "Setting power profile to $profile"
      if ! powerprofilesctl set "$profile"; then
        log "Failed to set power profile"
        return 1
      fi
    }

    log "Starting power monitor"

    # 禁用 PowerDevil 的电源配置自动切换（如果存在）
    if command -v kwriteconfig6 >/dev/null 2>&1; then
      # 通过 KDE 配置禁用自动电源配置切换
      kwriteconfig6 --file powerdevilrc --group "AC" --key "Profile" "" 2>/dev/null || true
      kwriteconfig6 --file powerdevilrc --group "Battery" --key "Profile" "" 2>/dev/null || true
      log "PowerDevil auto-profile switching disabled (via kwriteconfig6)"
    elif command -v kwriteconfig5 >/dev/null 2>&1; then
      kwriteconfig5 --file powerdevilrc --group "AC" --key "Profile" "" 2>/dev/null || true
      kwriteconfig5 --file powerdevilrc --group "Battery" --key "Profile" "" 2>/dev/null || true
      log "PowerDevil auto-profile switching disabled (via kwriteconfig5)"
    fi

    prev_profile=""
    prev_status=""
    prev_capacity=""

    while true; do
      # 读取当前状态
      current_status=$(cat "$BAT_STATUS")
      current_capacity=$(cat "$BAT_CAP")
      current_profile=$(get_power_profile)

      # 只有当状态或电量真正变化时才切换
      if [[ "$prev_status" != "$current_status" ]] || [[ "$prev_capacity" != "$current_capacity" ]]; then
        if [[ "$prev_profile" != "$current_profile" ]]; then
          apply_profile "$current_profile"
          prev_profile=$current_profile
        fi
        prev_status="$current_status"
        prev_capacity="$current_capacity"
      fi

      # 等待电池状态变化，使用超时避免无限等待
      if ! inotifywait -qq -t 60 "$BAT_STATUS" "$BAT_CAP"; then
        # 超时或失败，继续循环检查
        sleep 5
      fi
    done
  '';

  dependencies = with pkgs; [
    coreutils
    power-profiles-daemon
    inotify-tools
    gsettings-desktop-schemas
    # KDE 配置工具（用于禁用 PowerDevil 的自动电源配置切换）
    kdePackages.kconfig
  ];
in {
  # Power state monitor. Switches Power profiles based on charging state.
  systemd.user.services.power-monitor = {
    Unit = {
      Description = "Power Monitor";
      After = ["power-profiles-daemon.service"];
      Wants = ["power-profiles-daemon.service"];
    };

    Service = {
      Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
      Type = "simple";
      ExecStart = script;
      Restart = "on-failure";
      RestartSec = "5s";
    };

    Install.WantedBy = ["default.target"];
  };
}
