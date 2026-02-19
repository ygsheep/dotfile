{
  lib,
  pkgs,
  inputs,
  globals,
  ...
}: {
  programs.anyrun = {
    enable = true;
    config = {
      # 水平居中
      x = {fraction = 0.5;};
      # 垂直偏上 (30% 位置)
      y = {fraction = 0.3;};
      # 宽度 (屏幕的 45%)
      width = {fraction = 0.45;};
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = false;
      showResultsImmediately = true;
      maxEntries = 8;

      plugins = [
        # Applications - 搜索和运行系统及用户桌面应用
        "${pkgs.anyrun}/lib/libapplications.so"
        # Symbols - 搜索 unicode 符号
        "${pkgs.anyrun}/lib/libsymbols.so"
        # Shell - 运行 shell 命令
        "${pkgs.anyrun}/lib/libshell.so"
        # Dictionary - 查询单词定义
        "${pkgs.anyrun}/lib/libdictionary.so"
        # Websearch - 网络搜索
        "${pkgs.anyrun}/lib/libwebsearch.so"
        # Nix-run - 直接运行 nix 包
        "${pkgs.anyrun}/lib/libnix_run.so"
        # Niri-focus - niri 窗口聚焦搜索
        "${pkgs.anyrun}/lib/libniri_focus.so"
      ];
    };

    # 使用 Gruvbox Dark Hard 主题样式
    # Inline comments are supported for language injection into
    # multi-line strings with Treesitter! (Depends on your editor)
    extraCss =
      /*
      css
      */
      ''
        /* ========== 主窗口 ========== */
        #window {
          background: transparent;
        }

        /* ========== 主容器 ========== */
        box {
          background: rgba(29, 32, 33, 0.95);
          border-radius: 12px;
          padding: 6px;
        }

        /* ========== 输入框 ========== */
        #entry {
          background: rgba(60, 56, 54, 0.5);
          border-radius: 8px;
          margin: 6px;
          padding: 10px 14px;
          font-size: 15px;
          color: #ebdbb2;
        }

        #entry:focus {
          outline: 2px solid rgba(184, 187, 38, 0.5);
        }

        #entry placeholder {
          color: rgba(189, 174, 147, 0.5);
        }

        /* ========== 插件选择器 ========== */
        #plugin {
          background: transparent;
          padding: 6px 10px;
          margin: 2px;
          border-radius: 6px;
          color: #bdae93;
        }

        #plugin:hover {
          background: rgba(184, 187, 38, 0.1);
        }

        #plugin selected {
          background: rgba(184, 187, 38, 0.2);
          color: #ebdbb2;
        }

        /* ========== 匹配项列表 ========== */
        list {
          margin: 2px 0;
        }

        #match {
          background: transparent;
          border-radius: 8px;
          padding: 8px 12px;
          margin: 1px 2px;
        }

        #match:selected {
          background: rgba(184, 187, 38, 0.2);
        }

        #match:hover {
          background: rgba(184, 187, 38, 0.12);
        }

        /* ========== 图标 ========== */
        #match icon {
          size: 20px;
        }

        #match img {
          size: 20px;
        }

        /* ========== 文字样式 ========== */
        #match-title {
          color: #ebdbb2;
          font-size: 14px;
          font-weight: 500;
        }

        #match-desc {
          color: rgba(189, 174, 147, 0.6);
          font-size: 12px;
          /* 超出省略号 */
          max-width: 400px;
          text-overflow: ellipsis;
          overflow: hidden;
          white-space: nowrap;
        }

        #match:selected #match-title {
          color: #fbf1c7;
        }

        #match:selected #match-desc {
          color: rgba(235, 219, 178, 0.7);
        }

        /* ========== 滚动条 ========== */
        list > scrollbar {
          background: transparent;
        }

        list > scrollbar thumb {
          background: rgba(189, 174, 147, 0.25);
          border-radius: 4px;
          min-height: 16px;
        }

        list > scrollbar thumb:hover {
          background: rgba(189, 174, 147, 0.4);
        }
      '';

    extraConfigFiles = {
      "applications.ron".text = ''
        Config(
          // Position/size fields use an enum for the value, it can be either:
          // Absolute(n): The absolute value in pixels
          // Fraction(n): A fraction of the width or height of the full screen (depends on exclusive zones and the settings related to them) window respectively

          // The horizontal position, adjusted so that Relative(0.5) always centers the runner
          x: Fraction(0.5),

          // The vertical position, works the same as `x`
          y: Absolute(0),

          // The width of the runner
          width: Absolute(800),

          // The minimum height of the runner, the runner will expand to fit all the entries
          // NOTE: If this is set to 0, the window will never shrink after being expanded
          height: Absolute(1),

          // Hide match and plugin info icons
          hide_icons: false,

          // ignore exclusive zones, f.e. Waybar
          ignore_exclusive_zones: false,

          // Layer shell layer: Background, Bottom, Top, Overlay
          layer: Overlay,

          // Hide the plugin info panel
          hide_plugin_info: false,

          // Close window when a click outside the main box is received
          close_on_click: false,

          // Show search results immediately when Anyrun starts
          show_results_immediately: false,

          // Limit amount of entries shown in total
          max_entries: None,

          // List of plugins to be loaded by default, can be specified with a relative path to be loaded from the
          // `<anyrun config dir>/plugins` directory or with an absolute path to just load the file the path points to.
          //
          // The order of plugins here specifies the order in which they appear
          // in the results. As in it works as a priority for the plugins.
          plugins: [
            "libapplications.so",
            "libsymbols.so",
            "libshell.so",
            "libtranslate.so",
          ],

          keybinds: [
            Keybind(
              key: "Return",
              action: Select,
            ),
            Keybind(
              key: "Up",
              action: Up,
            ),
            Keybind(
              key: "Down",
              action: Down,
            ),
            Keybind(
              key: "ISO_Left_Tab",
              action: Up,
              shift: true,
            ),
            Keybind(
              key: "Tab",
              action: Down,
            ),
            Keybind(
              key: "Escape",
              action: Close,
            ),
          ],
        )
      '';

      "symbols.ron".text = ''
        Config(
            // 符号插件配置
            max_entries: 10,
            copy_on_select: true,
        )
      '';

      "shell.ron".text = ''
        Config(
            // Shell 插件配置
            max_entries: 10,
            show_command: true,
            shell: Some("nu"),
        )
      '';

      "dictionary.ron".text = ''
        Config(
            // 字典插件配置
            max_entries: 5,
            show_definition: true,
            language: "en",
        )
      '';

      "websearch.ron".text = ''
        Config(
            // 网络搜索插件配置
            max_entries: 5,
            engines: [
                ("google", "https://www.google.com/search?q={}"),
                ("bing", "https://www.bing.com/search?q={}"),
                ("duckduckgo", "https://duckduckgo.com/?q={}"),
                ("baidu", "https://www.baidu.com/s?wd={}"),
            ],
        )
      '';

      "nix-run.ron".text = ''
        Config(
            // Nix 运行插件配置
            max_entries: 5,
            show_command: true,
            flake_path: Some(config.xdg.configHome.nix FlakePath or "${globals.projectDir}"),
            channel: "nixpkgs-unstable",
        )
      '';

      "niri-focus.ron".text = ''
        Config(
            // Niri 焦点插件配置
            max_entries: 10,
            show_workspace_names: true,
            show_empty_workspaces: false,
        )
      '';
    };
  };
}
