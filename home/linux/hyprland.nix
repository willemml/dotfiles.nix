{
  config,
  pkgs,
  lib,
  globals,
  osConfig,
  ...
}: let
  host = osConfig.networking.hostName;
in {
  imports = [
    ./fonts.nix
    ./swaylock.nix
    ./waybar.nix
  ];

  home.packages = with pkgs;
    [
      (
        if pkgs.stdenv.isAarch64
        then firefox-wv
        else firefox
      )
      polkit-kde-agent
      lxappearance
      pipewire
      polkit-kde-agent
      qt6.qtwayland
      qt6ct
      xdg-desktop-portal-hyprland
      xdg-desktop-portal
      rofi-wayland
    ]
    ++ (
      if pkgs.stdenv.isAarch64
      then [firefox-wv]
      else [firefox discord]
    );

  # notifications daemon
  services.mako.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      decoration = {
        rounding = 10;

        # save battery
        drop_shadow = false;
        blur.enabled = false;
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
      };

      monitor =
        if host == "voyager"
        then [
          "eDP-1, 3456x2160, 0x0, 1.2"
        ]
        else if host == "thinkpad"
        then [
          "eDP-1, 1920x1080, 0x0, 1.0"
        ]
        else [];

      exec = [
        "${pkgs.swaybg}/bin/swaybg -i ${config.stylix.image} -m fill"
      ];
      exec-once = [
        # Display sleep on idle
        "sleep 60 && ${pkgs.swayidle}/bin/swayidle -w timeout 60 'if ${pkgs.busybox}/bin/pgrep ${pkgs.swaylock-effects}/bin/swaylock; then hyprctl dispatch dpms off; fi' resume 'hyprctl dispatch dpms on' before-sleep '${pkgs.swaylock-effects}/bin/swaylock -f'"

        # Enables clipboard sync
        "${pkgs.wl-clipboard}/bin/wl-paste -p | ${pkgs.wl-clipboard}/bin/wl-copy"
        "${pkgs.wl-clipboard}/bin/wl-paste | ${pkgs.wl-clipboard}/bin/wl-copy -p"

        "${pkgs.swaynotificationcenter}/bin/swaync"

        "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"
      ];

      xwayland.force_zero_scaling = true;

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        vfr = true;
      };

      "$mod" = "SUPER";

      bind = let
        bright = "${pkgs.brightnessctl}/bin/brightnessctl";
      in [
        "$mod, SPACE, exec, rofi -modes \"ssh,drun,window\" -show drun"
        "ALT, SPACE, exec, rofi -show window"

        # swaylock on suspend
        ",switch:Apple SMC power/lid events, exec, ${pkgs.swaylock-effects}/bin/swaylock"
        ",XF86Sleep, exec, ${pkgs.swaylock-effects}/bin/swaylock"

        "$mod, L, exec, ${pkgs.swaylock-effects}/bin/swaylock"
        "SUPER_SHIFT, 4, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp -d)\" - | ${pkgs.wl-clipboard}/bin/wl-copy"

        # brightness controls (need to use F2/3 because XF86Brightness isnt working)
        ",F2, exec, ${bright} s \"$(${bright} g | ${pkgs.busybox}/bin/awk '{ print int(($1 + .72) * 1.4) }')\""
        ",F1, exec, ${bright} s \"$(${bright} g | ${pkgs.busybox}/bin/awk '{ print int($1 / 1.4) }')\""

        # volume controls
        ",XF86AudioRaiseVolume, exec, ${pkgs.ponymix}/bin/ponymix inc 2"
        ",XF86AudioLowerVolume, exec, ${pkgs.ponymix}/bin/ponymix dec 2"

        # workspace switching
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # terminal
        "CONTROL, RETURN, exec, alacritty"

        "SUPER_SHIFT, C, killactive"

        "$mod, F, togglefloating"
        "SUPER_SHIFT, F, fullscreen"

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

        "$mod, left, resizeactive, -10 0"
        "$mod, right, resizeactive, 10 0"
        "$mod, up, resizeactive, 0 -10"
        "$mod, down, resizeactive, 0 10"
      ];

      input = {
        kb_layout = globals.keyboard.layout;
        kb_variant = globals.keyboard.variant;
        sensitivity = 0.4;
        accel_profile = "flat";
        touchpad = {
          natural_scroll = true;
          clickfinger_behavior = true;
          scroll_factor = 0.45;
          drag_lock = true;
          tap-and-drag = true;
        };
      };

      "device:synaptics-tm3053-003" = {
        accel_profile = "adaptive";
        sensitivity = 0.3;
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
