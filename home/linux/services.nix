{
  config,
  pkgs,
  lib,
  ...
}: {
  services = {
    ssh-agent.enable = true;

    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableZshIntegration = true;
      defaultCacheTtl = 30;
      maxCacheTtl = 600;
      pinentryFlavor = "tty";
    };

    emacs = {
      enable = true;
      package =
        if config.programs.emacs.enable
        then config.programs.emacs.finalPackage
        else pkgs.emacs;
      client.enable = true;
      startWithUserSession = true;
    };
  };
}
