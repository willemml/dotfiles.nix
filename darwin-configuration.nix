{ config, pkgs, lib, ... }:

let
  user = builtins.getEnv "USER";
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
  cask2nixTarball = fetchTarball https://github.com/matthewbauer/cask2nix/archive/v0.1.tar.gz;
  nurTarball = fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz";
in
{
  imports = [ <home-manager/nix-darwin> ];

  # List of packages to be installed in the system profile.
  environment.systemPackages = [
    pkgs.iterm2
    pkgs.discord
  ];

  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin-configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
      nur = import nurTarball { inherit pkgs; };
    };
  };
  
  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  programs.gnupg.agent.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  users.users.${user} = {
    home = "/Users/${user}";
    name = "${user}";
  };

  services.emacs.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.users.${user} = import ./home.nix { inherit lib config pkgs; };
}
