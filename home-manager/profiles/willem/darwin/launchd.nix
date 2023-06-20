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
          "${config.programs.emacs.package}/bin/emacs"
          "--fg-daemon"
        ];
        KeepAlive = true;
        ProcessType = "Interactive";
        StandardOutPath = logFile "emacs";
        StandardErrorPath = logFile "emacs";
      };
    };

    agents.offlineimap = {
      enable = true;
      config = {
        ProgramArguments = ["${pkgs.offlineimap}/bin/offlineimap"];
        UserName = "${config.home.username}";
        StartInterval = 900;
        StandardOutPath = logFile "offlineimap";
        StandardErrorPath = logFile "offlineimap";
      };
    };
  };
}
