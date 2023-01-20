{ config, pkgs, lib, inputs, ... }:

let
  emacsCommand = "emacsclient -c -nw";
  homeDirectory = config.home.homeDirectory;
in {
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

  home.file.".gnupg/gpg-agent.conf".text = ''
    pinentry-program "${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac"
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

  home.sessionVariables = {
    EDITOR = emacsCommand;
    VISUAL = emacsCommand;
  };

  imports =
    [ ./emacs.nix ./launchd.nix ./packages.nix ./programs.nix ./apps.nix ];

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "discord" "unrar" "zoom" ];
  };

}
