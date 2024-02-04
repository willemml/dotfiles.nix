{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      fade-in = 0;

      clock = true;
      timestr = "%R";
      datestr = "%a, %b %d";

      effect-blur = "20x6";

      indicator = true;
      indicator-radius = 320;
      indicator-thickness = 20;

      ignore-empty-password = true;
      disable-caps-lock-text = true;
    };
  };
}
