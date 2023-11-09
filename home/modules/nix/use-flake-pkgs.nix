{inputs, ...}: {
  home.sessionVariables.NIX_PATH = "nixpkgs=${inputs.nixpkgs}";
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
}
