{pkgs, ...}: {
  imports = [
    ./chromium-flags.nix
  ];

  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    # 扩展管理禁用 - 与 PSD (Profile Sync Daemon) 冲突
    # 请手动安装扩展: Ublock Origin, Auto-Tab-Discard, Bitwarden
  };
}
