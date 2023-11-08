{...}: {
  imports = [./vm.nix];
  virtualisation.vmVariant.virtualisation.graphics = false;
  virtualisation.graphics = false;
}
