{
  pkgs,
  lib,
  ...
}: let
  node-packages = with pkgs.nodePackages; [
    bash-language-server
    prettier
  ];
  fenix-rust = pkgs.fenix.combine (with pkgs.fenix; [
    latest.toolchain
    targets.thumbv7em-none-eabihf.latest.rust-std
  ]);
in {
  home.packages = with pkgs;
    [
      alejandra
      bash
      bat
      black
      cachix
      coreutils
      curl
      docker
      docker-compose
      fd
      fenix-rust
      findutils
      gawk
      git-crypt
      jq
      nix-tree
      nix-zsh-completions
      nixfmt
      nixpkgs-fmt
      nmap
      nodejs
      openssh
      pass-git-helper
      pinentry
      pv
      ripgrep
      rnix-lsp
      rsync
      shellcheck
      shfmt
      sqlite
      tealdeer
      unzip
      yq
      vhdl-ls
      zsh-completions
    ]
    ++ node-packages;
}
