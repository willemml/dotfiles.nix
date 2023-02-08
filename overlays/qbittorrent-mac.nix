{ pkgs }:

let
  version = "4.4.5";
  appName = "qBittorrent";
  pname = "qbittorrent";

  src = pkgs.fetchurl {
    url =
      "https://phoenixnap.dl.sourceforge.net/project/qbittorrent/qbittorrent-mac/qbittorrent-${version}/qbittorrent-${version}.dmg";
    sha256 = "sha256-9h+gFAEU0tKrltOjnOKLfylbbBunGZqvPzQogdP9uQM=";
  };
in
import ./mk-mac-binpkg.nix { inherit pkgs src pname appName version; }

