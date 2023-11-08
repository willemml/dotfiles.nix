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
    modules = self.lib.importDirToAttrs ../../home-manager;
    non-specific-modules = lib.filterAttrs (n: v: (!(lib.hasInfix "darwin" n) && !(lib.hasInfix "linux" n))) modules;
    darwin-modules = lib.filterAttrs (n: v: (lib.hasInfix "darwin" n)) modules;
    linux-modules = lib.filterAttrs (n: v: (lib.hasInfix "linux" n)) modules;
  in
    {
      default = {
        imports = builtins.attrValues non-specific-modules;
      };

      darwin = {
        imports = builtins.attrValues darwin-modules;
      };

      linux = {
        imports = builtins.attrValues linux-modules;
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

      hyprland = {
        imports = [
          inputs.hyprland.homeManagerModules.default
          {wayland.windowManager.hyprland.enable = true;}
        ];
      };
    }
    // modules;
}
