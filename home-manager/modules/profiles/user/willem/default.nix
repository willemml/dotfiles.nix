{ config, pkgs, lib, ... }:

let
  emacsCommand = "emacsclient -c -nw";
in
rec {
  home = {
    file = {
      ".config/nix/nix.conf".text = ''
        allow-dirty = true
        experimental-features = flakes nix-command repl-flake
        builders-use-substitutes = true
      '';
      ".config/nixpkgs/config.nix".text = ''
        # -*-nix-*-
        {
          packageOverrides = pkgs: {
            nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
              inherit pkgs;
            };
          };
          allowUnfree = true;
        }

      '';
    };
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

  imports = [
    ./accounts.nix
    ./darwin
    ./feeds.nix
    ./packages.nix
    ./programs
  ];
}
