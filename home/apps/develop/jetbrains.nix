{pkgs, ...}: {
  home.packages = with pkgs; [
    # JetBrains Toolbox - 管理 JetBrains IDEs
    jetbrains.toolbox
  ];
}
