{
  pkgs,
  lib,
  ...
}: let
  python-wp = pkgs.python310.withPackages (p:
    with p; [
      keyring
      latexify-py
      pyaml
      requests
      setuptools
    ]);
  node-packages = with pkgs.nodePackages; [
    bash-language-server
    prettier
    yarn
  ];
  octave-wp = pkgs.octave.withPackages (p: with p; [symbolic]);
  fenix-rust = pkgs.fenix.combine (with pkgs.fenix; [
    latest.toolchain
    targets.thumbv7em-none-eabihf.latest.rust-std
  ]);
  lua_p = pkgs.lua5_4.withPackages (p: with p; [luacheck]);
in {
  home.packages = with pkgs;
    [
      alejandra
      autoconf
      automake
      bash
      bat
      black
      clang-tools
      cmake
      comma
      coreutils-full
      curl
      docker
      docker-compose
      elan
      fd
      fenix-rust
      findutils
      gawk
      gnuplot
      graphviz
      htop
      iaito
      jq
      lua_p
      lua-language-server
      mu
      nix-zsh-completions
      nixfmt
      nixpkgs-fmt
      nmap
      nodejs
      octave-wp
      openssh
      pass-git-helper
      pinentry
      plantuml
      poppler
      pv
      python-wp
      radare2
      ripgrep
      rnix-lsp
      rsync
      shellcheck
      shfmt
      spotify-tui
      spotifyd
      sqlite
      stylua
      texinfo
      texliveset
      tldr
      units
      unp
      unrar
      unzip
      wget
      yq
      zsh-completions
    ]
    ++ node-packages;
}
