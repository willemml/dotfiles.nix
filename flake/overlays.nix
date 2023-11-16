{
  self,
  inputs,
  lib,
  ...
}: {
  flake.overlays = {
    default = import ../packages;
    fenix = inputs.fenix.overlays.default;
  };
}
