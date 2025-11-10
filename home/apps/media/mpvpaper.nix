{pkgs, ...}: {
  programs.mpvpaper = {
    enable = true;
    pauseList = ''
      firefox
      obs
    '';
    stopList = ''
      firefox
    '';
  }
}