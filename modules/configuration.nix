# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:
{
  imports = [
    ./system.nix
    ./network.nix
    ./local.nix
    ./grub.nix
  ];

  system.stateVersion = "24.11"; 

  # 新增用户 sheep
  users.users.sheep = {
    isNormalUser = true;
    description = "sheep";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [zsh];
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # 启用 Flakes 特性以及配套的船新 nix 命令行工具
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [git vim wget];
}
