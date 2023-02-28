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
    keyboard = {
      layout = "us";
      variant = "colemak";
    };
    language = {
      base = "en_CA.UTF-8";
      messages = "en_US.UTF-8";
      ctype = "en_US.UTF-8";
    };
    sessionVariables = rec {
      EDITOR = emacsCommand;
      VISUAL = emacsCommand;
      ORGDIR = "~/Documents/org";
      UBCDIR = "${ORGDIR}/ubc";
    };
    stateVersion = "22.11";
    username = "willem";
  };

  imports = [
    ./accounts.nix
    ./darwin.nix
    ./emacs.nix
    ./packages.nix
    ./programs.nix
  ];
}
