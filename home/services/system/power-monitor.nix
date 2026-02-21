{
  pkgs,
  lib,
  ...
}: let
  # ============================================
  # 配置选项（修改这里调整行为）
  # ============================================
  cfg = {
    # 高电量阈值（≥此值使用高性能模式）
    highBatteryThreshold = 80;
    # 低电量阈值（≤此值使用省电模式）
    lowBatteryThreshold = 20;
    # 插电时使用的电源配置
    acProfile = "performance";
    # 高电量时使用的电源配置
    highBatteryProfile = "performance";
    # 中等电量时使用的电源配置
    mediumBatteryProfile = "balanced";
    # 低电量时使用的电源配置
    lowBatteryProfile = "power-saver";
  };
  # ============================================

  inherit
    (cfg)
    highBatteryThreshold
    lowBatteryThreshold
    acProfile
    highBatteryProfile
    mediumBatteryProfile
    lowBatteryProfile
    ;

  dependencies = with pkgs; [
    coreutils
    power-profiles-daemon
    inotify-tools
    gsettings-desktop-schemas
    kdePackages.kconfig
  ];

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

    # ============================================
    # 配置选项（从 Nix 配置注入）
    # ============================================
    readonly HIGH_BAT_PERCENT=${toString highBatteryThreshold}
    readonly LOW_BAT_PERCENT=${toString lowBatteryThreshold}
    readonly AC_PROFILE="${acProfile}"
    readonly HIGH_BAT_PROFILE="${highBatteryProfile}"
    readonly MED_BAT_PROFILE="${mediumBatteryProfile}"
    readonly LOW_BAT_PROFILE="${lowBatteryProfile}"
    # ============================================

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

      # 插电状态（Charging, Full 等）使用 AC 配置
      if [[ "$status" != "Discharging" ]] && [[ "$status" != "Not charging" ]]; then
        echo "$AC_PROFILE"
        return
      fi

      # 电池放电状态：根据电量选择配置
      if [[ "$capacity" -ge $HIGH_BAT_PERCENT ]]; then
        # 高电量（≥80%）：高性能
        echo "$HIGH_BAT_PROFILE"
      elif [[ "$capacity" -gt $LOW_BAT_PERCENT ]]; then
        # 中等电量（20%-79%）：平衡
        echo "$MED_BAT_PROFILE"
      else
        # 低电量（≤20%）：省电
        echo "$LOW_BAT_PROFILE"
      fi
    }

    apply_profile() {
      local profile=$1
      log "Setting power profile to $profile (status: $(cat $BAT_STATUS), capacity: $(cat $BAT_CAP)%)"
      if ! powerprofilesctl set "$profile"; then
        log "Failed to set power profile"
        return 1
      fi
    }

    log "Starting power monitor"
    log "Config: AC=$AC_PROFILE, High(≥$HIGH_BAT_PERCENT%)=$HIGH_BAT_PROFILE, Medium=$MED_BAT_PROFILE, Low(≤$LOW_BAT_PERCENT%)=$LOW_BAT_PROFILE"

    # 禁用 PowerDevil 的电源配置自动切换（如果存在）
    if command -v kwriteconfig6 >/dev/null 2>&1; then
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
        sleep 5
      fi
    done
  '';
  # Power state monitor. Switches Power profiles based on charging state.
in {
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
