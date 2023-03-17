{ lib, pinentry_mac, stdenv }: stdenv.mkDerivation {
  name = "pinentry-mac";
  src = pinentry_mac;
  installPhase = ''
    # -*-sh-*-

    mkdir -p "$out/bin"

    cp "$src/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac" "$out/bin/pinentry-mac"
  '';

  meta = with lib; {
    description = "Pinentry for GPG on Mac";
    license = licenses.gpl2Plus;
    homepage = "https://github.com/GPGTools/pinentry-mac";
    platforms = platforms.darwin;
  };
}

