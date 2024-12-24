{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "https://mirrors.ustc.edu.cn/nix-channels/nixos-24.11/nixexprs.tar.xz";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #home-manager.url = "github:nix-community/home-manager";
    home-manager.url = "github:nix-community/home-manager/release-24.11"; # 强制使用 release-24.11 版本
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = {
      nixpkgs,
      home-manager,
      hyprpanel,
      ...
    }@inputs: 
    let
      system = "x86_64-linux"; # change to whatever your system should be
      pkgs = inputs.nixpkgs;
      lib = nixpkgs.lib;
      mkSystem = pkgs: system: hostname:
        pkgs.lib.nixosSystem {
          system = system;
          specialArgs = {
            inherit system;
            inherit inputs;
          };
          modules = [
            {nixpkgs.overlays = [inputs.hyprpanel.overlay];}
            { networking.hostName = hostname; }
            # General configuration (users, networking, sound, etc)
            ./modules/configuration.nix
            # Hardware config (bootloader, kernel modules, filesystems, etc)
            # DO NOT USE MY HARDWARE CONFIG!! USE YOUR OWN!!
            (./. + "/hosts/${hostname}/hardware-configuration.nix")
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                extraSpecialArgs = { inherit inputs; };
                backupFileExtension = "backup";
                # Home manager config (configures programs like firefox, zsh, eww, etc)
                users.sheep = import ( ./. + "/hosts/${hostname}/user.nix");
              };
              nixpkgs.overlays = [
                # Add nur overlay for Firefox addons
                # (import ./overlays)
                # inputs.hyprpanel.overlay
              ];
            }
          ];
        };
    in 
    {
      nixosConfigurations = {
        desktop = mkSystem inputs.nixpkgs "x86_64-linux" "desktop";
        nixos   = mkSystem inputs.nixpkgs "x86_64-linux" "desktop";
      };
    };
  # homeConfigurations."hyprland" = home-manager.lib.homeManagerConfiguration {
  #   pkgs = import nixpkgs {
  #     inherit system;
  #     overlays = [
  #       inputs.hyprpanel.overlay
  #     ];
  #   };
  #   modules = [
  #    ./home/hyprland.nix
  #  ];
  #   extraSpecialArgs = {
  #     inherit system;
  #     inherit inputs;
  #   };
  # };
}
