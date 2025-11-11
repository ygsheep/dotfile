# systems/chinese/localization.nix - 中文本地化设置
{
  config,
  pkgs,
  lib,
  ...
}: {
  # 中文环境变量
  environment.sessionVariables = {
    # 语言设置
    LANG = "zh_CN.UTF-8";
    LANGUAGE = "zh_CN:en_US";
    LC_ALL = "zh_CN.UTF-8";

    # 中文字体渲染
    FONTCONFIG_FILE = "/etc/fonts/fonts.conf";

    # 应用程序中文化
    MOZ_USE_XINPUT2 = "1"; # Firefox 触摸支持
  };

  # 中文相关软件包
  environment.systemPackages = with pkgs; [
    # 中文字体管理
    font-manager

    # 中文办公软件
    libreoffice-fresh
    # wpsoffice      # WPS Office（如果可用）
  ];

  # 中文区域设置详细配置
  i18n = {
    # 主要语言环境
    defaultLocale = "zh_CN.UTF-8";

    # 详细的区域设置
    extraLocaleSettings = {
      LC_ADDRESS = "zh_CN.UTF-8"; # 地址格式
      LC_IDENTIFICATION = "zh_CN.UTF-8"; # 区域标识
      LC_MEASUREMENT = "zh_CN.UTF-8"; # 度量单位
      LC_MONETARY = "zh_CN.UTF-8"; # 货币格式
      LC_NAME = "zh_CN.UTF-8"; # 姓名格式
      LC_NUMERIC = "zh_CN.UTF-8"; # 数字格式
      LC_PAPER = "zh_CN.UTF-8"; # 纸张尺寸
      LC_TELEPHONE = "zh_CN.UTF-8"; # 电话号码格式
      LC_TIME = "zh_CN.UTF-8"; # 时间格式
      LC_COLLATE = "zh_CN.UTF-8"; # 排序规则
      LC_CTYPE = "zh_CN.UTF-8"; # 字符分类
      LC_MESSAGES = "zh_CN.UTF-8"; # 消息语言
    };

    # 支持的语言环境
    supportedLocales = [
      "zh_CN.UTF-8/UTF-8" # 简体中文
      "zh_TW.UTF-8/UTF-8" # 繁体中文
      "en_US.UTF-8/UTF-8" # 美式英语
      "en_GB.UTF-8/UTF-8" # 英式英语
      "C.UTF-8/UTF-8" # POSIX
    ];
  };

  # 控制台中文支持
  console = {
    useXkbConfig = true;
  };

  # 时区设置
  time.timeZone = "Asia/Shanghai";

  # 中文键盘布局
  services.xserver.xkb = {
    layout = "cn"; # 中文键盘布局
    options = "caps:escape,ctrl:nocaps"; # Caps Lock 点按为 ESC，组合为 Ctrl
  };
}
