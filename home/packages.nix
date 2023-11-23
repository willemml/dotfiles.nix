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
      cachix
      clang-tools
      cmake
      coreutils
      curl
      docker
      docker-compose
      fd
      fenix-rust
      findutils
      gawk
      git-crypt
      gnuplot
      graphviz
      htop
      jq
      mu
      nix-tree
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
      pv
      python-wp
      ripgrep
      rnix-lsp
      rsync
      shellcheck
      shfmt
      sqlite
      stylua
      texinfo
      tealdeer
      units
      unrar
      unzip
      wget
      yq
      zsh-completions
    ]
    ++ node-packages;
}
