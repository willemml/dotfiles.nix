{ pkgs, fetchurl, ... }:

let
  version = "31483";
  date = "2022-12-31";
  appName = "FreeCAD";
  pname = "freecad";

  src = fetchurl {
    url =
      "https://github.com/FreeCAD/FreeCAD-Bundle/releases/download/weekly-builds/FreeCAD_weekly-builds-${version}-${date}-conda-macOS-arm-py311.dmg";
    sha256 = "sha256-dm6QbAazx1vFrkakkCsfCqyGzRED9guI7yFMQ24mU9o=";
  };
in
pkgs.stdenv.mkDerivation {
  inherit version src;

  name = pname;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    export tempdir=$(mktemp -d -p /tmp)

    cp $src freecad.dmg
    /usr/bin/hdiutil attach -mountpoint "$tempdir" freecad.dmg

    mkdir -p $out/Applications

    cp -r "$tempdir/${appName}.app" $out/Applications

    /usr/bin/hdiutil detach "$tempdir"

    mkdir -p $out/bin
    makeWrapper "$out/Applications/${appName}.app/Contents/MacOS/${appName}" "$out/bin/${pname}"

    runHook postInstall
  '';
}
