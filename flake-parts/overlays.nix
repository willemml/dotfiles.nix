{
  self,
  inputs,
  lib,
  ...
}: {
  flake.overlays = {
    default = import ../packages;
    rycee-firefox-addons = final: prev: {rycee-firefox-addons = inputs.rycee-firefox-addons.outputs.packages.${prev.system};};
  };
}
