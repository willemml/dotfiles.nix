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
      pinentryFlavor = "curses";
    };
  };
}
