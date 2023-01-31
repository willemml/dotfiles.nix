{ pkgs, lib, ... }:

let
  darwin = with pkgs; [
    colima
    coreutils
    gnused
    iterm2
    karabiner-elements
    pinentry_mac
    pinentry-touchid
    qbittorrent-mac
    spoof-mac
    spotify-mac
    vlc-mac
  ];
  linux = with pkgs; [ vlc qbittorrent ];
  pass-extended = pkgs.pass.withExtensions (exts: [ exts.pass-genphrase exts.pass-otp exts.pass-import ]);
  python-wp = pkgs.python310.withPackages (p: with p; [ setuptools pyaml requests latexify-py ]);
  node-packages = with pkgs.nodePackages; [ bash-language-server ];
in {
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
      discord
      docker
      docker-compose
      fd
      findutils
      fzf
      gawk
      gnuplot
      graphviz
      htop
      jq
      nixfmt
      nix-review
      nmap
      octave
      openssh
      pass-extended
      plantuml
      pngpaste
      poppler
      python-wp
      pv
      ripgrep
      rsync
      rustup
      shellcheck
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
      zoom-us
    ]
    ++ lib.optionals stdenv.isDarwin darwin
    ++ lib.optionals stdenv.isLinux linux
    ++ node-packages;
}
