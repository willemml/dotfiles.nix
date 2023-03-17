{
  definition = lib: pkgs:
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
    lib.mk-mac-binpkg {
      inherit pkgs src pname appName version;
      meta = with pkgs.lib; {
        description = "Featureful free software BitTorrent client";
        homepage = "https://www.qbittorrent.org/";
        changelog = "https://github.com/qbittorrent/qBittorrent/blob/release-${version}/Changelog";
        license = licenses.gpl2Plus;
        platforms = platforms.darwin;
      };
    };

  systems = [ "aarch64-darwin" "x86_64-darwin" ];
}
