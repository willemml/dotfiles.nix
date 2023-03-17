{ config, pkgs, lib, ... }:

let
  emacsCommand = "emacsclient -c -nw";
in
rec {
  home = {
    homeDirectory = "/Users/willem";
    keyboard = {
      layout = "us";
      variant = "colemak";
    };
    language = {
      base = "en_CA.UTF-8";
    };
    sessionVariables = rec {
      DOTDIR = "${config.home.homeDirectory}/.config/dotfiles.nix";
      EDITOR = emacsCommand;
      VISUAL = emacsCommand;
      ORGDIR = "${config.home.homeDirectory}/Documents/org";
      UBCDIR = "${ORGDIR}/ubc";
      MAILDIR = "${config.home.homeDirectory}/Maildir";
    };
    stateVersion = "22.11";
    username = "willem";
  };
}
