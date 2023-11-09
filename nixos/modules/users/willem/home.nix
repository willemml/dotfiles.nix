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
      inputs.nix-index-database.hmModules.nix-index
      ../../../../home/linux/default.nix
    ];
  };

  home-manager.extraSpecialArgs = {inherit inputs overlays globals;};
}
