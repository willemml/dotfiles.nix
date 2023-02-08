{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name = "pinentry-mac";
  src = pkgs.pinentry_mac;
  installPhase = ''
# -*-sh-*-

mkdir -p "$out/bin"

cp "$src/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac" "$out/bin/pinentry-mac"
'';
}
