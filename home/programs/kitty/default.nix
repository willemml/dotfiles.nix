{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;
    extraConfig = ''
      include themes/draculaplus.conf
      editor "${config.programs.emacs.finalPackage.out}/bin/emacsclient" -nw -c

      macos_option_as_alt yes
    '';
    shellIntegration.enableZshIntegration = true;

    font = {
      package = pkgs.meslo-lgs-nf;
      name = "MesloLGS NF Regular";
      size = 12;
    };
  };

  home.file.".config/kitty/themes".source = ./themes;
}
