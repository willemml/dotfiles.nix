# Copyright (c) 2018 Terje Larsen
# This work is licensed under the terms of the MIT license.
# For a copy, see https://opensource.org/licenses/MIT.
# https://github.com/terlar/nix-config/blob/00c8a3622e8bc4cb522bbf335e6ede04ca07da40/flake-parts/packages.nix
{
  self,
  lib,
  ...
}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: let
    overlays = [
      self.overlays.default
    ];
    pkgs' = pkgs.extend (lib.composeManyExtensions overlays);
  in {
    packages = {
      inherit
        (pkgs')
        chromium-mac
        darwin-zsh-completions
        firefox-mac
        freecad-mac
        org-auctex
        pinentry-mac
        pinentry-touchid
        qbittorrent-mac
        spotify-mac
        vkquake
        vlc-mac
        ;
    };

    legacyPackages = {
      wrapPackage = {
        wrapper,
        package,
        exes ? [(lib.getExe package)],
      }: let
        wrapperExe = lib.getExe wrapper;
        wrapExe = exe:
          pkgs.writeShellScriptBin (builtins.baseNameOf exe) ''
            exec ${wrapperExe} ${exe} "$@"
          '';
      in
        pkgs.symlinkJoin {
          name = "${package.name}-${wrapper.name}";
          paths = (map wrapExe exes) ++ [package];
        };

      wrapPackages = pkgsWrapperFn: pkgNames: final: prev: let
        wrapper = pkgsWrapperFn final;
      in
        builtins.listToAttrs (map
          (name: {
            inherit name;
            value = config.legacyPackages.wrapPackage {
              inherit wrapper;
              package = prev.${name};
            };
          })
          pkgNames);
    };
  };
}
