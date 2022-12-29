{ config, pkgs, lib, ... }:

let
  inherit (lib.systems.elaborate { system = builtins.currentSystem; }) isLinux isDarwin;
  homeDirectory = config.home.homeDirectory;
in {
  nixpkgs.config = {
    allowUnfree = true;
  };

  programs = import ./programs.nix {inherit lib config pkgs isDarwin homeDirectory; };

  home.packages = import ./packages.nix { inherit lib config pkgs isDarwin; };

  home.language = {
    base = "en_CA.UTF-8";
    messages = "en_US.UTF-8";
    ctype = "en_US.UTF-8";
  };

  home.keyboard = {
    layout = "us";
    variant = "colemak";
  };

  home.sessionVariables = {
    EDITOR = "emacs";
  };
}
