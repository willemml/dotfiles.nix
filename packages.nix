{ pkgs, lib, ... }:

let
  darwin = with pkgs; [
    colima
    coreutils
    gnused
    iterm2
    karabiner-elements
    pinentry_mac
    spoof-mac
    (pkgs.callPackage ./packages/qbittorrent-mac.nix { inherit pkgs; })
    (pkgs.callPackage ./packages/spotify-mac.nix { inherit pkgs; })
    (pkgs.callPackage ./packages/vlc-mac.nix { inherit pkgs; })
  ];
  linux = with pkgs; [ vlc qbittorrent ];
in {
  home.packages = with pkgs;
    [
      autoconf
      automake
      bash
      bat
      cmake
      comma
      curl
      discord
      docker
      docker-compose
      fd
      gawk
      htop
      jq
      nix-review
      nmap
      openssh
      pass
      pv
      ripgrep
      rsync
      rustup
      tldr
      units
      unp
      unrar
      unzip
      wget
      yq
      zoom-us
    ] ++ lib.optionals stdenv.isLinux linux
    ++ lib.optionals stdenv.isDarwin darwin;
}
