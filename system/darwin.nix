{ pkgs, ... }:

{
  services.nix-daemon.enable = true;

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
    userKeyMapping = [ {
      HIDKeyboardModifierMappingSrc = 30064771303; # remap right command to right control.
      HIDKeyboardModifierMappingDst = 30064771300; 
    }];
    };
  };
}
