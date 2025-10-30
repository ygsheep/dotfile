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
    specialArgs = {inherit inputs self;};
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
