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
