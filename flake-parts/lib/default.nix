# Copyright (c) 2018 Terje Larsen

# This work is licensed under the terms of the MIT license.  
# For a copy, see https://opensource.org/licenses/MIT.

# https://github.com/terlar/nix-config/blob/00c8a3622e8bc4cb522bbf335e6ede04ca07da40/flake-parts/lib/default.nix

{ self
, lib
, ...
}: {
  flake.lib = {
    kebabCaseToCamelCase =
      builtins.replaceStrings (map (s: "-${s}") lib.lowerChars) lib.upperChars;

    importDirToAttrs = dir:
      lib.pipe dir [
        lib.filesystem.listFilesRecursive
        (builtins.filter (lib.hasSuffix ".nix"))
        (map (path: {
          name = lib.pipe path [
            toString
            (lib.removePrefix "${toString dir}/")
            (lib.removeSuffix "/default.nix")
            (lib.removeSuffix ".nix")
            self.lib.kebabCaseToCamelCase
            (builtins.replaceStrings [ "/" ] [ "-" ])
          ];
          value = import path;
        }))
        builtins.listToAttrs
      ];
    
    mk-mac-binpkg = { src, version, pname, appName, pkgs, srcsubdir ? ".", ... }: pkgs.stdenv.mkDerivation {
      inherit version src;

      name = pname;

      nativeBuildInputs = [ pkgs.undmg pkgs.unzip pkgs.makeWrapper ];

      sourceRoot = ".";

      installPhase = ''
        runHook preInstall

        mkdir -p $out/Applications

        cp -r "${srcsubdir}/${appName}.app" $out/Applications

        # wrap executable to $out/bin
        mkdir -p $out/bin
        makeWrapper "$out/Applications/${appName}.app/Contents/MacOS/${appName}" "$out/bin/${pname}"

        runHook postInstall
      '';
    };
  };
}