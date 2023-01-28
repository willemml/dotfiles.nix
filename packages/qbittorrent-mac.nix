{ stdenv, pkgs, fetchurl, ... }:

let
  version = "4.4.5";
  appName = "qBittorrent";
  pname = "qbittorrent";
in stdenv.mkDerivation {
  inherit pname;
  name = pname;

  src = fetchurl {
    url =
      "https://phoenixnap.dl.sourceforge.net/project/qbittorrent/qbittorrent-mac/qbittorrent-${version}/qbittorrent-${version}.dmg";
    sha256 = "sha256-9h+gFAEU0tKrltOjnOKLfylbbBunGZqvPzQogdP9uQM=";
  };

  nativeBuildInputs = [ pkgs.undmg pkgs.makeWrapper ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r "${appName}.app" $out/Applications

    # wrap executable to $out/bin
    mkdir -p $out/bin
    makeWrapper "$out/Applications/${appName}.app/Contents/MacOS/${pname}" "$out/bin/${pname}"

    runHook postInstall
  '';
}
