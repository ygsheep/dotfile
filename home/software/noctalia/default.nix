{
  pkgs,
  inputs,
  config,
  ...
}: {
  # 导入 Noctalia Home Manager 模块
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # 启用 Noctalia Shell
  programs.noctalia-shell = {
    enable = true;

    # 启用 systemd 服务
    systemd.enable = true;

    # 基本配置
    settings = {
      settingsVersion = 18;
      setupCompleted = false;

      # 顶部栏配置
      bar = {
        position = "top";
        backgroundOpacity = 0.95;
        density = "compact";
        showCapsule = true;
        exclusive = true;

        widgets = {
          left = [
            {
              id = "SystemMonitor";
            }
            {
              id = "ActiveWindow";
            }
            {
              id = "MediaMini";
            }
          ];
          center = [
            {
              id = "Workspace";
              labelMode = "number_and_name";
            }
          ];
          right = [
            {
              id = "ScreenRecorder";
            }
            {
              id = "Tray";
            }
            {
              id = "Battery";
              warningThreshold = 20;
            }
            {
              id = "Volume";
            }
            {
              id = "Brightness";
            }
            {
              id = "Clock";
              formatHorizontal = "HH:mm";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
            {
              id = "ControlCenter";
            }
          ];
        };
      };

      # 通用设置
      general = {
        avatarImage = "";
        dimDesktop = true;
        showScreenCorners = false;
        scaleRatio = 1;
        radiusRatio = 0.15;
        animationSpeed = 1;
        enableShadows = true;
        language = "zh_CN";
      };

      # UI 设置
      ui = {
        fontDefault = "Noto Sans CJK SC";
        fontFixed = "Geist Mono Nerd Font";
        fontDefaultScale = 1;
        fontFixedScale = 1;
        tooltipsEnabled = true;
        panelsAttachedToBar = true;
        panelsOverlayLayer = false;
      };

      # 位置设置
      location = {
        name = "Shanghai";
        weatherEnabled = true;
        useFahrenheit = false;
        use12hourFormat = false;
        showWeekNumberInCalendar = false;
        showCalendarEvents = true;
        firstDayOfWeek = 1; # 周一作为一周的第一天
      };

      # 壁纸设置
      wallpaper = {
        enabled = true;
        overviewEnabled = true;
        directory = "/home/sheep/.dotfile/assets";
        setWallpaperOnAllMonitors = true;
        defaultWallpaper = "/home/sheep/.dotfile/assets/1.png";
        fillMode = "crop";
        fillColor = "#000000";
        randomEnabled = false;
        transitionDuration = 1000;
        transitionType = "fade";
        panelPosition = "follow_bar";
      };

      # 应用启动器设置
      appLauncher = {
        enableClipboardHistory = true;
        position = "center";
        backgroundOpacity = 0.95;
        useApp2Unit = false;
        sortByMostUsed = true;
        terminalCommand = "ghostty";
      };

      # 控制中心设置
      controlCenter = {
        position = "close_to_bar_button";
        shortcuts = {
          left = [
            {
              id = "WiFi";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "ScreenRecorder";
            }
            {
              id = "WallpaperSelector";
            }
          ];
          right = [
            {
              id = "Notifications";
            }
            {
              id = "PowerProfile";
            }
            {
              id = "KeepAwake";
            }
            {
              id = "NightLight";
            }
          ];
        };
        cards = [
          {
            enabled = true;
            id = "profile-card";
          }
          {
            enabled = true;
            id = "shortcuts-card";
          }
          {
            enabled = true;
            id = "audio-card";
          }
          {
            enabled = true;
            id = "weather-card";
          }
          {
            enabled = true;
            id = "media-sysmon-card";
          }
        ];
      };

      # 网络设置
      network = {
        wifiEnabled = true;
      };

      # 通知设置
      notifications = {
        doNotDisturb = false;
        location = "top_right";
        overlayLayer = true;
        backgroundOpacity = 0.9;
        respectExpireTimeout = false;
        lowUrgencyDuration = 3;
        normalUrgencyDuration = 8;
        criticalUrgencyDuration = 15;
      };

      # OSD 设置
      osd = {
        enabled = true;
        location = "top_right";
        autoHideMs = 2000;
        overlayLayer = true;
      };

      # 音频设置
      audio = {
        volumeStep = 5;
        volumeOverdrive = false;
        cavaFrameRate = 60;
        visualizerType = "linear";
      };

      # 亮度设置
      brightness = {
        brightnessStep = 5;
        enforceMinimum = true;
        enableDdcSupport = true;
      };

      # 颜色主题设置
      colorSchemes = {
        useWallpaperColors = false;
        predefinedScheme = "Noctalia (default)";
        darkMode = true;
        schedulingMode = "off";
        manualSunrise = "06:30";
        manualSunset = "18:30";
        generateTemplatesForPredefined = true;
      };

      # 模板生成
      templates = {
        gtk = true;
        qt = true;
        kcolorscheme = true;
        alacritty = true;
        kitty = false;
        ghostty = true;
        foot = false;
        wezterm = false;
        code = false;
        enableUserTemplates = false;
      };

      # 夜间模式
      nightLight = {
        enabled = false;
        forced = false;
        autoSchedule = true;
        nightTemp = "4000";
        dayTemp = "6500";
        manualSunrise = "06:30";
        manualSunset = "18:30";
      };
    };
  };

  # 确保配置目录存在
  home.file.".config/noctalia/.keep".text = "";
}