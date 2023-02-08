{ pkgs }:

let
  version = "0.20.2";
  date = "2022-12-27";
  appName = "FreeCAD";
  pname = "freecad";

  src = pkgs.fetchurl {
    url =
      "https://github.com/FreeCAD/FreeCAD/releases/download/${version}/FreeCAD_${version}-${date}-conda-macOS-x86_64-py310.dmg";
    sha256 = "sha256-OAi98HUacHcLHVYSadnQFPnEhutJvE4YfRBtPSZk00c=";
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
