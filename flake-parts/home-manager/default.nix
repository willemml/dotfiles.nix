# Copyright (c) 2018 Terje Larsen
# This work is licensed under the terms of the MIT license.
# For a copy, see https://opensource.org/licenses/MIT.
# https://github.com/terlar/nix-config/blob/00c8a3622e8bc4cb522bbf335e6ede04ca07da40/flake-parts/home-manager/default.nix
{
  lib,
  flake-parts-lib,
  self,
  ...
}: let
  inherit
    (lib)
    mkOption
    types
    ;
  inherit (flake-parts-lib) mkSubmoduleOptions;
in {
  imports = [./configurations.nix ./modules.nix ./users.nix];

  options = {
    flake = mkSubmoduleOptions {
      homeManagerModules = mkOption {
        type = types.lazyAttrsOf types.unspecified;
        default = {};
        apply = lib.mapAttrs (k: v: {
          _file = "${toString self.outPath}/flake.nix#homeManagerModules.${k}";
          imports = [v];
        });
        description = ''
          Home Manager modules.
        '';
      };
    };
  };
}
