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
      (pkgs.callPackage ./spotify-mac.nix { })
    ] ++ [ discord pkgsCustom.vlc ] ++ [ docker docker-compose ] ++ [
      zsh-powerlevel10k
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
    ];
}
