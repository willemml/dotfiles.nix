{
  writeShellApplication,
  cachix,
  stdenv,
}:
writeShellApplication {
  name = "cachix";
  runtimeInputs = [cachix];
  text = ''
    exec cachix -d ./cachix -m nixos "$@"
  '';
}
