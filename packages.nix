{ config, lib, pkgs, pkgsCustom, ... }:

{
  home.packages = with pkgs;
    [
      coreutils
      gnused
      spoof-mac
      colima
      pinentry_mac
      iterm2
      zoom-us
      karabiner-elements
    ] ++ [ discord pkgsCustom.vlc pkgsCustom.qbittorrent ]
    ++ [ docker docker-compose ] ++ [
      comma
      automake
      autoconf
      cmake
      bash
      rustup
      curl
      pv
      wget
      htop
      bat
      fd
      ripgrep
      jq
      nmap
      unzip
      unp
      unrar
      rsync
      openssh
      tldr
      nix-review
    ];
}
