{
  lib,
  config,
  pkgs,
  ...
}: let
  logFile = name: "${config.home.homeDirectory}/Library/Logs/${name}.log";
in {
  launchd = {
    enable = true;

    agents.emacs = {
      enable = true;
      config = {
        EnvironmentVariables = {
          TERM = "xterm-kitty";
          TERMINFO = "${config.programs.kitty.package}/Applications/kitty.app/Contents/Resources/kitty/terminfo";
          TERMINFO_DIRS = "${config.home.homeDirectory}/.nix-profile/share/terminfo:/run/current-system/sw/share/terminfo:/nix/var/nix/profiles/default/share/terminfo:/usr/share/terminfo";
        };
        ProgramArguments = [
          "${config.programs.emacs.finalPackage}/bin/emacs"
          "--fg-daemon"
        ];
        KeepAlive = true;
        ProcessType = "Interactive";
        StandardOutPath = logFile "emacs";
        StandardErrorPath = logFile "emacs";
      };
    };
  };
}
