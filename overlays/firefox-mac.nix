{ pkgs, fetchurl, ... }:

let
  version = "109.0.1";
  pname = "firefox";
  appName = "Firefox";
  src = fetchurl {
    url = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/mac/en-CA/Firefox%20${version}.dmg";
    sha256 = "sha256-V/8W3qqYhJmte2tq/ZSPtYChdhv8WFQoSORYRaxva9Y=";
    name = "${pname}_${version}.dmg";
  };
in import ./mk-mac-binpkg.nix { inherit pkgs src pname appName version; }
