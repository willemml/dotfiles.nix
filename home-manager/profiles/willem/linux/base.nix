{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.zsh.shellAliases = {
    nrs = "nixos-rebuild switch --flake ${config.home.homeDirectory}/.config/dotfiles.nix#";
    nbs = "nixos-rebuild build --flake ${config.home.homeDirectory}/.config/dotfiles.nix#";
  };

  home.packages = with pkgs; [
    gcc-arm-embedded
  ];
}
