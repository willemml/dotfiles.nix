{ pkgs, lib, ... }:

let
  darwin = with pkgs; [
    colima
    coreutils
    freecad-mac
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
      nix-review
      nixfmt
      nixpkgs-fmt
      nmap
      octave-wp
      openssh
      pass-extended
      plantuml
      pngpaste
      poppler
      pv
      python-wp
      ripgrep
      rsync
      rustup
      shellcheck
      spotify-tui
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
    ]
    ++ lib.optionals stdenv.isDarwin darwin
    ++ lib.optionals stdenv.isLinux linux
    ++ node-packages;
}
