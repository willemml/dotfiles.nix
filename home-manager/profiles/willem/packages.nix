{
  pkgs,
  lib,
  ...
}: let
  linux = with pkgs; [gcc-arm-embedded];
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
  texliveset = pkgs.texlive.combine {
    inherit
      (pkgs.texlive)
      scheme-basic
      babel
      amscls
      amsmath
      biber
      biblatex
      biblatex-mla
      block
      cancel
      caption
      capt-of
      csquotes
      enotez
      enumitem
      etex
      etoolbox
      fancyhdr
      float
      fontaxes
      graphics
      hanging
      hyperref
      latex
      latexindent
      latexmk
      logreq
      metafont
      mlacls
      newtx
      pdflscape
      pdfpages
      preprint
      psnfss
      ragged2e
      titlesec
      tools
      translations
      ulem
      url
      wrapfig
      xstring
      xkeyval
      ;
  };
  fenix-rust = pkgs.fenix.combine (with pkgs.fenix; [
    latest.toolchain
    targets.thumbv7em-none-eabihf.latest.rust-std
  ]);
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
      fd
      fenix-rust
      findutils
      gawk
      gnuplot
      graphviz
      htop
      iaito
      jq
      mu
      # nix-review
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
    ++ lib.optionals stdenv.isLinux linux
    ++ node-packages;
}
