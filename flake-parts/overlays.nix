{
  self,
  inputs,
  lib,
  ...
}: {
  flake.overlays = {
    default = import ../packages;
    emacs-overlay = inputs.emacs-overlay.overlays.default;
    fenix = inputs.fenix.overlays.default;
    rycee-firefox-addons = final: prev: {rycee-firefox-addons = inputs.rycee-firefox-addons.outputs.packages.${prev.system};};
  };
}
