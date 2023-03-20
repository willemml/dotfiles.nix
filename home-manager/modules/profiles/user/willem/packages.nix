{
  pkgs,
  lib,
  ...
}: let
  darwin = with pkgs; [
    pngpaste
    pinentry-touchid
    pinentry-mac
    spoof-mac
  ];
  linux = with pkgs; [];
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
in {
  home.packages = with pkgs;
    [
      autoconf
      automake
      bash
      bat
      black
      cachix
      clang-tools
      cmake
      comma
      coreutils-full
      curl
      docker
      docker-compose
      fd
      findutils
      gawk
      gnuplot
      graphviz
      htop
      jq
      nix-review
      nix-zsh-completions
      nixfmt
      nixpkgs-fmt
      nmap
      nodejs
      octave-wp
      openssh
      plantuml
      poppler
      pv
      python-wp
      ripgrep
      rnix-lsp
      rsync
      rustup
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
    ++ lib.optionals stdenv.isDarwin darwin
    ++ lib.optionals stdenv.isLinux linux
    ++ node-packages;
}
