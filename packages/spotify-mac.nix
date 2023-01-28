{ stdenv, pkgs, ... }:

stdenv.mkDerivation {
  name = "spotify-mac-app";

  sourceRoot = ".";

  nativeBuildInputs = [ pkgs.undmg pkgs.makeWrapper pkgs.perl pkgs.unzip pkgs.zip ];
  
  src = pkgs.fetchurl {
    url = "https://download.scdn.co/Spotify.dmg";
    hash = "sha256-9Ts6064YaZdjbRN28qkZcrwTH+63drC/jUfTGLvpBNc=";
  };

  spotxsrc = pkgs.fetchFromGitHub {
    name = "spotx-mac-src";
    owner = "willemml";
    repo = "SpotX-Mac";
    rev = "03ea3aa59e135b9e2f68b6c8f4d4debe2b207830";
    hash = "sha256-H3QxmM0ALtz58MKaQ6pFcK6wP8oMWufvQ2q2ZjpO5Gs=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r "Spotify.app" $out/Applications

    # wrap executable to $out/bin
    mkdir -p $out/bin
    makeWrapper "$out/Applications/Spotify.app/Contents/MacOS/Spotify" "$out/bin/Spotify"

    cp "$spotxsrc/install.sh" install.sh

    chmod +x install.sh

    ./install.sh -a "$out/Applications/Spotify.app"

    runHook postInstall
  '';
}

