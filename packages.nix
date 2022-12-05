{ config, lib, pkgs, isDarwin, ... }:

let
  comma = (import (pkgs.fetchFromGitHub {
    owner = "nix-community";
    repo = "comma";
    rev = "v1.4.0";
    sha256 = "02zh0zn0yibbgn26r0idcsv8nl7pxlnq545qas0fzj5l70hdgyhh";
  })).default;
  
  darwinPackages = with pkgs; [
    coreutils
    gnused
    spoof-mac
    colima
    pinentry_mac
  ];
  
  dockerPackages = with pkgs; [
    unstable.docker
    docker-compose
  ];
  
  editingPackages = with pkgs; [
    black
    shellcheck
    plantuml
    texlive.combined.scheme-full
  ];
  
  nodePackages = with pkgs.nodePackages; [
    bash-language-server
  ];
  
  sharedPackages = with pkgs; [
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
    tree
    bat
    fd
    ripgrep
    jq
    nmap
    unzip
    yt-dlp
    rsync
    openssh
    tldr
    (import ./python-packages.nix { inherit pkgs; })
  ];
in
sharedPackages
++ (lib.optionals isDarwin darwinPackages)
++ editingPackages
++ nodePackages
++ dockerPackages
