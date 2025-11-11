{
  self,
  inputs,
  homeImports,
  ...
}: {
  flake.nixosConfigurations = let
    # shorten paths
    inherit (inputs.nixpkgs.lib) nixosSystem;
    mod = "${self}/system";

    # get the basic config to build on top of
    inherit (import "${self}/system") desktop laptop;

    # get these into the module system
    globals = import "${self}/lib/globals.nix" {inherit self;};
    specialArgs = {inherit inputs self globals;};
  in {
    desktop = nixosSystem {
      inherit specialArgs;
      modules =
        desktop
        ++ laptop
        ++ [
          ./desktop
          "${mod}/programs/gamemode.nix"
          "${mod}/core/limine.nix"
          {
            home-manager = {
              users.sheep.imports =
                homeImports."sheep@desktop";
              extraSpecialArgs = specialArgs;
              backupFileExtension = "backup";
            };
          }

          inputs.agenix.nixosModules.default
          inputs.chaotic.nixosModules.default
        ];
    };
  };
}