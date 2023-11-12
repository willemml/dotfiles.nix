{
  inputs,
  pkgs,
  ...
}: {
  imports = [./desktop.nix];

  home-manager.sharedModules = [
    {wayland.windowManager.hyprland.enable = true;}
    inputs.hyprland.homeManagerModules.default
  ];

  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages.${pkgs.system}.hyprland;

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
}