{
  lib,
  pkgs,
  config,
  ...
}: {
  services.yabai = {
    enableScriptingAddition = true;
    extraConfig = ''
      yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
      sudo yabai --load-sa
    '';
  };

  environment.etc = {
    "sudoers.d/yabai".text = ''
      willem ALL=(root) NOPASSWD: ${pkgs.yabai}/bin/yabai --load-sa
    '';
  };

  environment.systemPackages = [pkgs.skhd];
  services.skhd.enable = true;

  system.activationScripts.postUserActivation = {
    text = ''
      echo Reloading skhd config
      ${config.services.skhd.package}/bin/skhd --reload
    '';
  };

  services.skhd.skhdConfig = let
    yabai = "${pkgs.yabai}/bin/yabai";
    # Don't use nix emacs. Homebrew has a better version
    # emacs = "${pkgs.emacs}/bin/emacs";
    kitty = "${pkgs.kitty}/bin/kitty";
    # Handle any weird inversion bindings
    cmd = "cmd";
    ctrl = "ctrl";
  in ''
    # Prevent hide
    cmd - h : :
    cmd - m : :
    rcmd - w : :

    ${ctrl} - return : ${kitty} --single-instance

    # Close window
    ${cmd} + shift - c : osascript -e 'tell application "System Events" to perform action "AXPress" of (first button whose subrole is "AXCloseButton") of (first window whose subrole is "AXStandardWindow") of (first process whose frontmost is true)'

    # Restart yabai
    ${cmd} + shift - r : ${yabai} --restart-service

    # Toggle window split type
    # ${ctrl} - v : ${yabai} -m window --toggle split

    # Changes insertion modes
    ${ctrl} - h : ${yabai} -m window --insert east
    ${ctrl} - v : ${yabai} -m window --insert south

    # Moves around windows
    ${ctrl} - left : ${yabai} -m window --focus west
    ${ctrl} - down : ${yabai} -m window --focus south
    ${ctrl} - up : ${yabai} -m window --focus north
    ${ctrl} - right : ${yabai} -m window --focus east

    # Moves windows
    shift + ${ctrl} - left : ${yabai} -m window --warp west
    shift + ${ctrl} - down : ${yabai} -m window --warp south
    shift + ${ctrl} - up : ${yabai} -m window --warp north
    shift + ${ctrl} - right : ${yabai} -m window --warp east

    # Warps window to space
    shift + ${ctrl} - 1 : ${yabai} -m window --space 1 && ${yabai} -m space --focus 1
    shift + ${ctrl} - 2 : ${yabai} -m window --space 2 && ${yabai} -m space --focus 2
    shift + ${ctrl} - 3 : ${yabai} -m window --space 3 && ${yabai} -m space --focus 3
    shift + ${ctrl} - 4 : ${yabai} -m window --space 4 && ${yabai} -m space --focus 4
    shift + ${ctrl} - 5 : ${yabai} -m window --space 5 && ${yabai} -m space --focus 5
    shift + ${ctrl} - 6 : ${yabai} -m window --space 6 && ${yabai} -m space --focus 6
    shift + ${ctrl} - 7 : ${yabai} -m window --space 7 && ${yabai} -m space --focus 7
    shift + ${ctrl} - 8 : ${yabai} -m window --space 8 && ${yabai} -m space --focus 8
    shift + ${ctrl} - 8 : ${yabai} -m window --space 9 && ${yabai} -m space --focus 9
    shift + ${ctrl} - 0 : ${yabai} -m window --space 10 && ${yabai} -m space --focus 10

    # Resize windows
    ${cmd} - left :  ${yabai} -m window --resize left:-50:0; \
                  ${yabai} -m window --resize right:-50:0
    ${cmd} - down :  ${yabai} -m window --resize bottom:0:50; \
                  ${yabai} -m window --resize top:0:50
    ${cmd} - up :    ${yabai} -m window --resize top:0:-50; \
                  ${yabai} -m window --resize bottom:0:-50
    ${cmd} - right : ${yabai} -m window --resize right:50:0; \
                          ${yabai} -m window --resize left:50:0

    # TODO: Add this back in when scripting addons works
    # Changes spaces
    ${ctrl} - 1 : ${yabai} -m space --focus 1
    ${ctrl} - 2 : ${yabai} -m space --focus 2
    ${ctrl} - 3 : ${yabai} -m space --focus 3
    ${ctrl} - 4 : ${yabai} -m space --focus 4
    ${ctrl} - 5 : ${yabai} -m space --focus 5
    ${ctrl} - 6 : ${yabai} -m space --focus 6
    ${ctrl} - 7 : ${yabai} -m space --focus 7
    ${ctrl} - 8 : ${yabai} -m space --focus 8
    ${ctrl} - 9 : ${yabai} -m space --focus 9
    ${ctrl} - 0 : ${yabai} -m space --focus 10

    # Make window native fullscreen
    #${ctrl} - f        : ${yabai} -m window --toggle zoom-fullscreen
    shift + ${ctrl} - f : ${yabai} -m window --toggle zoom-fullscreen

    # Float / Unfloat window
    ${ctrl} + shift - space : \
        ${yabai} -m window --toggle float; \
        ${yabai} -m window --toggle border

    # Open Emacs
    ${ctrl} + shift - n : ${kitty} --single-instance ${config.home-manager.users.willem.programs.emacs.finalPackage}/bin/emacsclient -nw -c
    # Open Firefox window
    ${ctrl} + shift - f : /Applications/Firefox.app/Contents/MacOS/firefox -new-window
  '';
}
