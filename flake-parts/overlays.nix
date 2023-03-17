{ self, inputs, lib, ... }:

{
  flake.overlays = {
    default = final: prev: (
      let
        appsDir = self.lib.importDirToAttrs ../apps;
        builtApps = lib.mapAttrs (name: value: value.definition self.lib prev) appsDir;
        packages = import ../packages final prev;
      in
      builtApps // packages
    );
  };
}
