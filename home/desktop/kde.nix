# KDE Plasma 主题配置
# chromeOS-dark 全局主题 + Bibata Modern Ice 光标 + Klassy 窗口装饰
{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # ========== 图标主题 ==========
    papirus-icon-theme # 现代扁平化图标
    # whitesur-icon-theme 已在 gtk.nix 中配置

    # ========== 窗口主题 ==========
    orchis-theme # 现代 GTK/Qt 窗口主题

    # ========== 光标主题 ==========
    bibata-cursors # Bibata Modern Ice (通过系统设置选择)

    # ========== Fcitx5 KDE 集成 ==========
    kdePackages.fcitx5-qt # Qt5/Qt6 输入法支持
    qt6Packages.fcitx5-configtool # Fcitx5 图形配置工具

    # ========== KDE 组件 ==========
    kdePackages.breeze # 默认 Breeze 主题
    kdePackages.breeze-gtk # Breeze GTK 引擎
    kdePackages.qt6ct # Qt6 配置工具
    klassy # chromeOS-dark 窗口装饰依赖

    # ========== ChromeOS-kde 主题（自动安装）==========
    # 从 GitHub 自动安装 ChromeOS KDE Plasma 全局主题
    (pkgs.stdenvNoCC.mkDerivation {
      pname = "ChromeOS-kde";
      version = "2020-04-02";

      src = pkgs.fetchFromGitHub {
        owner = "vinceliuice";
        repo = "ChromeOS-kde";
        rev = "b9fe1bd";
        hash = "sha256-5qNjAHcNfiOjYsoVMcsnx5TMCMtJHyNS4xSt2AzRj+Y=";
      };

      buildInputs = [bash];

      buildPhase = "# 主题不需要编译";

      installPhase = ''
        mkdir -p $out/share

        # 安装 Plasma Look-and-Feel 主题
        mkdir -p $out/share/plasma/look-and-feel
        cp -r plasma/look-and-feel/com.github.vinceliuice.ChromeOS \
          $out/share/plasma/look-and-feel/

        # 安装颜色方案
        mkdir -p $out/share/color-schemes
        cp color-schemes/*.colors $out/share/color-schemes/

        # 安装 Plasma 主题
        mkdir -p $out/share/plasma/desktoptheme
        cp -r plasma/desktoptheme/ChromeOS* $out/share/plasma/desktoptheme/ 2>/dev/null || true

        # 安装 Kvantum 主题
        mkdir -p $out/share/Kvantum
        cp -r Kvantum/* $out/share/Kvantum/ 2>/dev/null || true

        # 安装 Aurorae 主题
        mkdir -p $out/share/aurorae/themes
        cp -r aurorae/* $out/share/aurorae/themes/ 2>/dev/null || true
      '';

      meta = with lib; {
        description = "ChromeOS theme for KDE Plasma";
        homepage = "https://github.com/vinceliuice/ChromeOS-kde";
        license = licenses.gpl3Plus;
      };
    })

    # ========== KDE 实用应用 ==========
    kdePackages.dolphin # 文件管理器
    kdePackages.okular # PDF 阅读器
    kdePackages.gwenview # 图片查看器
    kdePackages.ark # 压缩工具
    kdePackages.kate # 文本编辑器
    # kdePackages.konsole # 终端 (已移除，使用 kitty/foot)
    kdePackages.spectacle # KDE 内置截图工具
    ksnip # 功能更强大的截图工具（支持 Wayland）

    # ========== KDE 系统工具 ==========
    kdePackages.kde-gtk-config # GTK 配置集成
    kdePackages.systemsettings # 系统设置
    kdePackages.kdeconnect-kde # KDE Connect 设备连接
    kdePackages.powerdevil # 电源管理和亮度控制（禁用自动配置切换）
    kdePackages.plasma-browser-integration # 浏览器集成
    kdePackages.kscreen # 显示器管理
    kdePackages.ksystemlog # 系统日志查看器
    kdePackages.kwallet # 密钥管理
    kdePackages.bluedevil # 蓝牙管理 GUI
  ];

  # ========== 禁用 PowerDevil 的自动电源配置切换 ==========
  # 原因：与 power-monitor 脚本冲突，会导致配置来回切换
  # 解决：让 power-monitor 脚本完全接管电源配置管理
  #
  # 注意：PowerDevil 在 Plasma 6 中可能通过 D-Bus 控制 power-profiles-daemon
  # 这个配置文件主要保留亮度控制和休眠设置，禁用电源配置自动切换
  xdg.configFile."powerdevilrc".text = ''
    [AC][Display]
    DimDisplayIdleTimeoutSec=-1
    DimDisplayWhenIdle=false
    TurnOffDisplayIdleTimeoutSec=-1
    TurnOffDisplayWhenIdle=false

    [AC][SuspendAndShutdown]
    AutoSuspendAction=0
    AutoSuspendIdleTimeoutSec=1800

    [Battery][Display]
    DimDisplayIdleTimeoutSec=-1
    DimDisplayWhenIdle=false
    TurnOffDisplayIdleTimeoutSec=-1
    TurnOffDisplayWhenIdle=false

    [Battery][SuspendAndShutdown]
    AutoSuspendAction=0
  '';

  # ========== KDE Connect 服务 ==========
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  # KDE Connect 不使用代理（需要发现本地设备）
  systemd.user.services.kdeconnect.environment = {
    http_proxy = "";
    HTTP_PROXY = "";
    https_proxy = "";
    HTTPS_PROXY = "";
    no_proxy = "*";
    NO_PROXY = "*";
  };
  systemd.user.services.kdeconnect-indicator.environment = {
    http_proxy = "";
    HTTP_PROXY = "";
    https_proxy = "";
    HTTPS_PROXY = "";
    no_proxy = "*";
    NO_PROXY = "*";
  };

  # ========== Qt 配置 ==========
  # 注意：完整 KDE Plasma 环境下不需要手动配置 Qt
  qt = {
    enable = true;
    platformTheme.name = lib.mkForce "kde"; # 强制使用 KDE 平台主题
  };

  # ========== Godot 兼容性说明 ==========
  # Godot 启动脚本位于: home/apps/develop/godot.nix
  # 使用 godot4-kde 命令启动 Godot，自动应用 KDE Wayland 兼容性设置

  # ========== 主题配置文件 ==========
  # Gruvbox Dark Hard 标准配色方案
  # 参考: home/shared/colors/gruvbox-dark-hard.yml
  xdg.dataFile = {
    "color-schemes/GruvboxDarkHard.colors".text = ''
      [General]
      Name=GruvboxDarkHard
      ColorScheme=GruvboxDarkHard

      [ColorEffects:Disabled]
      Color=102,92,84
      ColorAmount=0
      ColorEffect=0
      ContrastAmount=0.65
      ContrastEffect=1
      IntensityAmount=0.25
      IntensityEffect=2

      [ColorEffects:Inactive]
      ChangeSelectionColor=true
      Color=80,73,69
      ColorAmount=0
      ColorEffect=0
      ContrastAmount=0.1
      ContrastEffect=1
      Enable=true
      IntensityAmount=0.15
      IntensityEffect=2

      [Colors:Button]
      BackgroundAlternate=29,32,33
      BackgroundNormal=60,56,54
      DecorationFocus=142,192,124
      DecorationHover=184,187,38
      ForegroundActive=251,241,199
      ForegroundInactive=235,219,178
      ForegroundLink=250,189,47
      ForegroundNegative=251,73,52
      ForegroundNeutral=254,128,25
      ForegroundNormal=235,219,178
      ForegroundPositive=184,187,38

      [Colors:Complementary]
      BackgroundAlternate=29,32,33
      BackgroundNormal=60,56,54
      DecorationFocus=142,192,124
      DecorationHover=184,187,38
      ForegroundActive=251,241,199
      ForegroundInactive=235,219,178
      ForegroundLink=250,189,47
      ForegroundNegative=251,73,52
      ForegroundNeutral=254,128,25
      ForegroundNormal=235,219,178
      ForegroundPositive=184,187,38

      [Colors:Header]
      BackgroundAlternate=29,32,33
      BackgroundNormal=29,32,33
      DecorationFocus=142,192,124
      DecorationHover=184,187,38
      ForegroundActive=251,241,199
      ForegroundInactive=251,241,199
      ForegroundLink=250,189,47
      ForegroundNegative=251,73,52
      ForegroundNeutral=254,128,25
      ForegroundNormal=251,241,199
      ForegroundPositive=184,187,38

      [Colors:Selection]
      BackgroundAlternate=142,192,124
      BackgroundNormal=184,187,38
      DecorationFocus=184,187,38
      DecorationHover=142,192,124
      ForegroundActive=29,32,33
      ForegroundInactive=29,32,33
      ForegroundLink=29,32,33
      ForegroundNegative=29,32,33
      ForegroundNeutral=29,32,33
      ForegroundPositive=29,32,33

      [Colors:Tooltip]
      BackgroundAlternate=29,32,33
      BackgroundNormal=29,32,33
      DecorationFocus=142,192,124
      DecorationHover=184,187,38
      ForegroundActive=251,241,199
      ForegroundInactive=251,241,199
      ForegroundLink=250,189,47
      ForegroundNegative=251,73,52
      ForegroundNeutral=254,128,25
      ForegroundNormal=251,241,199
      ForegroundPositive=184,187,38

      [Colors:View]
      BackgroundAlternate=29,32,33
      BackgroundNormal=29,32,33
      DecorationFocus=142,192,124
      DecorationHover=184,187,38
      ForegroundActive=251,241,199
      ForegroundInactive=235,219,178
      ForegroundLink=250,189,47
      ForegroundNegative=251,73,52
      ForegroundNeutral=254,128,25
      ForegroundNormal=235,219,178
      ForegroundPositive=184,187,38

      [Colors:Window]
      BackgroundAlternate=29,32,33
      BackgroundNormal=29,32,33
      DecorationFocus=142,192,124
      DecorationHover=184,187,38
      ForegroundActive=251,241,199
      ForegroundInactive=235,219,178
      ForegroundLink=250,189,47
      ForegroundNegative=251,73,52
      ForegroundNeutral=254,128,25
      ForegroundNormal=235,219,178
      ForegroundPositive=184,187,38

      [WM]
      activeBackground=29,32,33
      activeForeground=235,219,178
      inactiveBackground=60,56,54
      inactiveForeground=235,219,178
    '';
  };

  xdg.configFile = {
    # KDE 全局主题配置
    "kdeglobals".text = ''
        [General]
        ColorScheme=GruvboxDarkHard
        Name=Default
        XftAntialias=true
        XftHintStyle=hintmedium
        XftSubPixel=none
        TerminalApplication=kitty
        Browser=firefox

      [KDE]
        SingleClick=true
        ShowDeleteCommand=false
        # LookAndFeelPackage=org.kde.breezedark.desktop
        LookAndFeelPackage=com.github.vinceliuice.ChromeOS-dark

        [Icons]
        Theme=Papirus-Dark

        [WM]
        activeFont=Noto Sans,10,-1,5,50,0,0,0,0,0
        inactiveFont=Noto Sans,10,-1,5,50,0,0,0,0,0
        activeBackground=29,32,33
        activeForeground=235,219,178
        inactiveBackground=60,56,54
        inactiveForeground=235,219,178

      # KDE 应用程序暗色背景设置
      [Colors:Button]
        BackgroundNormal=60,56,54
        ForegroundNormal=235,219,178
        ForegroundInactive=235,219,178

      [Colors:Header]
        BackgroundNormal=29,32,33
        ForegroundNormal=251,241,199
        ForegroundInactive=251,241,199

      [Colors:View]
        BackgroundNormal=29,32,33
        ForegroundNormal=235,219,178

      [Colors:Window]
        BackgroundNormal=29,32,33
        ForegroundNormal=235,219,178

      [Colors:Selection]
        BackgroundNormal=184,187,38
        ForegroundNormal=29,32,33
    '';

    # Klassy 窗口装饰配置（chromeOS-dark 风格）
    "klassyrc".text = ''
      [Common]
      BorderSize=2
      DrawBorderOnMaximizedWindows=false
      EnableBlurBehind=true
      ShadowStrength=50

      [Windeco]
      ButtonSize=40
      BorderSize=2
      TitleBarSize=30
      TitleBarSidePadding=10

      [Colors:Button]
      BackgroundAlternate=29,32,33
      BackgroundNormal=29,32,33
      DecorationFocus=142,192,124
      ForegroundNormal=235,219,178

      [Colors:TitleBar]
      BackgroundNormal=29,32,33
      ForegroundNormal=235,219,178
      BackgroundActive=29,32,33
      ForegroundActive=235,219,178
      BackgroundInactive=60,56,54
      ForegroundInactive=235,219,178

      [Colors]
      UseThemeColors=true
      BlendTitleBarColors=true
    '';

    # Plasma 样式配置
    "plasmarc".text = ''
      [General]
      # ChromeOS Plasma 样式（深色主题通过 LookAndFeelPackage 控制）
      PlasmaStyle=ChromeOS
      PlasmaTheme=ChromeOS

      [Theme]
      name=ChromeOS
    '';

    # KDE 颜色模块配置
    "kcmrc".text = ''
      [General]
      ColorScheme=GruvboxDarkHard
    '';
  };

  # ========== 环境变量 ==========
  home.sessionVariables = {
    # KDE 应用使用 Breeze (强制覆盖 Stylix 的 qtct)
    QT_QPA_PLATFORMTHEME = lib.mkForce "kde";
    # 强制 Qt 应用使用暗色主题
    QT_STYLE_OVERRIDE = "breeze";
    # GTK 应用使用 Breeze 深色主题
    GTK_THEME = "Breeze-Dark";
  };
}
