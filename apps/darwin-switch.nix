# Copyright (c) 2018 Terje Larsen
# This work is licensed under the terms of the MIT license.
# For a copy, see https://opensource.org/licenses/MIT.
# https://github.com/terlar/nix-config/blob/00c8a3622e8bc4cb522bbf335e6ede04ca07da40/apps/nixos-switch.nix
{
  writeShellApplication,
  gitMinimal,
  nixVersions,
  nixos-rebuild,
}:
writeShellApplication {
  name = "darwin-switch";
  runtimeInputs = [gitMinimal nixVersions.stable nixos-rebuild];
  text = ''
    exec darwin-rebuild switch --flake . "$@"
  '';
}
