{
  inputs,
  globals,
  config,
  pkgs,
  ...
}: let
  emacsCommand = "emacsclient -c -nw";
in rec {
  imports = [
    ./modules/emacs.nix
    ./modules/hishtory.nix
    ./packages.nix
    ./programs/default.nix
  ];

  home = {
    username = globals.username;

    stateVersion = "23.05";

    keyboard = {
      layout = globals.keyboard.layout;
      variant = globals.keyboard.variant;
    };

    language = {
      base = globals.language;
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

  home.file.".gnupg/gpg-agent.conf" = {
    text = ''
      pinentry-program "${pkgs.pinentry.out}/bin/pinentry"
      default-cache-ttl 30
      max-cache-ttl 600
    '';
  };

  home.file.".config/nixpkgs/config.nix".text = ''
    # -*-nix-*-
    {
      nixpkgs.config.allowUnfreePredicate = (_: true);
      allowUnfree = true;
    }
  '';
}
