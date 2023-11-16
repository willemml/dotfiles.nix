{
  config,
  pkgs,
  lib,
  globals,
  ...
}: {
  home.packages = with pkgs; [
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
    extraConfig = ''
      bind = SHIFT_SUPER, SPACE, exec, alacritty
      bind = SUPER, SPACE, exec, rofi -modes "ssh,drun,window" -show drun
      bind = ALT, SPACE, exec, rofi -show window

      input {
        kb_layout=${globals.keyboard.layout}
        kb_variant=${globals.keyboard.variant}
        sensitivity=0.4
        accel_profile=adaptive
        touchpad {
          natural_scroll=true
          scroll_factor=0.45
          tap-and-drag=true
        }
      }

      gestures {
        workspace_swipe=true
        workspace_swipe_fingers=3
        workspace_swipe_cancel_ratio=0.5
        workspace_swipe_distance=2000
        workspace_swipe_invert=true
      }
    '';
  };
}
