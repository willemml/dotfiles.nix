{ config, pkgs, lib, ... }:

let
  inherit (lib.systems.elaborate { system = builtins.currentSystem; }) isLinux isDarwin;
  homeDirectory = config.home.homeDirectory;
in {
  imports = [
    ./emacs.nix
    ./packages.nix
    ./programs.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

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
