{inputs, ...}: {
  imports = [inputs.nixos-apple-silicon.nixosModules.apple-silicon-support];
  nixpkgs.overlays = [inputs.nixos-apple-silicon.overlays.default];
}
