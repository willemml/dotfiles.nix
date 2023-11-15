{
  inputs,
  globals,
  overlays,
  ...
}: {
  home-manager.extraSpecialArgs = {inherit inputs overlays globals;};
}
