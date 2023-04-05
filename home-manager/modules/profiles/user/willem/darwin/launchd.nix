{
  lib,
  config,
  pkgs,
  ...
}: {
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
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/emacs-stdout.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/emacs-stderr.log";
      };
    };

    agents.iterm2 = {
      enable = true;
      config = {
        ProgramArguments = ["${pkgs.iterm2}/Applications/iTerm2.app/Contents/MacOS/iTerm2"];
        KeepAlive = true;
        ProcessType = "Interactive";
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/iterm2-stdout.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/iterm2-stderr.log";
      };
    };

    agents.firefox = {
      enable = true;
      config = {
        ProgramArguments = ["${config.programs.firefox.package}/bin/firefox"];
        KeepAlive = true;
        ProcessType = "Interactive";
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/firefox-stdout.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/firefox-stderr.log";
      };
    };

    agents.offlineimap = {
      enable = true;
      config = {
        ProgramArguments = ["${pkgs.offlineimap}/bin/offlineimap"];
        UserName = "${config.home.username}";
        StartInterval = 900;
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/offlineimap-stdout.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/offlineimap-stderr.log";
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
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/rss2email-stdout.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/rss2email-stderr.log";
      };
    };
  };
}
