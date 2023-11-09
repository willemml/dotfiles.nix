{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../default.nix
    ./services.nix
    ./hyprland.nix
    ../modules/nix/pkgs-config.nix
    ../modules/nix/use-flake-pkgs.nix
  ];

  programs.zsh.shellAliases = {
    nrs = "nixos-rebuild switch --flake ${config.home.homeDirectory}/.config/dotfiles.nix#";
    nbs = "nixos-rebuild build --flake ${config.home.homeDirectory}/.config/dotfiles.nix#";
  };

  home.packages = with pkgs; [
    gcc-arm-embedded
  ];

  home.homeDirectory = "/home/willem";

  programs.emacs.enableOrgTex = false;
}
