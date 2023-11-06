# Copyright (c) 2018 Terje Larsen
# This work is licensed under the terms of the MIT license.
# For a copy, see https://opensource.org/licenses/MIT.
# https://github.com/terlar/nix-config/blob/00c8a3622e8bc4cb522bbf335e6ede04ca07da40/flake-parts/lib/default.nix
{
  self,
  inputs,
  ...
}: {
  flake.nixosModules = {
    default = {};

    appleSilicon = {config, ...}: {
      imports = [inputs.nixos-apple-silicon.nixosModules.apple-silicon-support];
      nixpkgs.overlays = [inputs.nixos-apple-silicon.overlays.default];
    };

    nixpkgs-useFlakeNixpkgs = {
      nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
      nix.registry.nixpkgs.flake = inputs.nixpkgs;
    };

    home-manager-integration = {
      config.home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bak";
      };
    };
  };
}
