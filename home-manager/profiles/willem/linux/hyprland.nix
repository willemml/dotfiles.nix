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

  wayland.windowManager.hyprland.enable = true;
  services.mako.enable = true;

  wayland.windowManager.hyprland.extraConfig = ''
    bind = SUPER, SPACE, exec, alacritty

    input {
      kb_layout=us
      kb_variant=colemak
    }
  '';
}
