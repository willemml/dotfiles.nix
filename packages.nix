{ config, lib, pkgs, pkgsCustom, ... }:

{
  home.packages = with pkgs;
    [
      colima
      coreutils
      gnused
      iterm2
      karabiner-elements
      pinentry_mac
      spoof-mac
      zoom-us
      (pkgs.callPackage ./spotify-mac.nix { inherit config lib pkgs; })
    ] ++ [ discord pkgsCustom.vlc pkgsCustom.qbittorrent ]
    ++ [ docker docker-compose ] ++ [
      autoconf
      automake
      bash
      bat
      cmake
      comma
      curl
      fd
      gawk
      htop
      jq
      nix-review
      nmap
      openssh
      pv
      ripgrep
      rsync
      rustup
      tldr
      unp
      unrar
      unzip
      wget
      yq
    ];
}
