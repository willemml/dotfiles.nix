{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./default.nix
    ../linux.nix
  ];
  home-manager.users.willem = ../../../../home/linux/default.nix;
}
