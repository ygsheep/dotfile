{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./vscode
    ./zed
    ./helix
    ./nvim
  ];
}
