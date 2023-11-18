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
    enable = true;

    extraConfig = ''
      exec = ${pkgs.swaybg}/bin/swaybg -i ${config.stylix.image} -m fill
    '';

    settings = {
      bind = [
        "SUPER, SPACE, exec, rofi -modes \"ssh,drun,window\" -show drun"
        "ALT, SPACE, exec, rofi -show window"

        "CONTROL, RETURN, exec, alacritty"

        "SUPER_SHIFT, C, killactive"

        "CONTROL, left, movefocus, l"
        "CONTROL, right, movefocus, r"
        "CONTROL, up, movefocus, u"
        "CONTROL, down, movefocus, d"

        "CONTROL_SUPER, h, movefocus, l"
        "CONTROL_SUPER, i, movefocus, r"
        "CONTROL_SUPER, e, movefocus, u"
        "CONTROL_SUPER, n, movefocus, d"

        "SHIFT_CONTROL, left, movewindow, l"
        "SHIFT_CONTROL, right, movewindow, r"
        "SHIFT_CONTROL, up, movewindow, u"
        "SHIFT_CONTROL, down, movewindow, d"

        "SHIFT_CONTROL, h, movewindow, l"
        "SHIFT_CONTROL, i, movewindow, r"
        "SHIFT_CONTROL, e, movewindow, u"
        "SHIFT_CONTROL, n, movewindow, d"

        "SUPER, left, resizeactive, -10 0"
        "SUPER, right, resizeactive, 10 0"
        "SUPER, up, resizeactive, 0 -10"
        "SUPER, down, resizeactive, 0 10"
      ];

      input = {
        kb_layout = globals.keyboard.layout;
        kb_variant = globals.keyboard.variant;
        sensitivity = 0.4;
        accel_profile = "adaptive";
        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.45;
          tap-and-drag = true;
        };
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_cancel_ratio = 0.5;
        workspace_swipe_distance = 2000;
        workspace_swipe_invert = true;
      };
    };
  };
}
