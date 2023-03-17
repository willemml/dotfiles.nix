{ self, inputs, lib, ... }:

{
  flake.overlays = {
    apps = final: prev: (
      let
        appsDir = self.lib.importDirToAttrs ../apps;
      in
      lib.mapAttrs (name: value: value.definition self.lib prev) appsDir
    );
    default = import ../packages;
  };
}
