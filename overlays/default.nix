self: super: {
  pinentry-touchid = super.callPackage ./pinentry-touchid.nix { pkgs = super; };
  qbittorrent-mac = super.callPackage ./qbittorrent-mac.nix { pkgs = super; };
  spotify-mac = super.callPackage ./spotify-mac.nix { pkgs = super; };
  vlc-mac = super.callPackage ./vlc-mac.nix { pkgs = super; };
}
