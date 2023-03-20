{
  fetchurl,
  lib,
  mkMacBinPackage,
}: let
  version = "4.4.5";
  appName = "qBittorrent";
  pname = "qbittorrent";

  src = fetchurl {
    url = "https://phoenixnap.dl.sourceforge.net/project/qbittorrent/qbittorrent-mac/qbittorrent-${version}/qbittorrent-${version}.dmg";
    sha256 = "sha256-9h+gFAEU0tKrltOjnOKLfylbbBunGZqvPzQogdP9uQM=";
  };
in
  mkMacBinPackage {
    inherit src pname appName version;
    meta = with lib; {
      description = "Featureful free software BitTorrent client";
      homepage = "https://www.qbittorrent.org/";
      changelog = "https://github.com/qbittorrent/qBittorrent/blob/release-${version}/Changelog";
      license = licenses.gpl2Plus;
      platforms = platforms.darwin;
    };
  }
