{
  inputs,
  globals,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./packages.nix
    ./programs/default.nix
    ./modules/nix/pkgs-config.nix
    ./modules/nix/use-flake-pkgs.nix
    inputs.nix-index-database.hmModules.nix-index
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
      EDITOR = "hx";
      VISUAL = "hx";
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
