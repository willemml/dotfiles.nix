_final: prev: {
  chromium-mac = prev.callPackage ./chromium-mac.nix {};
  darwin-zsh-completions = prev.callPackage ./darwin-zsh-completions.nix {};
  firefox-mac = prev.callPackage ./firefox-mac.nix {};
  freecad-mac = prev.callPackage ./freecad-mac.nix {};
  mkMacBinPackage = import ./mk-mac-binpkg.nix prev;
  org-auctex = prev.callPackage ./org-auctex.nix {};
  pinentry-mac = prev.callPackage ./pinentry-mac.nix {};
  pinentry-touchid = prev.callPackage ./pinentry-touchid.nix {};
  qbittorrent-mac = prev.callPackage ./qbittorrent-mac.nix {};
  spotify-mac = prev.callPackage ./spotify-mac.nix {};
  vkquake = prev.callPackage ./vkquake {};
  vlc-mac = prev.callPackage ./vlc-mac.nix {};
}
