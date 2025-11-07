{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  noctalia = inputs.noctalia.packages.${pkgs.system}.default;
in {
  # 安装 Noctalia 包
  home.packages = [noctalia];

  # 配置 Noctalia 环境变量
  home.sessionVariables = {
    QML2_IMPORT_PATH = lib.concatStringsSep ":" [
      "${noctalia}/lib/qt-6/qml"
      "${inputs.quickshell.packages.${pkgs.system}.default}/lib/qt-6/qml"
      "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
      "${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml"
      config.home.sessionVariables.QML2_IMPORT_PATH or ""
    ];
  };

  # Noctalia 配置
  xdg.configFile."noctalia/config.json".text = builtins.toJSON {
    version = "1.0";
    shell = {
      engine = "quickshell";
      configFile = "config.qml";
    };
    appearance = {
      theme = "default";
      accentColor = "#8aadf4";
      backgroundColor = "#24273a";
      textColor = "#cad3f5";
    };
    behavior = {
      autoStart = true;
      hotkey = "Super+Space";
      animations = true;
      blurEffects = true;
    };
    modules = {
      launcher = {
        enabled = true;
        fuzzySearch = true;
        recentApps = true;
        categories = ["utilities" "development" "games" "graphics" "network" "office" "audiovideo" "system" "other"];
      };
      runner = {
        enabled = true;
        commandHistory = true;
        suggestions = true;
      };
      calculator = {
        enabled = true;
        scientific = false;
      };
      websearch = {
        enabled = true;
        engines = {
          google = "https://www.google.com/search?q={}";
          duckduckgo = "https://duckduckgo.com/?q={}";
          bing = "https://www.bing.com/search?q={}";
        };
      };
    };
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

  # 键盘快捷键绑定（通过 Niri 配置）
  # 这部分需要在 home/software/wayland/niri/binds.nix 中配置
  # 例如："Super+Space" = { spawn = ["sh" "-c" "pkill -f noctalia || noctalia &"]; };
}