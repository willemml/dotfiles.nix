{
  definition = lib: pkgs: pkgs.stdenv.mkDerivation {
    name = "pinentry-mac";
    src = pkgs.pinentry_mac;
    installPhase = ''
      # -*-sh-*-

      mkdir -p "$out/bin"

      cp "$src/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac" "$out/bin/pinentry-mac"
    '';
    
    meta = {
      description = "Pinentry for GPG on Mac";
      license = pkgs.lib.licenses.gpl2Plus;
      homepage = "https://github.com/GPGTools/pinentry-mac";
      platforms = pkgs.lib.platforms.darwin;
    };
  };

  systems = [ "aarch64-darwin" "x86_64-darwin" ];
}
