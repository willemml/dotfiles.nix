{
  self,
  overlays,
  ...
}: {
  nixpkgs.config.allowUnfreePredicate = _: true;
  nixpkgs.config.allowUnsupportedSystem = true;
  nixpkgs.overlays = builtins.attrValues overlays;
}
