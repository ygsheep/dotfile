{pkgs, ...}: {
  users.users.sheep = {
    isNormalUser = true;
    shell = pkgs.nushell;
    extraGroups = [
      "adbusers"
      "input"
      "networkmanager"
      "plugdev"
      "video"
      "wheel"
      "kvm"
    ];
  };
}
