{
  globals,
  pkgs,
  ...
}: {
  stylix.enable = true;
  stylix.image = globals.wallpapers.current;
  stylix.polarity = "dark";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
}
