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
  };
}
