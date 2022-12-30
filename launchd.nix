{ lib, config, pkgs, ... }:

{
  launchd = {
    enable = true;

    agents.emacs = {
      enable = true;
      config = {
        ProgramArguments = [ "${pkgs.emacs}/bin/emacs" "--fg-daemon" ];
        KeepAlive.SuccessfulExit = true;
      };
    };

    agents.gpg-daemon = {
      enable = true;
      config = {
        ProgramArguments = [
          "${pkgs.gnupg}/bin/gpg-agent"
          ''
            --pinentry-program="${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac"''
          "--daemon"
        ];
        KeepAlive = true;
      };
    };
  };
}
