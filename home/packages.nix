{
  pkgs,
  lib,
  inputs,
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
  nixd-upstream = inputs.nixd.packages.${pkgs.system}.default;
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
      dotnet-sdk_8
      fd
      fenix-rust
      findutils
      gawk
      git-crypt
      jq
      nix-tree
      nix-zsh-completions
      nixfmt
      nixd-upstream
      nixpkgs-fmt
      nmap
      nodejs
      openssh
      pass-git-helper
      pv
      ripgrep
      rsync
      shellcheck
      shfmt
      sqlite
      tealdeer
      unzip
      vhdl-ls
      yq
      vhdl-ls
      vscode-langservers-extracted
      zsh-completions
    ]
    ++ node-packages;
}
