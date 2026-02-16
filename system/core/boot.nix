{
  config,
  inputs,
  pkgs,
  ...
}: {
  # Apply CachyOS kernel overlay
  nixpkgs.overlays = [inputs.nix-cachyos-kernel.overlays.pinned];

  boot = {
    bootspec.enable = true;

    initrd = {
      systemd.enable = true;
    };
    supportedFilesystems = ["ntfs" "ntfs3g"];

    # Use CachyOS LTS kernel for better performance and hardware support
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-lts;

    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
      "plymouth.use-simpledrm"
    ];

    loader = {
      # systemd-boot on UEFI
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.graceful = true;
      # 限制保留的启动项数量（自动清理旧 generations）
      systemd-boot.configurationLimit = 10;
    };

    plymouth.enable = true;

    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
  };
  systemd.services.nix-daemon = {
    environment = {
      TMPDIR = "/var/tmp";
    };
  };
  environment.systemPackages = [
    config.boot.kernelPackages.cpupower
    pkgs.ntfs3g
  ];
}
