{...}: {
  imports = [./default.nix];
  virtualisation.vmVariant.virtualisation.graphics = false;
  virtualisation.graphics = false;
}
