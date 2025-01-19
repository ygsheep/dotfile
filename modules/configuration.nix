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

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
  # Add any missing dynamic libraries for unpackaged programs
    pkgs.stylua
    pkgs.pyright
  ];

  # 新增用户 sheep
  users.users.sheep = {
    isNormalUser = true;
    description = "sheep";
    extraGroups = [ "networkmanager" "wheel" "docker"  ];
    packages = with pkgs; [zsh];
  };
  users.defaultUserShell = pkgs.zsh;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };
    histSize = 10000;
  };
  environment.shells = with pkgs; [ zsh ];
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    gcc

  ];

  # 将 GCC 添加到环境变量中
  environment.variables = {
    CC = "gcc";
    CXX = "g++";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    host="0.0.0.0";
    environmentVariables = {
    };
  };
  # 启用 Flakes 特性以及配套的船新 nix 命令行工具
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
