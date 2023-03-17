{
  definition = lib: pkgs: pkgs.stdenv.mkDerivation {
    name = "pinentry-mac";
    src = pkgs.pinentry_mac;
    installPhase = ''
      # -*-sh-*-

      mkdir -p "$out/bin"

      cp "$src/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac" "$out/bin/pinentry-mac"
    '';
  };
  
  systems = [ "aarch64-darwin" "x86_64-darwin" ];
}
