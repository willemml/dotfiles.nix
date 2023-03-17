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
    lib.mk-mac-binpkg { inherit pkgs src pname appName version; };

  systems = [ "aarch64-darwin" "x86_64-darwin" ];
}
