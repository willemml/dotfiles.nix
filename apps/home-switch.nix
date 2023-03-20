{
  writeShellApplication,
  home-manager,
  stdenv,
}:
writeShellApplication {
  name = "home-switch";
  runtimeInputs = [home-manager];
  text = ''
    export FLAKE_CONFIG_URI=".#homeConfigurations.${stdenv.hostPlatform.system}.$USER"
    exec home-manager switch "$@"
  '';
}
