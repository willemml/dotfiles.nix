{ pkgs, config, lib, currentSystem, ... }:

let
  inherit (lib.systems.elaborate { system = builtins.currentSystem; }) isLinux isDarwin;
in
{
  home.stateVersion = "22.05";
  home.packages = import ./packages.nix { inherit lib config pkgs isDarwin; };
  imports = [
    ./emacs.nix
    ./git.nix
    ./gpg.nix
    ./zsh.nix
  ];
}  
