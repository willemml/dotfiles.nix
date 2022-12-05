{ pkgs, config, lib, ... }:

let
  inherit (lib.systems.elaborate { system = builtins.currentSystem; }) isLinux isDarwin;
in
rec {
  home.stateVersion = "22.05";
  
  home.packages = import ./packages.nix { inherit lib config pkgs isDarwin; };
  
  programs = import ./programs.nix { inherit lib config pkgs isDarwin; };
  
  home.file."${programs.gpg.homedir}/gpg-agent.conf" = {
    source = pkgs.writeTextFile {
      name = "gpg-agent-conf";
      text = ''
        pinentry-program ${pkgs.pinentry_mac.out}/${pkgs.pinentry_mac.binaryPath}
      '';
    };
  };
}  
