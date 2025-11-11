{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
with lib; let
  # 生成 Firefox GNOME 主题
  firefox-gnome-theme = pkgs.callPackage ../../../../pkgs/firefox-gnome-theme.nix {
    theme = inputs.firefox-gnome-theme;
  };

  # Betterfox 配置（优化性能和隐私）
  betterfox = pkgs.fetchFromGitHub {
    owner = "yokoffing";
    repo = "Betterfox";
    rev = "128.0.1";
    hash = "sha256-2JnGqK6wVzJN2RrWq8G+ThC7gQY8B9J3F2D4E5A6B7C=";
  };

  # 生成用户样式
  userChrome = ''
    /* 主题集成 */
    @import url("file://${firefox-gnome-theme}/userChrome.css");

    /* 自定义样式 */
    :root {
      --gnome-browser-before-load-background: ${config.lib.stylix.colors.base00};
      --gnome-accent-bg: ${config.lib.stylix.colors.base0D};
      --gnome-accent-fg: ${config.lib.stylix.colors.base07};
    }

    /* 隐藏不需要的元素 */
    #personal-bookmarks {
      display: none !important;
    }

    /* 优化标签栏 */
    #tabbrowser-tabs {
      background: transparent !important;
    }

    /* 自定义地址栏 */
    #urlbar {
      background: ${config.lib.stylix.colors.base01} !important;
      border: 1px solid ${config.lib.stylix.colors.base02} !important;
      border-radius: 8px !important;
    }

    #urlbar[focused] {
      border-color: ${config.lib.stylix.colors.base0D} !important;
    }

    /* 自定义书签栏 */
    #PersonalToolbar {
      background: ${config.lib.stylix.colors.base00} !important;
      border-top: 1px solid ${config.lib.stylix.colors.base02} !important;
    }

    /* 滚动条样式 */
    scrollbar {
      width: 8px !important;
      background: ${config.lib.stylix.colors.base01} !important;
    }

    scrollbar-thumb {
      background: ${config.lib.stylix.colors.base03} !important;
      border-radius: 4px !important;
    }

    scrollbar-thumb:hover {
      background: ${config.lib.stylix.colors.base04} !important;
    }
  '';

  # 用户内容样式
  userContent = ''
    /* 全局样式 */
    :root {
      --gnome-browser-before-load-background: ${config.lib.stylix.colors.base00};
      --gnome-accent-bg: ${config.lib.stylix.colors.base0D};
    }

    /* 新标签页背景 */
    @-moz-document url("about:newtab"), url("about:home") {
      body {
        background: ${config.lib.stylix.colors.base00} !important;
        color: ${config.lib.stylix.colors.base07} !important;
      }
    }

    /* about:页面样式 */
    @-moz-document url-prefix("about:") {
      body {
        background: ${config.lib.stylix.colors.base00} !important;
        color: ${config.lib.stylix.colors.base07} !important;
      }
    }
  '';

  # Firefox 策略配置
  policies = {
    DisableTelemetry = true;
    DisableFirefoxStudies = true;
    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
    };
    DisablePocket = true;
    DisableFirefoxAccounts = true;
    DisableAccounts = true;
    DisableFirefoxScreenshots = true;
    OverrideFirstRunPage = "";
    DontCheckDefaultBrowser = true;
    DisplayBookmarksToolbar = "never";
    DisplayMenuBar = "never";
    SearchEngines = {
      Default = "Qwant";
      Add = [
        {
          Name = "Qwant";
          URLTemplate = "https://www.qwant.com/?q={searchTerms}";
          IconURL = "https://www.qwant.com/favicon.ico";
        }
        {
          Name = "Home Manager";
          URLTemplate = "https://home-manager-options.extranix.com/?query={searchTerms}";
        }
        {
          Name = "Nixpkgs";
          URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
        }
        {
          Name = "GitHub";
          URLTemplate = "https://github.com/search?q={searchTerms}";
        }
        {
          Name = "Noogle";
          URLTemplate = "https://noogle.dev/q?term={searchTerms}";
        }
      ];
    };
    ExtensionSettings = {
      "uBlock0@raymondhill.net" = {
        installation_mode = "normal_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        default_area = "navbar";
      };
    };
  };

  # uBlock Origin 过滤列表
  ublock-filter-lists = [
    "https://easylist.to/easylist/easylist.txt"
    "https://easylist.to/easylist/easyprivacy.txt"
    "https://easylist-downloads.adblockplus.org/easylistgermany.txt"
    "https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt"
    "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=adblockplus&showintro=0&mimetype=plaintext"
    "https://www.i-dont-care-about-cookies.eu/abp.txt"
    "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt"
    "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
    "https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/nocoin.txt"
    "https://raw.githubusercontent.com/ryanbr/fanboy-adblock/master/filterscript.txt"
    "https://easylist-downloads.adblockplus.org/easylistchina.txt"
    "https://raw.githubusercontent.com/xinggsf/Adblock-Plus-Rule/master/ABP-Filters.txt"
  ];
