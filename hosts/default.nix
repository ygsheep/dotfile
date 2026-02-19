{
  self,
  inputs,
  homeImports,
  ...
}: {
  flake.nixosConfigurations = let
    # shorten paths
    inherit (inputs.nixpkgs.lib) nixosSystem;
    lib = inputs.nixpkgs.lib;
    mod = "${self}/system";

    # get the basic config to build on top of
    inherit (import "${self}/system") desktop laptop;

    # get these into the module system
    globals = import "${self}/lib/globals.nix" {inherit self;};
    specialArgs = {inherit inputs self globals;};

    # 通用模块列表
    commonModules = [
      inputs.agenix.nixosModules.default
      inputs.hm.nixosModules.home-manager
    ];

    # 导入 overlays 集合（如有）

    # 导入 cachyos-kernel overlay 的主机已在其模块中单独定义

    # desktop 主机配置
    desktopModules =
      desktop
      ++ laptop
      ++ [
        ./desktop
        "${mod}/core/limine.nix"
        {
          home-manager = {
            users.${globals.user}.imports = homeImports."${globals.user}@desktop";
            extraSpecialArgs = specialArgs;
            backupFileExtension = "bak";
            useUserPackages = true;
            useGlobalPkgs = true;
          };
        }
      ];

    # thinkbook 主机配置
    thinkbookModules =
      desktop
      ++ laptop
      ++ [
        ./thinkbook
        "${mod}/desktop/kde.nix" # KDE Plasma 6 桌面环境 + SDDM
        "${mod}/desktop/gnome.nix" # GNOME 42 桌面环境（与 KDE 共存）
        {
          home-manager = {
            users.${globals.user}.imports = homeImports."${globals.user}@thinkbook";
            extraSpecialArgs = specialArgs;
            backupFileExtension = "bak";
            useUserPackages = true;
            useGlobalPkgs = true;
          };
        }
      ];
  in {
    desktop = nixosSystem {
      inherit specialArgs;
      modules = desktopModules ++ commonModules;
    };

    thinkbook = nixosSystem {
      inherit specialArgs;
      modules = thinkbookModules ++ commonModules;
    };
  };
}
