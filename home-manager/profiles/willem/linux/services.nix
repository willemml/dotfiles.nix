{
  config,
  pkgs,
  lib,
  ...
}: {
  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableZshIntegration = true;
      defaultCacheTtl = 30;
      maxCacheTtl = 600;
    };
    emacs = {
      enable = true;
      package =
        if config.programs.emacs.enable
        then config.programs.emacs.finalPackage
        else pkgs.emacs;
      client.enable = true;
      defaultEditor = true;
      startWithUserSession = true;
    };
  };

  systemd.user.services = {
    offlineimap = {
      Unit = {
        Description = "Runs offlineimap to get email every 15 minutes.";
      };

      Service = {
        ExecStart = "${pkgs.offlineimap}/bin/offlineimap";
        RestartSec = "15min";
        Restart = "always";
      };
    };
  };
}
