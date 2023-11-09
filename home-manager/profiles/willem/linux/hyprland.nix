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
    rofi-wayland
  ];

  services.mako.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
  };

  wayland.windowManager.hyprland.extraConfig = ''
    bind = SHIFT_SUPER, SPACE, exec, alacritty
    bind = SUPER, SPACE, exec, rofi -modes "ssh,drun,window" -show drun
    bind = ALT, SPACE, exec, rofi -show window

    input {
      kb_layout=us
      kb_variant=colemak
    }
  '';
}
