{ config, lib, pkgs, isDarwin, ... }:

let
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
    #(import ./python-packages.nix { inherit pkgs; })
  ];
in
sharedPackages
++ (lib.optionals isDarwin darwinPackages)
++ editingPackages
++ nodePackages
++ dockerPackages
