{ config, lib, pkgs, isDarwin, ... }:

let
  comma = (import (pkgs.fetchFromGitHub {
    owner = "nix-community";
    repo = "comma";
    rev = "v1.4.0";
    sha256 = "02zh0zn0yibbgn26r0idcsv8nl7pxlnq545qas0fzj5l70hdgyhh";
  })).default;

  rnix-lsp = (import (pkgs.fetchFromGitHub {
    owner = "nix-community";
    repo = "rnix-lsp";
    rev = "95d40673fe43642e2e1144341e86d0036abd95d9";
    sha256 = "197s5qi0yqxl84axziq3pcpf5qa9za82siv3ap6v3rcjmndk8jqp";
  }));
  
  darwinPackages = with pkgs; [
    coreutils
    gnused
    spoof-mac
    colima
    pinentry_mac
    iterm2
  ];

  guiPackages = with pkgs; [
    discord
  ];
  
  dockerPackages = with pkgs; [
    unstable.docker
    docker-compose
  ];
  
  editingPackages = with pkgs; [
    black
    shellcheck
    plantuml
    rnix-lsp
    clang-tools
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
    bat
    fd
    ripgrep
    jq
    nmap
    unzip
    rsync
    openssh
    tldr
    (import ./python-packages.nix { inherit pkgs; })
  ];
in
sharedPackages
++ (lib.optionals isDarwin darwinPackages)
++ guiPackages
++ editingPackages
++ nodePackages
++ dockerPackages
