{ config, pkgs, lib, inputs, nur, ... }:

let
  inherit (pkgs) stdenv;
  inherit (lib) mkIf;
  emacsCommand = "emacsclient -c -nw";
  homeDirectory = config.home.homeDirectory;
in rec {
  home = {
    username = "willem";
    homeDirectory = "/Users/willem";
    stateVersion = "22.11";
  };

  home.file.".config/nix/nix.conf".text = ''
    allow-dirty = true
    experimental-features = flakes nix-command
    builders-use-substitutes = true
  '';

  home.keyboard = {
    layout = "us";
    variant = "colemak";
  };

  home.language = {
    base = "en_CA.UTF-8";
    messages = "en_US.UTF-8";
    ctype = "en_US.UTF-8";
  };

  home.sessionVariables = rec {
    EDITOR = emacsCommand;
    VISUAL = emacsCommand;
    ORGDIR = "${home.homeDirectory}/Documents/org";
    UBCDIR = "${ORGDIR}/ubc";
  };

  imports =
    [ ./emacs.nix ./packages.nix ./programs.nix ./darwin ];

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "discord" "unrar" "zoom" ];
    packageOverrides = pkgs: {
      nur = nur;
    };
  };

  nixpkgs.overlays = [ (import ./overlays) ];
}
