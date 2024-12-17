{
  inputs,
  pkgs,
  ...
}: let
  hyprpkgs = inputs.hyprland.packages.${pkgs.system};
in {
  imports = [
    ./gui.nix
    ../modules/polkit.nix
    ../modules/lemurs.nix
  ];

  programs.steam.enable = true;

  programs.hyprland.enable = true;
  programs.hyprland.package = hyprpkgs.hyprland;
  programs.hyprland.portalPackage = hyprpkgs.xdg-desktop-portal-hyprland;

  xdg.portal = {
    enable = true;
    extraPortals = [hyprpkgs.xdg-desktop-portal-hyprland];
  };

  programs.waybar.enable = true;
  programs.waybar.package = pkgs.waybar.overrideAttrs (oldAttrs: {
    mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
  });

  security.pam.services.swaylock.text = "auth include login";

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
}
