{inputs, ...}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ./default.nix
    ../darwin.nix
  ];
  home-manager.users.willem = ../../../../home/darwin/default.nix;
}
