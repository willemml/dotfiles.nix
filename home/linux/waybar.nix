{
  config,
  pkgs,
  stylix,
  osConfig,
  ...
}: let
  networkInterface.eth =
    if osConfig.networking.hostName == "voyager"
    then "wlan0"
    else "";
  hwmon =
    if osConfig.networking.hostName == "voyager"
    then "/sys/class/hwmon/hwmon4/temp1_input"
    else "";
  colors = config.lib.stylix.colors.withHashtag;
  primaryColor = colors.base04;
  altColor = colors.base0C;
in {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
    });

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 8;
        margin = "3px 3px 0px 3px";
        modules-left = ["hyprland/workspaces"];
        modules-right = ["network" "cpu" "temperature" "memory" "disk" "pulseaudio" "battery" "tray" "clock"];

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

        "tray"."spacing" = 2;

        "clock" = {
          "format" = "<span color='${primaryColor}'> {:%R} </span>";
          "format-alt" = "<span color='${primaryColor}'> {:%a, %b %d, %Y %R} </span>";
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
          "format" = "<span color='${altColor}'>{usage}%  {avg_frequency}GHz</span>";
          "on-click" = "${pkgs.alacritty}/bin/alacritty -e ${pkgs.bottom}/bin/btm";
        };

        "battery" = {
          "bat" = "macsmc-battery";
          "states" = {
            "good" = 95;
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "<span color='${primaryColor}'>{capacity}% </span>{icon}";
          "format-full" = "";
          "format-icons" = [
            "<span color='${colors.base08}'></span>"
            "<span color='${colors.base09}'></span>"
            "<span color='${colors.base09}'></span>"
            "<span color='${primaryColor}'></span>"
            "<span color='${primaryColor}'></span>"
          ];
        };

        "memory" = {
          "format" = "<span color='${altColor}'>{used:0.1f}G/{total:0.1f}G </span>";
          "on-click" = "${pkgs.alacritty}/bin/alacritty -e ${pkgs.bottom}/bin/btm";
        };

        "disk" = {
          "format" = "<span color='${primaryColor}'>{used}/{total} </span>";
          "path" = "/";
        };

        "network" = {
          "interface" = "${networkInterface.eth}";
          "interval" = 2;
          "format-ethernet" = "<span color='${primaryColor}'>Up: {bandwidthUpBits} Down: {bandwidthDownBits} </span>";
          "tooltip-format-ethernet" = "<span color='${primaryColor}'>{ifname} </span>";
          "format-wifi" = "<span color='${primaryColor}'>Up: {bandwidthUpBits} Down: {bandwidthDownBits} ({signalStrength}%) </span>";
          "tooltip-format-wifi" = "<span color='${primaryColor}'>{ifname} {essid} ({signalStrength}%) </span>";
          "format-disconnected" = "<span color='${primaryColor}'>Disconnected ⚠</span>";
          "on-click" = "${pkgs.alacritty}/bin/alacritty -e ${pkgs.networkmanager}/bin/nmtui";
        };

        "pulseaudio" = {
          "format" = "<span color='${altColor}'>{volume}% {icon}</span>";
          "format-bluetooth" = "<span color='${altColor}'>{volume}% {icon}</span>";
          "format-muted" = "<span color='${altColor}'></span>";
          "format-icons" = {
            "headphones" = "<span color='${altColor}'></span>";
            "handsfree" = "<span color='${altColor}'></span>";
            "headset" = "<span color='${altColor}'></span>";
            "phone" = "<span color='${altColor}'></span>";
            "portable" = "<span color='${altColor}'></span>";
            "car" = "<span color='${altColor}'></span>";
            "default" = [
              "<span color='${altColor}'></span>"
              "<span color='${altColor}'></span>"
            ];
          };
          "on-click" = "${pkgs.pavucontrol}/bin/pavucontrol";
        };

        "temperature" = {
          "hwmon-path" = "${hwmon}";
          "format" = "<span color='${primaryColor}'>{}°C</span>";
          "critical-threshold" = 80;
          "on-click" = "${pkgs.alacritty}/bin/alacritty -e ${pkgs.bottom}/bin/btm";
        };
      };
    };
    style = ''
      window#waybar {
        border-radius: 5px;
      }
    '';
  };
}
