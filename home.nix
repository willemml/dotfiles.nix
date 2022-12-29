{ pkgs, config, lib, ... }:

let
  inherit (lib.systems.elaborate { system = builtins.currentSystem; }) isLinux isDarwin;
  user = builtins.getEnv "USER";
  homeDir = builtins.getEnv "HOME";
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
  nurTarball = fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz";
in
rec {
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
      nur = import nurTarball {
        inherit pkgs;
        config = config.nixpkgs.config;
      };
    };
  };
  
  home = {
    username = user;
    homeDirectory = homeDir;
    stateVersion = "22.11";
    packages = import ./packages.nix { inherit lib config pkgs isDarwin; };
  };
  
  programs = import ./programs.nix { inherit lib config pkgs isDarwin homeDir; };
  
  home.file."${programs.gpg.homedir}/gpg-agent.conf" = {
    source = pkgs.writeTextFile {
      name = "gpg-agent-conf";
      text = ''
        pinentry-program pinentry-mac
      '';
    };
  };
}  
