# Copyright (c) 2018 Terje Larsen
# This work is licensed under the terms of the MIT license.
# For a copy, see https://opensource.org/licenses/MIT.
# https://github.com/terlar/nix-config/blob/00c8a3622e8bc4cb522bbf335e6ede04ca07da40/flake-parts/home-manager/modules.nix
{
  lib,
  self,
  inputs,
  ...
}: {
  flake.homeManagerModules = let
    modules = self.lib.importDirToAttrs ../../home-manager/modules;
    non-darwin-modules = lib.filterAttrs (n: v: !(lib.hasInfix "darwin" n)) modules;
    darwin-modules = lib.filterAttrs (n: v: (lib.hasInfix "darwin" n)) modules;
  in
    {
      default = {
        imports = builtins.attrValues non-darwin-modules;
      };

      darwin = {
        imports = builtins.attrValues darwin-modules;
      };

      nixpkgs-config = {
        nixpkgs.config.allowUnfreePredicate = _: true;
        nixpkgs.config.allowUnsupportedSystem = true;
        nixpkgs.overlays = builtins.attrValues self.overlays;
      };

      nixpkgs-useFlakeNixpkgs = {
        home.sessionVariables.NIX_PATH = "nixpkgs=${inputs.nixpkgs}";
        nix.registry.nixpkgs.flake = inputs.nixpkgs;
      };
    }
    // modules;
}
