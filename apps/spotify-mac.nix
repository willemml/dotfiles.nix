{
  definition = lib: pkgs:
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
    lib.mk-mac-binpkg {
      inherit pkgs src pname appName version;
      meta = with pkgs.lib; {
        homepage = "https://www.spotify.com/";
        description = "Play music from the Spotify music service";
        sourceProvenance = with sourceTypes; [ binaryNativeCode ];
        license = licenses.unfree;
        platforms = platforms.darwin;
      };
    };

  systems = [ "aarch64-darwin" "x86_64-darwin" ];
}
