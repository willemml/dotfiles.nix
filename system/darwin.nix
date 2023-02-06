{ pkgs, ... }:

{
  services.nix-daemon.enable = true;
  services.spotifyd = {
    enable = true;
    settings.use_keyring = true;
    settings.username_cmd = "${pkgs.pass}/bin/pass 'music/spotify' | grep login | cut -f2 -d ' '";
    settings.password_cmd = "${pkgs.pass}/bin/pass 'music/spotify' | head -n1";
  };

  nix.package = pkgs.nix;

  programs.zsh.enable = true;

  system = {
    defaults = {
      loginwindow.SHOWFULLNAME = false;
      loginwindow.GuestEnabled = false;
      loginwindow.DisableConsoleAccess = true;
      finder._FXShowPosixPathInTitle = true;
      LaunchServices.LSQuarantine = false;
    };
    keyboard = {
      enableKeyMapping = true;

      remapCapsLockToEscape = true;

      # see https://developer.apple.com/library/content/technotes/tn2450/_index.html for more info
      userKeyMapping = [{
        HIDKeyboardModifierMappingSrc = 30064771303; # remap right command to right control.
        HIDKeyboardModifierMappingDst = 30064771300;
      }];
    };
  };
}
