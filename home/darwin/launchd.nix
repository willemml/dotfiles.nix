{ lib, config, pkgs, ... }:

{
  launchd = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;

    agents.emacs = {
      enable = true;
      config = {
        ProgramArguments = [
          "${config.programs.emacs.finalPackage}/bin/emacs"
          "--fg-daemon"
        ];
        KeepAlive = true;
        UserName = "${config.home.username}";
        ProcessType = "Adaptive";
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/emacs-stdout.log";
        StandardErrorPath =
          "${config.home.homeDirectory}/Library/Logs/emacs-stderr.log";

      };
    };
  };
}
