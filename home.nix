{ config, pkgs, lib, inputs, ... }:

let
  inherit (pkgs) stdenv;
  inherit (lib) mkIf;
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

  home.file.".gnupg/gpg-agent.conf".text = mkIf stdenv.isDarwin ''
    pinentry-program "${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac"
  '';

  home.file.".config/zsh/am.sh" = mkIf stdenv.isDarwin {
    executable = true;
    source = let rev = "27353ec55abac8b5d73b8a061fb87f305c663adb";
    in builtins.fetchurl {
      url =
        "https://raw.githubusercontent.com/mcthomas/Apple-Music-CLI-Player/${rev}/src/am.sh";
      sha256 = "sha256-78zRpNg7/OR7p8dpsJt6Xc4j0Y+8zSUtm/PT94nf03M=";
    };
  };

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
