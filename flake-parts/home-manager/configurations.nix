{ lib, flake-parts-lib, self, ... }:
let
  inherit (lib) mkOption types;
  inherit (flake-parts-lib) mkTransposedPerSystemModule;
in
mkTransposedPerSystemModule
{
  name = "homeConfigurations";
  file = ./configurations.nix;
  option = mkOption {
    type = types.lazyAttrsOf types.unspecified;
    default = { };
    description = "Home Manager user configurations.";
  };
}

