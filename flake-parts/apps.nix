# Copyright (c) 2018 Terje Larsen
# This work is licensed under the terms of the MIT license.
# For a copy, see https://opensource.org/licenses/MIT.
# https://github.com/terlar/nix-config/blob/00c8a3622e8bc4cb522bbf335e6ede04ca07da40/flake-parts/apps.nix
{lib, ...}: {
  perSystem = {pkgs, ...}:
    lib.pipe ../apps [
      lib.filesystem.listFilesRecursive
      (map (file: pkgs.callPackage file {}))
      (map (drv: {
        apps.${drv.name} = {
          type = "app";
          program = lib.getExe drv;
        };
        checks."app-${drv.name}" = drv;
      }))
      (lib.fold lib.recursiveUpdate {})
    ];
}
