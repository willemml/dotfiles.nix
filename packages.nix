{ config, lib, pkgs, ... }:

let
  comma = (import (pkgs.fetchFromGitHub {
    owner = "nix-community";
    repo = "comma";
    rev = "v1.4.0";
    sha256 = "02zh0zn0yibbgn26r0idcsv8nl7pxlnq545qas0fzj5l70hdgyhh";
  }));
in {
  home.packages = with pkgs;
    [ coreutils gnused spoof-mac colima pinentry_mac iterm2 ] ++ [ discord ]
    ++ [ docker docker-compose ] ++ [
      black
      shellcheck
      clang-tools
      texlive.combined.scheme-full
    ] ++ [ nodePackages.bash-language-server ] ++ [
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
