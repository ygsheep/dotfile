{pkgs, ...}: {
  # graphics drivers / HW accel
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      libva
      libva-vdpau-driver
      libvdpau-va-gl
      # amdvlk deprecated & replaced with radv
      mesa
      xwayland
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      libva-vdpau-driver
      libvdpau-va-gl
      # amdvlk deprecated & replaced with radv
    ];
  };

  # Enable XWayland for Java applications
  programs.xwayland.enable = true;

  # Niri uses xwayland-satellite
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];
}
