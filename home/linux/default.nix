{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../default.nix
    ./services.nix
    ./hyprland.nix
  ];

  programs.zsh.shellAliases = {
    nrs = "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/.config/dotfiles.nix#";
    nbs = "nixos-rebuild build --flake ${config.home.homeDirectory}/.config/dotfiles.nix#";
  };

  home.packages = with pkgs; [
    gcc-arm-embedded
    killall
  ];

  home.homeDirectory = "/home/willem";
}
