{
  config,
  inputs,
  pkgs,
  globals,
  ...
}: {
  imports = [
    ./cli  # 移动后的终端配置
    ./editors
    ./desktop  # 新增桌面环境配置
    ./apps  # 移动后的应用程序配置
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
    autoEnable = false;
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
      nixos-icons.enable = true;
      nushell.enable = true;
      starship.enable = true;
      vesktop.enable = true;
      yazi.enable = true;
    };
  };
}
