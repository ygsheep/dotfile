{
  self,
  inputs,
  ...
}: let
  # get these into the module system
  globals = import "${self}/lib/globals.nix" {inherit self;};
  extraSpecialArgs = {inherit inputs self globals;};

  homeImports = {
    "${globals.user}@desktop" = [
      ../.
      ./desktop
    ];
    "${globals.user}@thinkbook" = [
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
      "${globals.user}_desktop" = homeManagerConfiguration {
        modules = homeImports."${globals.user}@desktop";
        inherit pkgs extraSpecialArgs;
      };
      "${globals.user}_thinkbook" = homeManagerConfiguration {
        modules = homeImports."${globals.user}@thinkbook";
        inherit pkgs extraSpecialArgs;
      };
    };
  };
}
