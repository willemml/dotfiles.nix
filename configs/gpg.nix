{ config, ... }:

{
  programs.gpg = {
    enable = true;
    homedir = "${config.home.homeDirectory}/.gnupg";
    settings = {
      use-agent = true;
      default-key = "860B5C62BF1FCE4272D26BF8C3DE5DF6198DACBD";
    };
  };
  services.gpg-agent = {
    enable = false;
    enableZshIntegration = true;
    pinentryFlavor = "mac";
  };
}
