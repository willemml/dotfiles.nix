# Copyright (c) 2018 Terje Larsen
# This work is licensed under the terms of the MIT license.
# For a copy, see https://opensource.org/licenses/MIT.
# https://github.com/terlar/nix-config/blob/00c8a3622e8bc4cb522bbf335e6ede04ca07da40/flake-parts/lib/default.nix
{
  self,
  inputs,
  ...
}: {
  flake.nixosModules = let
    modules = self.lib.importDirToAttrs ../../nixos/modules;
  in
    {
      default = {
        imports = builtins.attrValues modules;
      };
    }
    // modules;
}
