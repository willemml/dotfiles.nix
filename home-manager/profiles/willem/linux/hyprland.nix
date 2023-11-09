{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    alacritty
    discord
    firefox
    lxappearance
    pipewire
    polkit-kde-agent
    qt6.qtwayland
    qt6ct
    xdg-desktop-portal-hyprland
    xdg-desktop-portal
  ];

  gtk = {
    enable = true;
    theme = {
      name = "FlatColor";
    };
  };

  services.mako.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [pkgs.rofi-wayland];
  };

  wayland.windowManager.hyprland.extraConfig = ''
    bind = SHIFT_SUPER, SPACE, exec, alacritty
    bind = SUPER, SPACE, exec, rofy

    input {
      kb_layout=us
      kb_variant=colemak
    }
  '';
}
