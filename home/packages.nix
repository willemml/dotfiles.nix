{ pkgs, lib, ... }:

let
  darwin = with pkgs; [
    pngpaste
    pinentry-touchid
    pinentry-mac
    spoof-mac
  ];
  linux = with pkgs; [ ];
  pass-extended = pkgs.pass.withExtensions (exts: [ exts.pass-genphrase exts.pass-otp exts.pass-import ]);
  python-wp = pkgs.python310.withPackages (p: with p; [ setuptools pyaml requests latexify-py ]);
  node-packages = with pkgs.nodePackages; [ bash-language-server ];
  octave-wp = pkgs.octave.withPackages (p: with p; [ symbolic ]);
in
{
  home.packages = with pkgs;
    [
      autoconf
      automake
      bash
      bat
      black
      clang-tools
      cmake
      comma
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
      octave-wp
      openssh
      pass-extended
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
      texlive.combined.scheme-full
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
