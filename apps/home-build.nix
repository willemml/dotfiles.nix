{ writeShellApplication
, home-manager
, stdenv
,
}:
writeShellApplication {
  name = "home-build";
  runtimeInputs = [ home-manager ];
  text = ''
    export FLAKE_CONFIG_URI=".#homeConfigurations.${stdenv.hostPlatform.system}.$USER"
    exec home-manager build "$@"
  '';
}
