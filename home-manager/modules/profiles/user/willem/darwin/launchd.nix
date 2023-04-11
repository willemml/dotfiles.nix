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

    agents.firefox = {
      enable = true;
      config = {
        ProgramArguments = ["${config.programs.firefox.package}/bin/firefox"];
        KeepAlive = true;
        ProcessType = "Interactive";
        StandardOutPath = logFile "firefox";
        StandardErrorPath = logFile "firefox";
      };
    };

    agents.iterm2 = {
      enable = true;
      config = {
        ProgramArguments = ["${pkgs.iterm2}/Applications/iTerm2.app/Contents/MacOS/iTerm2"];
        KeepAlive = true;
        ProcessType = "Interactive";
        StandardOutPath = logFile "iterm2";
        StandardErrorPath = logFile "iterm2";
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

    agents.rss2email = {
      enable = true;
      config = {
        ProgramArguments = [
          "${pkgs.rss2email}/bin/r2e"
          "run"
        ];
        StartInterval = 3600;
        StandardOutPath = logFile "rss2email";
        StandardErrorPath = logFile "rss2email";
      };
    };
  };
}
