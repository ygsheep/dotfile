{
  pkgs,
  inputs,
  config,
  globals,
  lib,
  ...
}: let
  noctalia = inputs.noctalia.packages.${pkgs.system}.default;
in {
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
        scaleRatio = 1.0;
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
        name = "guangzhou";
        weatherEnabled = true;
        useFahrenheit = false;
        use12hourFormat = false;
        showWeekNumberInCalendar = false;
        showCalendarEvents = true;
        firstDayOfWeek = 1; # 周一作为一周的第一天
      };

      # 壁纸设置（使用全局变量）
      wallpaper = {
        enabled = true;
        overviewEnabled = true;
        directory = "${globals.assetsDir}/wallpaper";
        setWallpaperOnAllMonitors = true;
        defaultWallpaper = "${globals.assetsDir}/wallpaper/wallhaven-pkwxxm_3840x2160.png";
        fillMode = "scale";
        fillColor = "#1e1e2e";
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
        predefinedScheme = "catppuccin";
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

  # 安装 Noctalia 包
  home.packages = [noctalia];

  # 配置 Noctalia 环境变量
  home.sessionVariables = {
    QML2_IMPORT_PATH = lib.concatStringsSep ":" [
      "${noctalia}/lib/qt-6/qml"
      "${inputs.quickshell.packages.${pkgs.system}.default}/lib/qt-6/qml"
      "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
      "${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml"
      ""
    ];
  };

  # QuickShell 配置（与 Noctalia 集成）
  xdg.configFile."quickshell/config.qml".text = ''
    import QtQuick
    import org.kde.kirigami as Kirigami

    ShellWindow {
      id: root

      // 窗口属性
      visible: false
      width: 600
      height: 400
      color: "#24273a"

      // 动画效果
      PropertyAnimation on opacity {
        id: fadeAnim
        from: 0
        to: 1
        duration: 200
      }

      // 显示窗口
      function show() {
        visible = true
        fadeAnim.start()
      }

      // 隐藏窗口
      function hide() {
        opacity = 0
        fadeAnim.stop()
        visible = false
      }

      // 主界面
      Rectangle {
        anchors.fill: parent
        color: "#24273a"
        radius: 12

        // 边框效果
        border.color: "#8aadf4"
        border.width: 1

        // 阴影效果
        layer.enabled: true
        layer.effect: DropShadow {
          horizontalOffset: 0
          verticalOffset: 4
          radius: 12
          samples: 25
          color: "#00000040"
        }

        // 标题栏
        Rectangle {
          id: header
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: 40
          color: "#1e2030"
          radius: 12

          Text {
            anchors.centerIn: parent
            text: "Noctalia Launcher"
            color: "#cad3f5"
            font.family: "Noto Sans CJK SC"
            font.pixelSize: 14
          }
        }

        // 搜索框
        TextField {
          id: searchField
          anchors.top: header.bottom
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.margins: 20
          height: 40
          placeholderText: "搜索应用或输入命令..."
          color: "#cad3f5"

          background: Rectangle {
            color: "#363a4f"
            radius: 8
            border.color: searchField.activeFocus ? "#8aadf4" : "#5b6078"
            border.width: 1
          }
        }

        // 结果列表
        ListView {
          id: resultList
          anchors.top: searchField.bottom
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.bottom: parent.bottom
          anchors.margins: 20
          anchors.topMargin: 10

          model: ListModel {
            ListElement { name: "终端"; icon: "utilities-terminal"; command: "foot"; }
            ListElement { name: "文件管理器"; icon: "system-file-manager"; command: "yazi"; }
            ListElement { name: "浏览器"; icon: "web-browser"; command: "firefox"; }
            ListElement { name: "编辑器"; icon: "text-editor"; command: "helix"; }
            ListElement { name: "计算器"; icon: "accessories-calculator"; command: "qalculate-gtk"; }
          }

          delegate: ItemDelegate {
            width: resultList.width
            height: 50

            background: Rectangle {
              color: hoverHandler.hovered ? "#414559" : "transparent"
              radius: 6
            }

            HoverHandler {
              id: hoverHandler
            }

            Row {
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              anchors.margins: 10
              spacing: 12

              Icon {
                source: model.icon
                color: "#8aadf4"
                width: 24
                height: 24
              }

              Text {
                text: model.name
                color: "#cad3f5"
                font.family: "Noto Sans CJK SC"
                font.pixelSize: 14
                anchors.verticalCenter: parent.verticalCenter
              }
            }

            onClicked: {
              // 执行命令并关闭窗口
              Qt.openUrlExternally("file://" + model.command)
              root.hide()
            }
          }
        }
      }

      // 全局快捷键
      Shortcut {
        sequence: "Escape"
        onActivated: root.hide()
      }

      Shortcut {
        sequence: "Return"
        onActivated: {
          if (resultList.currentIndex >= 0) {
            var item = resultList.model.get(resultList.currentIndex)
            Qt.openUrlExternally("file://" + item.command)
            root.hide()
          }
        }
      }

      // 焦点管理
      Component.onCompleted: {
        searchField.forceActiveFocus()
      }
    }
  '';

  # 自动启动服务
  systemd.user.services.noctalia = {
    Unit = {
      Description = "Noctalia Shell Launcher";
      PartOf = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${noctalia}/bin/noctalia";
      Restart = "on-failure";
      RestartSec = 5;
      Environment = [
        "QML2_IMPORT_PATH=${config.home.sessionVariables.QML2_IMPORT_PATH}"
        "XDG_CONFIG_HOME=${config.xdg.configHome}"
      ];
    };

    Install.WantedBy = ["graphical-session.target"];
  };

  # 确保配置目录存在
  home.file.".config/noctalia/.keep".text = "";
}
