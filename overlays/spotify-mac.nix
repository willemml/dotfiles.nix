{ pkgs }:

let
  appName = "Spotify";
  pname = "spotify";
  version = "sha256-JESQZtyPE9o5PW/f5GdxbqbyeHCxs/oZEW0AakMJgKg=";

  src = pkgs.fetchurl {
    url = "https://download.scdn.co/Spotify.dmg";
    hash = version;
    name = "spotify-mac.dmg";
  };
in
import ./mk-mac-binpkg.nix { inherit pkgs src pname appName version; }