in {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;

    # 语言配置
    # languagePack = "zh-CN";

    # 扩展
    # extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    #   ublock-origin
    #   copy-selected-links
    #   sponsorblock
    #   brotab
    # ];

    # 配置文件
    profiles.default = {
      id = 0;
      name = "Default";
      isDefault = true;

      # 扩展
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
        ublock-origin
        copy-selected-links
        sponsorblock
        brotab
      ];

      # 设置
      settings = {
        # 基本设置
        "browser.startup.homepage" = "https://www.qwant.com/";
        "browser.newtabpage.enabled" = false;
        "browser.newtabpage.pinned" = [];

        # 性能设置
        "gfx.webrender.all" = true;
        "layers.acceleration.force-enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;

        # 隐私设置
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.resistFingerprinting" = true;

        # 外观设置
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        "layout.css.color-mix.enabled" = true;
        "layout.css.backdrop-filter.enabled" = true;

        # 地址栏设置
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.openpage" = true;
        "browser.urlbar.showSearchSuggestionsFirst" = false;

        # 下载设置
        "browser.download.useDownloadDir" = true;
        "browser.download.dir" = "${config.home.homeDirectory}/Downloads";

        # 标签页设置
        "browser.tabs.insertRelatedAfterCurrent" = false;
        "browser.tabs.tabMinWidth" = 76;

        # 滚动设置
        "general.smoothScroll" = true;
        "mousewheel.default.delta_multiplier_y" = 250;

        # 字体设置
        "font.default.x-western" = "sans-serif";
        "font.size.variable.x-western" = 16;
        "font.minimum-size.x-western" = 12;

        # 媒体设置
        "media.autoplay.default" = 5; # 阻止自动播放
        "media.ffmpeg.vaapi.enabled" = true;

        # 开发者设置
        "devtools.theme" = "dark";
        "devtools.toolbox.host" = "window";
        "devtools.toolbox.selectedTool" = "webconsole";

        # 实验性功能
        "dom.security.csp.enable" = true;
        "javascript.options.wasm_baselinejit" = true;
      };

      # 用户样式
      userChrome = userChrome;
      userContent = userContent;

      # 搜索引擎
      search = {
        default = "Qwant";
        force = true;
        engines = {
          "Qwant" = {
            urls = [
              {
                template = "https://www.qwant.com/?q={searchTerms}";
              }
            ];
          };
          "Home Manager" = {
            urls = [
              {
                template = "https://home-manager-options.extranix.com/?query={searchTerms}";
              }
            ];
          };
          "Nixpkgs" = {
            urls = [
              {
                template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
              }
            ];
          };
          "GitHub" = {
            urls = [
              {
                template = "https://github.com/search?q={searchTerms}";
              }
            ];
          };
          "Noogle" = {
            urls = [
              {
                template = "https://noogle.dev/q?term={searchTerms}";
              }
            ];
          };
        };
      };
    };

    # 策略
    inherit policies;
  };

  # uBlock Origin 配置文件
  home.file.".mozilla/firefox/default/managed-storage/uBlock0@raymondhill.net.json".text = builtins.toJSON {
    name = "uBlock0@raymondhill.net";
    type = "storage";
    data = {
      adminSettings = {
        userSettings = {
          uiTheme = "dark";
          uiLang = "zh-CN";
          selectedFilterLists = ublock-filter-lists;
        };
      };
    };
  };

  # Betterfox 配置
  home.file.".mozilla/firefox/default/betterfox.js".text = ''
    /* Betterfox - 用户配置优化 */
    // 参考: https://github.com/yokoffing/Betterfox

    /* 性能优化 */
    user_pref("gfx.webrender.all", true);
    user_pref("layers.acceleration.force-enabled", true);
    user_pref("media.hardware-video-decoding.force-enabled", true);
    user_pref("dom.ipc.processCount", 8);

    /* 隐私增强 */
    user_pref("privacy.trackingprotection.enabled", true);
    user_pref("privacy.resistFingerprinting", true);
    user_pref("privacy.donottrackheader.enabled", true);
    user_pref("privacy.trackingprotection.socialtracking.enabled", true);

    /* 安全增强 */
    user_pref("network.http.referer.spoofSource", true);
    user_pref("network.cookie.cookieBehavior", 5);
    user_pref("security.family_safety.mode", 0);

    /* UI 优化 */
    user_pref("browser.compactmode.show", true);
    user_pref("browser.tabs.unloadOnLowMemory", true);
    user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
    user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
  '';
}
