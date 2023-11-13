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
