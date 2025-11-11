{pkgs, ...}: {
  # Ensure swww package is available system-wide
  environment.systemPackages = [pkgs.swww];
}
