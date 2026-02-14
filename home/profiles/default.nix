{
  self,
  inputs,
  ...
}: let
  # get these into the module system
  extraSpecialArgs = {inherit inputs self;};

  homeImports = {
    "sheep@desktop" = [
      ../.
      ./desktop
    ];
    "sheep@thinkbook" = [
      ../.
      ./thinkbook
    ];
  };

  inherit (inputs.hm.lib) homeManagerConfiguration;

  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in {
  _module.args = {inherit homeImports;};

  flake = {
    homeConfiguration = {
      "sheep_desktop" = homeManagerConfiguration {
        modules = homeImports."sheep@desktop";
        inherit pkgs extraSpecialArgs;
      };
      "sheep_thinkbook" = homeManagerConfiguration {
        modules = homeImports."sheep@thinkbook";
        inherit pkgs extraSpecialArgs;
      };
    };
  };
}
