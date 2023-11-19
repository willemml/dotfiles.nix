{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) lists strings;

  floating-apps = [
    "System Settings"
    "Software Update"
    "Kodi"
    "App Store"
    "Activity Monitor"
    "Calculator"
    "Dictionary"
    "mpv"
    "Software Update"
    "Set Desktop Background"
  ];

  floating-rules = lists.forEach floating-apps (
    name: "yabai -m rule --add app='${name}' manage=off"
  );

  floating-rules-str = strings.concatStringsSep "\n" floating-rules;
in {
  imports = [./scripting-additions.nix];

  services.yabai = {
    enable = true;
    enableScriptingAddition = true;

    config = {
      window_origin_display = "focused";
      window_placement = "second_child";
      window_shadow = "on";
      window_border = "off";
      window_border_width = "2";
      active_window_border_color = "0xff$CACTV";
      normal_window_border_color = "0xff$CNORM";
      insert_window_border_color = "0xff$CINSE";
      mouse_follows_focus = "on";
      focus_follows_mouse = "autofocus";
      window_opacity = "off";
      window_opacity_duration = "0.0";
      active_window_opacity = "1.0";
      normal_window_opacity = "0.90";
      split_ratio = "0.50";
      auto_balance = "off";
      mouse_modifier = "ctrl";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      mouse_drop_action = "swap";
      # Turning on breaks kodi
      window_topmost = "off";
      layout = "bsp";
      top_padding = "10";
      bottom_padding = "10";
      left_padding = "10";
      right_padding = "10";
      window_gap = "10";
    };

    extraConfig =
      floating-rules-str
      + "\n"
      + ''
        yabai -m rule --add label="Finder" app="^Finder$" title="(Co(py|nnect)|Move|Info|Pref)" manage=off
        yabai -m rule --add label="Safari" app="^Safari$" title="^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy|Advance)$" manage=off
        yabai -m rule --add label="System Preferences" app="^System Preferences$" title=".*" manage=off
        yabai -m rule --add label="About This Mac" app="System Information" title="About This Mac" manage=off

        set +x

        echo "yabai configuration loaded.."
      '';
  };

  environment.systemPackages = [pkgs.yabai];
}
