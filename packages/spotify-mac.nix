{ fetchurl, lib, mkMacBinPackage }:
let
  appName = "Spotify";
  pname = "spotify";
  version = "sha256-JESQZtyPE9o5PW/f5GdxbqbyeHCxs/oZEW0AakMJgKg=";

  src = fetchurl {
    url = "https://download.scdn.co/Spotify.dmg";
    hash = version;
    name = "spotify-mac.dmg";
  };
in
mkMacBinPackage {
  inherit src pname appName version;
  meta = with lib; {
    homepage = "https://www.spotify.com/";
    description = "Play music from the Spotify music service";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = platforms.darwin;
  };
}

