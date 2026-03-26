{
  config,
  inputs,
  pkgs,
  lib,
  globals,
  ...
}: {
  imports = [
    ./cli # 移动后的终端配置
    ./editors
    ./desktop/wayland # 新增桌面环境配置
    ./apps # 移动后的应用程序配置
    ./programs/input-method
    ./programs/version-control
    inputs.nix-index-db.homeModules.nix-index
    inputs.stylix.homeModules.stylix
  ];
  home = {
    username = globals.user;
    homeDirectory = globals.homeDir;
    stateVersion = "25.05";
  };

  # 用户级代理环境变量
  home.sessionVariables = {
    http_proxy = globals.proxy.http;
    HTTP_PROXY = globals.proxy.http;
    https_proxy = globals.proxy.https;
    HTTPS_PROXY = globals.proxy.https;
    socks_proxy = globals.proxy.socks;
    SOCKS_PROXY = globals.proxy.socks;
    no_proxy = globals.proxy.noProxy;
    NO_PROXY = globals.proxy.noProxy;
    GTK_THEME = "Breeze-Dark"; # 使用 Breeze 深色主题
  };

  # disable manuals as nmd fails to build often
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;

  programs.nix-index = {
    enable = true;
    # enableNushellIntegration = true;
  };

  stylix = {
    enable = true;
    autoEnable = true; # 启用自动主题管理
    polarity = "dark";
    opacity = {
      popups = 1.0;
      terminal = 1.0;
    };

    fonts = {
      serif = config.stylix.fonts.sansSerif;
      sansSerif = {
        package = pkgs.adwaita-fonts;
        name = "Adwaita Sans";
      };

      monospace = {
        package = pkgs.nerd-fonts.geist-mono;
        name = "Geist Nerd Font Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    base16Scheme = "${inputs.self}/home/shared/colors/gruvbox-dark-hard.yml";

    targets = {
      bat.enable = true;
      gtk.enable = true; # GTK 深色主题
      kde.enable = true; # KDE 深色主题
      helix.enable = false; # 使用自定义 Helix 设置
      hyprlock.enable = false; # 使用自定义 Hyprlock 设置
      noctalia-shell.enable = false; # 使用自定义 Noctalia 设置
      vscode.enable = false; # 使用自定义 VSCode 设置
      nixos-icons.enable = true;
      nushell.enable = true;
      starship.enable = true;
      vesktop.enable = true;
      yazi.enable = true;
    };
  };
}
