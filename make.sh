sudo cp  *.nix /etc/nixos/
sudo cp -r home /etc/nixos/
sudo cp -r modules /etc/nixos/
sudo cp -r hosts /etc/nixos/
sudo nixos-rebuild switch --show-trace 
