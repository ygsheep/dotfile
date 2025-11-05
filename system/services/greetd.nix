{pkgs, config, ...}: {
  # 注释掉 greetd display manager，改用 SDDM
  /*
  services.greetd = {
    enable = true;
    settings = {
      terminal.vt = 1;
      default_session = {
        command = "${pkgs.cage}/bin/cage -s -- ${pkgs.greetd.tuigreet}/bin/tuigreet --greeting '欢迎来到 Niri Desktop' --cmd ${pkgs.niri}/bin/niri-session";
        user = "greeter";
      };
      initial_session = {
        command = "${pkgs.niri}/bin/niri-session";
        user = "sheep";
      };
    };
  };
  */

  # 使用 SDDM 作为显示管理器
  services = {
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
  };

  # SDDM Astronaut 主题配置
  # 注意：由于 sddm-astronaut-theme 可能不在 nixpkgs 中，
  # 你需要使用以下方法之一来安装主题：
  #
  # 方法 1: 使用 flake 输入（推荐）
  # 在你的 flake.nix 中添加主题作为输入
  #
  # 方法 2: 手动安装脚本
  # 系统安装后运行安装脚本
  # sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"
  #
  # 方法 3: 使用 Nix 表达式构建主题
  # 
  
  # 临时使用默认主题，建议安装后手动配置
  services.displayManager.sddm.theme = "breeze";
  
  # 创建 SDDM 配置文件
  environment.etc."sddm.conf".text = ''
    [Theme]
    Current=breeze
    # 安装 astronaut 主题后，改为:
    # Current=sddm-astronaut-theme
  '';

  # 创建虚拟键盘配置（为 astronaut 主题准备）
  environment.etc."sddm.conf.d/virtualkbd.conf".text = ''
    [General]
    InputMethod=qtvirtualkeyboard
  '';

  # 安装后配置脚本提示
  system.userActivationScripts.setupSddmAstronaut = ''
    echo "🚀 SDDM Astronaut 主题安装指南："
    echo "1. 运行安装脚本:"
    echo "   sudo sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)\""
    echo ""
    echo "2. 编辑 /etc/sddm.conf:"
    echo "   [Theme]"
    echo "   Current=sddm-astronaut-theme"
    echo ""
    echo "3. 重启 SDDM 服务:"
    echo "   sudo systemctl restart sddm"
  '';

  # Set up session variables for Wayland
  environment.sessionVariables = {
    # Variables for Wayland session
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    # Fix for Wayland session variables
    XDG_SESSION_TYPE = "wayland";
  };
}
