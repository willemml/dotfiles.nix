{
  self,
  inputs,
  lib,
  ...
}: {
  flake.overlays = {
    apps = final: prev: (
      let
        appsDir = self.lib.importDirToAttrs ../apps;
      in
        lib.mapAttrs (name: value: value.definition self.lib prev) appsDir
    );
    default = import ../packages;
    rycee-firefox-addons = final: prev: {rycee-firefox-addons = inputs.rycee-firefox-addons.outputs.packages.${prev.system};};
  };
}
