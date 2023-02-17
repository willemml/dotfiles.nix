self: super: {
  chromium-mac = super.callPackage ./chromium-mac.nix { pkgs = super; };
  darwin-zsh-completions = import ./darwin-zsh-completions.nix { pkgs = super; };
  firefox-mac = super.callPackage ./firefox-mac.nix { pkgs = super; };
  freecad-mac = super.callPackage ./freecad-mac.nix { pkgs = super; };
  pinentry-mac = super.callPackage ./pinentry-mac.nix { pkgs = super; };
  pinentry-touchid = super.callPackage ./pinentry-touchid.nix { pkgs = super; };
  qbittorrent-mac = super.callPackage ./qbittorrent-mac.nix { pkgs = super; };
  spotify-mac = super.callPackage ./spotify-mac.nix { pkgs = super; };
  vlc-mac = super.callPackage ./vlc-mac.nix { pkgs = super; };
}
