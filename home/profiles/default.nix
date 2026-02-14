{
  self,
  inputs,
  ...
}: let
  # get these into the module system
  globals = import "${self}/lib/globals.nix" {inherit self;};
  extraSpecialArgs = {inherit inputs self globals;};

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

  # 使用与系统相同的 nixpkgs 配置（包括 allowUnfree）
  pkgs = import inputs.nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
    config.permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };
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
