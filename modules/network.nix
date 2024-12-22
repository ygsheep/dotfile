{ config, pkgs, ... }:
{
  networking.hostName = "desktop";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  networking.proxy.default = "http://127.0.0.1:20171";
  networking.proxy.noProxy = "192.168.123.1;127.0.0.1,localhost,internal.domain";
  # hosts
  networking.extraHosts ='''';

  # Enable networking
  networking.networkmanager.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    substituters = [ 
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
      "https://ezkea.cachix.org"
      ];
  };

}
