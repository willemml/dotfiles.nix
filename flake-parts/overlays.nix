{
  self,
  inputs,
  lib,
  ...
}: {
  flake.overlays = {
    default = import ../packages;
    emacs29 = final: prev: {
      emacs29 = prev.emacsGit.overrideAttrs (old: {
        name = "emacs29";
        version = "29.0-${inputs.emacs-src.shortRev}";
        src = inputs.emacs-src;
      });
    };
    emacs-overlay = inputs.emacs-overlay.overlays.default;
    fenix = inputs.fenix.overlays.default;
    rycee-firefox-addons = final: prev: {rycee-firefox-addons = inputs.rycee-firefox-addons.outputs.packages.${prev.system};};
  };
}
