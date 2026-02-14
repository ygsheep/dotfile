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
      inputs.chaotic.nixosModules.default
    ];

    # desktop 主机配置
    desktopModules =
      desktop
      ++ laptop
      ++ [
        ./desktop
        "${mod}/programs/gamemode.nix"
        "${mod}/core/limine.nix"
        {
          home-manager = {
            users.sheep.imports = homeImports."sheep@desktop";
            extraSpecialArgs = specialArgs;
            backupFileExtension = "bak";
          };
        }
      ];

    # thinkbook 主机配置
    thinkbookModules =
      desktop
      ++ laptop
      ++ [
        ./thinkbook
        "${mod}/core/gnome.nix" # GNOME 桌面环境 + GDM
        "${mod}/services/gnome-services.nix"
        {
          # 禁用 greetd，使用 GDM 作为显示管理器
          services.greetd.enable = lib.mkForce false;

          home-manager = {
            users.sheep.imports = homeImports."sheep@thinkbook";
            extraSpecialArgs = specialArgs;
            backupFileExtension = "bak";
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
