{
  config,
  pkgs,
  stylix,
  osConfig,
  ...
}: let
  networkInterface =
    if osConfig.networking.hostName == "voyager"
    then "wlan0"
    else if osConfig.networking.hostName == "nixbox"
    then "enp0s31f6"
    else if osConfig.networking.hostName == "glassbox"
    then "enp6s0"
    else if osConfig.networking.hostName == "thinkpad"
    then "wlan0"
    else "";
  battery =
    if osConfig.networking.hostName == "voyager"
    then "macsmc-battery"
    else "BAT0";
  colors = config.lib.stylix.colors.withHashtag;
  primaryColor = colors.base04;
  altColor = colors.base0C;
in {
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        spacing = 8;
        margin = "0px 0px 5px 0px";
        modules-left = ["hyprland/workspaces"];
        modules-right = ["network" "cpu" "memory" "disk" "pulseaudio" "battery" "clock"];

        "hyprland/workspaces" = {
          sort-by-number = true;
          on-click = "activate";
          format = "{icon}";
          persistent-workspaces = {
            "1" = "[]";
            "2" = "[]";
            "3" = "[]";
            "4" = "[]";
          };
          format-icons = {
            "urgent" = "<span color='${colors.base08}'></span>";
            "active" = "<span color='${colors.base0C}'></span>";
            "default" = "<span color='${primaryColor}'></span>";
          };
        };

        "clock" = {
          "format" = "<span color='${primaryColor}'> {:%a, %b %d, %Y %R}</span>";
          "tooltip-format" = "<tt><small>{calendar}</small></tt>";
          "calendar" = {
            "mode" = "year";
            "mode-mon-col" = 3;
            "weeks-pos" = "right";
            "on-scroll" = 1;
            "on-click-right" = "mode";
            "format" = {
              "months" = "<span color='${colors.base0D}'><b>{}</b></span>";
              "days" = "<span color='${colors.base05}'><b>{}</b></span>";
              "weeks" = "<span color='${colors.base03}'><b>W{}</b></span>";
              "weekdays" = "<span color='${colors.base05}'><b>{}</b></span>";
              "today" = "<span color='${primaryColor}'><b><u>{}</u></b></span>";
            };
          };
          "actions" = {
            "on-click-right" = "mode";
            "on-scroll-up" = "shift_up";
            "on-scroll-down" = "shift_down";
          };
        };

        "cpu" = {
          "interval" = 2;
          "format" = "<span color='${altColor}'>CPU: {usage}% @ {avg_frequency}GHz</span>";
          "on-click" = "${pkgs.alacritty}/bin/alacritty -e ${pkgs.bottom}/bin/btm";
        };

        "battery" = {
          "bat" = battery;
          "format" = "<span color='${primaryColor}'>Battery: {capacity}% (P)</span>";
          "format-charging" = "<span color='${primaryColor}'>Battery: {capacity}% (C)</span>";
          "format-discharging" = "<span color='${primaryColor}'>Battery: {capacity}% (D)</span>";
        };

        "memory" = {
          "format" = "<span color='${altColor}'>RAM: {used:0.1f}G/{total:0.1f}G</span>";
          "on-click" = "${pkgs.alacritty}/bin/alacritty -e ${pkgs.bottom}/bin/btm";
        };

        "disk" = {
          "format" = "<span color='${primaryColor}'>Disk: {used}/{total}</span>";
          "path" = "/";
        };

        "network" = {
          "interface" = "${networkInterface}";
          "interval" = 2;
          "format-ethernet" = "<span color='${primaryColor}'>Ether: Up: {bandwidthUpBits} Down: {bandwidthDownBits} </span>";
          "tooltip-format-ethernet" = "<span color='${primaryColor}'>{ifname}</span>";
          "format-wifi" = "<span color='${primaryColor}'>WiFi: Up: {bandwidthUpBits} Down: {bandwidthDownBits} ({signalStrength}%)</span>";
          "tooltip-format-wifi" = "<span color='${primaryColor}'>{essid} ({signalStrength}%)</span>";
          "format-disconnected" = "<span color='${primaryColor}'>Disconnected</span>";
          "on-click" = "${pkgs.alacritty}/bin/alacritty -e ${pkgs.iwd}/bin/iwctl";
        };

        "pulseaudio" = {
          "format" = "<span color='${altColor}'>Volume: {volume}%</span>";
          "on-click" = "${pkgs.pavucontrol}/bin/pavucontrol";
        };
      };
    };
  };
}
