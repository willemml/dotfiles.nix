{
  inputs,
  globals,
  overlays,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager.users.willem = {
    imports = [
      ../../../../home/linux/default.nix
    ];
  };

  home-manager.extraSpecialArgs = {inherit inputs overlays globals;};
}
