{
  config,
  pkgs,
  lib,
  ...
}: let
  emacsCommand = "emacsclient -c -nw";
in rec {
  home = {
    stateVersion = "23.05";
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
  };

  home.file.".config/nixpkgs/config.nix".text = ''
    # -*-nix-*-
    {
      nixpkgs.config.allowUnfreePredicate = (_: true);
      allowUnfree = true;
    }
  '';
}
