{
  config,
  pkgs,
  lib,
  ...
}: {
  home.file.".gnupg/gpg-agent.conf" = {
    text = ''
      default-cache-ttl 30
      max-cache-ttl 600
    '';
  };

  programs.zsh.shellAliases = {
    nrs = "nixos-rebuild switch --flake ${config.home.homeDirectory}/.config/dotfiles.nix#";
    nbs = "nixos-rebuild build --flake ${config.home.homeDirectory}/.config/dotfiles.nix#";
  };

  home.packages = with pkgs; [
    gcc-arm-embedded
  ];
}
